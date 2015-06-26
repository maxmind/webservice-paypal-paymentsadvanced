package WebService::PayflowPro;

use Moo;

use feature qw( say );

use Data::GUID;
use LWP::UserAgent;
use MooX::StrictConstructor;
use Types::Standard qw( Bool InstanceOf Str );
use URI;
use URI::FromHash qw( uri uri_object );
use URI::QueryParam;
use WebService::PayflowPro::Error::Generic;
use WebService::PayflowPro::Response;
use WebService::PayflowPro::Response::FromHTTP;

has host => (
    is => 'lazy',
);

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

has production_mode => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
);

has ua => (
    is      => 'ro',
    default => sub {
        LWP::UserAgent->new;
    }
);

has user => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has vendor => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

sub _build_host {
    my $self = shift;
    return $self->production_mode
        ? 'payflowpro.paypal.com'
        : 'pilot-payflowpro.paypal.com';
}

sub create_secure_token {
    my $self = shift;
    my $args = shift;

    my $post = $self->_force_upper_case($args);
    $post->{CREATESECURETOKEN} = 'Y';
    $post->{SECURETOKENID} ||= Data::GUID->new->as_string;

    my $payflow_url = uri( scheme => 'https', host => $self->host );

    my $content = join '&', $self->_encode_credentials,
        $self->_pseudo_encode_args($post);

    my $http_response = $self->ua->post( $payflow_url, Content => $content );

    my $params
        = WebService::PayflowPro::Response::FromHTTP->new(
        http_response => $http_response )->params;

    my $res = WebService::PayflowPro::Response->new( params => $params );

    # This should only happen if bad actors are involved.
    if ( $res->secure_token_id ne $post->{SECURETOKENID} ) {
        WebService::PayflowPro::Error::Generic->throw(
            message => sprintf(
                'Secure token ids do not match: yours(%s) theirs (%s)',
                $post->{SECURETOKENID}, $res->secure_token_id
            ),
            params => $res->params
        );
    }

    return $res;
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

    # Create key/value pairs the way that PayflowPro wants them.
    my $pairs = join '&', map { $_ . '=' . $auth{$_} } sort keys %auth;
    return $pairs;
}

sub _force_upper_case {
    my $self = shift;
    my $args = shift;
    my %post = map { uc $_ => $args->{$_} } keys %{$args};
    return \%post;
}

# Payflow treats encoding key/value pairs like a special snowflake.
# https://metacpan.org/source/PLOBBES/Business-OnlinePayment-PayflowPro-1.01/PayflowPro.pm#L276

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
#ABSTRACT: A simple wrapper around the PayflowPro web service
