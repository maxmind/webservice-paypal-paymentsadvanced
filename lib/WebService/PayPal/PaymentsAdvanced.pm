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
use WebService::PayPal::PaymentsAdvanced::Error::HostedForm;
use WebService::PayPal::PaymentsAdvanced::Response;
use WebService::PayPal::PaymentsAdvanced::Response::FromHTTP;

has partner => (
    is       => 'ro',
    isa      => Str,
    required => 1,
    default  => 'PayPal',
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

has validate_hosted_form_uri => (
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

    my $res = WebService::PayPal::PaymentsAdvanced::Response->new(
        params => $params );
    $self->_validate_secure_token_id( $res, $post->{SECURETOKENID} );

    return $res;
}

sub get_response_from_redirect {
    my $self = shift;
    my %args = @_;

    my $res_from_redirect
        = WebService::PayPal::PaymentsAdvanced::Response::FromRedirect->new(
        %args);

    return WebService::PayPal::PaymentsAdvanced::Response->new(
        params => $res_from_redirect->params );
}

sub get_response_from_silent_post {
    my $self = shift;
    return $self->get_response_from_redirect(@_);
}

sub hosted_form_uri {
    my $self = shift;
    state $check = compile(
        InstanceOf ['WebService::PayPal::PaymentsAdvanced::Response'] );
    my ($response) = $check->(@_);

    my $uri = $self->payflow_link_uri->clone;
    $uri->query_param( SECURETOKEN   => $response->secure_token, );
    $uri->query_param( SECURETOKENID => $response->secure_token_id, );

    return $uri unless $self->validate_hosted_form_uri;

    # For whatever reason on the PayPal side, HEAD isn't useful here.
    my $res = $self->ua->get($uri);

    unless ( $res->is_success ) {

        WebService::PayPal::PaymentsAdvanced::Error::HTTP->throw(
            message       => "hosted_form URI does not validate: $uri",
            http_response => $res,
            http_status   => $res->code,
        );

    }

    my $error_scraper = scraper {
        process( '.error', error => 'TEXT' );
    };

    my $scraped_text = $error_scraper->scrape($res);

    return $uri unless exists $scraped_text->{error};

    WebService::PayPal::PaymentsAdvanced::Error::HostedForm->throw(
        message =>
            "hosted_form contains error message: $scraped_text->{error}",
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
#ABSTRACT: A simple wrapper around the PayPal Payments Advanced web service

=head1 DESCRIPTION

This is a wrapper around the "PayPal Payments Advanced" hosted forms.  This
service is also known as "PayPal Payflow Link".  This code does things like
facilitate secure token creation, providing an URL which you can use to insert
an hosted_form into your pages and processing the various kinds of response you can
get from PayPal.

We also use various exception classses to make it easier for you to decide how to
handle the parts that go wrong.

=head1 OBJECT INSTANTIATION

The following parameters can be supplied to C<new()> when creating a new object.

=head2 partner

The value of the C<partner> field you use when logging in to the Payflow
Manager. Defaults to C<PayPal>.

=head2 password

The value of the C<password> field you use when logging in to the Payflow
Manager.  (You'll probably want to create a specific user just for API calls).

=head2 payflow_pro_uri

The hostname for the Payflow Pro API.  This is where token creation requests
get directed.  This already has a sensible (and correct) default, but it is
settable so that you can more easily mock API calls when testing.

=head2 payflow_link_uri

The hostname for the Payflow Link website.  This is the hosted service where
users will enter their payment information.  This already has a sensible (and
correct) default, but it is settable in case you want to mock it while testing.

=head2 production_mode

This is a Boolean.  Set this to C<true> if when you are ready to process real
transactions.  Defaults to C<false>.

=head2 ua

If you like, you can provide your own UserAgent.  It must be of the
L<LWP::UserAgent family.  Check the tests which accompany this distribution for
an example of how to mock API calls using L<Test::LWP::UserAgent>.

You can also use this parameter to get detailed information about the network
calls which are being made.

    use LWP::ConsoleLogger::Easy debug( ua );
    use LWP::UserAgent;
    use WebService::PayPal::PaymentsAdvanced;

    my $ua = LWP::UserAgent;
    debug_ua( $ua );

    my $payments = WebService::PayPal::PaymentsAdvanced->new( ua => $ua, ... );
    # Now fire up a console and watch your network activity.

=head2 user

The value of the C<user> field you use when logging in to the Payflow Manager.

=head2 validate_hosted_form_uri

=head2 vendor

The value of the C<vendor> field you use when logging in to the Payflow Manager.

=head2 create_secure_token

=head2 get_response_from_redirect

=head2 get_response_from_silent_post

=head2 hosted_form_uri

=cut
