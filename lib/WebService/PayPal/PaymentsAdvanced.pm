package WebService::PayPal::PaymentsAdvanced;

use Moo;

use feature qw( say state );

use Data::GUID;
use LWP::UserAgent;
use MooX::StrictConstructor;
use Type::Params qw( compile );
use Types::Standard qw( Bool InstanceOf Str );
use Types::URI qw( Uri );
use URI;
use URI::FromHash qw( uri uri_object );
use URI::QueryParam;
use Web::Scraper;
use WebService::PayPal::PaymentsAdvanced::Error::Generic;
use WebService::PayPal::PaymentsAdvanced::Error::iFrame;
use WebService::PayPal::PaymentsAdvanced::Response;
use WebService::PayPal::PaymentsAdvanced::Response::FromHTTP;

has partner => (
    is       => 'ro',
    isa      => Str,
    required => 1,
    default  => 'PayPal'
);

has password => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has payflow_pro_uri => (
    is     => 'lazy',
    isa    => Uri,
    coerce => 1,
);

has payflow_link_uri => (
    is     => 'lazy',
    isa    => Uri,
    coerce => 1,
);

has production_mode => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
);

has ua => (
    is      => 'ro',
    default => sub {
        my $ua = LWP::UserAgent->new;
        $ua->timeout(5);
        return $ua;
    }
);

has user => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has validate_iframe_uri => (
    is      => 'ro',
    isa     => Bool,
    default => 1,
);

has vendor => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

sub _build_payflow_pro_uri {
    my $self = shift;

    return uri_object(
        scheme => 'https',
        host   => $self->production_mode
        ? 'payflowpro.paypal.com'
        : 'pilot-payflowpro.paypal.com'
    );
}

sub _build_payflow_link_uri {
    my $self = shift;

    return uri_object(
        scheme => 'https',
        host   => $self->production_mode
        ? 'payflowlink.paypal.com'
        : 'pilot-payflowlink.paypal.com'
    );
}

sub create_secure_token {
    my $self = shift;
    my $args = shift;

    my $post = $self->_force_upper_case($args);
    $post->{CREATESECURETOKEN} = 'Y';
    $post->{SECURETOKENID} ||= Data::GUID->new->as_string;

    my $content = join '&', $self->_encode_credentials,
        $self->_pseudo_encode_args($post);

    my $http_response
        = $self->ua->post( $self->payflow_pro_uri, Content => $content );

    my $params
        = WebService::PayPal::PaymentsAdvanced::Response::FromHTTP->new(
        http_response => $http_response )->params;

    my $res = WebService::PayPal::PaymentsAdvanced::Response->new( params => $params );
    $self->_validate_secure_token_id( $res, $post->{SECURETOKENID} );

    return $res;
}

sub get_response_from_redirect {
    my $self = shift;
    my %args = @_;

    my $res_from_redirect
        = WebService::PayPal::PaymentsAdvanced::Response::FromRedirect->new(%args);

    return WebService::PayPal::PaymentsAdvanced::Response->new(
        params => $res_from_redirect->params );
}

sub get_response_from_silent_post {
    my $self = shift;
    return $self->get_response_from_redirect(@_);
}

sub iframe_uri {
    my $self = shift;
    state $check = compile( InstanceOf ['WebService::PayPal::PaymentsAdvanced::Response'] );
    my ($response) = $check->(@_);

    my $uri = $self->payflow_link_uri->clone;
    $uri->query_param(
        SECURETOKEN => $response->secure_token,
    );
    $uri->query_param(
        SECURETOKENID => $response->secure_token_id,
    );

    return $uri unless $self->validate_iframe_uri;

    # For whatever reason on the PayPal side, HEAD isn't useful here.
    my $res = $self->ua->get($uri);

    unless ( $res->is_success ) {

        WebService::PayPal::PaymentsAdvanced::Error::HTTP->throw(
            message       => "iframe URI does not validate: $uri",
            http_response => $res,
            http_status   => $res->code,
        );

    }

    my $error_scraper = scraper {
        process ".error", error => 'TEXT';
    };

    my $scraped_text = $error_scraper->scrape($res);

    return $uri unless exists $scraped_text->{error};

    WebService::PayPal::PaymentsAdvanced::Error::iFrame->throw(
        message => "iframe contains error message: $scraped_text->{error}",
        http_response => $res,
    );
}

sub _validate_secure_token_id {
    my $self     = shift;
    my $res      = shift;
    my $token_id = shift;

    # This should only happen if bad actors are involved.
    if ( $res->secure_token_id ne $token_id ) {
        WebService::PayPal::PaymentsAdvanced::Error::Generic->throw(
            message => sprintf(
                'Secure token ids do not match. Yours: %s. From response: %s.',
                $token_id, $res->secure_token_id
            ),
            params => $res->params,
        );
    }
}

# The authentication args will not contain characters which need to be handled
# specially.  Also, I think adding the length to these keys actually just
# doesn't work.

sub _encode_credentials {
    my $self = shift;

    my %auth = (
        PARTNER => $self->partner,
        PWD     => $self->password,
        USER    => $self->user,
        VENDOR  => $self->vendor,
    );

    # Create key/value pairs the way that PayPal::PaymentsAdvanced wants them.
    my $pairs = join '&', map { $_ . '=' . $auth{$_} } sort keys %auth;
    return $pairs;
}

sub _force_upper_case {
    my $self = shift;
    my $args = shift;
    my %post = map { uc $_ => $args->{$_} } keys %{$args};
    return \%post;
}

# Payments Advanced treats encoding key/value pairs like a special snowflake.
# https://metacpan.org/source/PLOBBES/Business-OnlinePayment-PayPal::PaymentsAdvanced-1.01/PayPal::PaymentsAdvanced.pm#L276

sub _pseudo_encode_args {
    my $self = shift;
    my $args = shift;

    my $uri = join '&', map {
        join '=', sprintf( '%s[%i]', $_, length( $args->{$_} ) ), $args->{$_}
    } sort keys %{$args};
    return $uri;
}

1;

__END__
#ABSTRACT: A simple wrapper around the PayPal::PaymentsAdvanced web service
