package WebService::PayPal::PaymentsAdvanced;

use Moo;

use feature qw( say state );

use Data::GUID;
use LWP::UserAgent;
use MooX::StrictConstructor;
use Type::Params qw( compile );
use Types::Standard qw( Bool HashRef InstanceOf Str );
use Types::URI qw( Uri );
use URI;
use URI::FromHash qw( uri uri_object );
use URI::QueryParam;
use Web::Scraper;
use WebService::PayPal::PaymentsAdvanced::Error::Generic;
use WebService::PayPal::PaymentsAdvanced::Error::HostedForm;
use WebService::PayPal::PaymentsAdvanced::Response;
use WebService::PayPal::PaymentsAdvanced::Response::FromHTTP;
use WebService::PayPal::PaymentsAdvanced::Response::FromRedirect;
use WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST;

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

    state $check = compile( HashRef );
    my ($args) = $check->(@_);

    my $post = $self->_force_upper_case($args);

    $post->{CREATESECURETOKEN} = 'Y';
    $post->{SECURETOKENID} ||= Data::GUID->new->as_string;

    my $res = $self->post($post);

    $self->_validate_secure_token_id( $res, $post->{SECURETOKENID} );

    return $res;
}

sub get_response_from_redirect {
    my $self = shift;

    state $check = compile( HashRef );
    my ($args) = $check->(@_);

    my $response
        = WebService::PayPal::PaymentsAdvanced::Response::FromRedirect->new(
        $args);

    return WebService::PayPal::PaymentsAdvanced::Response->new(
        params => $response->params );
}

sub get_response_from_silent_post {
    my $self = shift;

    state $check = compile( HashRef );
    my ($args) = $check->(@_);

    my $response
        = WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST
        ->new($args);

    return WebService::PayPal::PaymentsAdvanced::Response->new(
        params => $response->params );
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

sub post {
    my $self = shift;

    state $check = compile( HashRef );
    my ($post) = $check->(@_);

    $post = $self->_force_upper_case($post);

    my $content = join '&', $self->_encode_credentials,
        $self->_pseudo_encode_args($post);

    my $http_response
        = $self->ua->post( $self->payflow_pro_uri, Content => $content );

    my $params
        = WebService::PayPal::PaymentsAdvanced::Response::FromHTTP->new(
        http_response => $http_response )->params;

    return WebService::PayPal::PaymentsAdvanced::Response->new(
        params => $params );
}

sub void_transaction {
    my $self  = shift;

    state $check = compile( Str );
    my ($pnref) = $check->(@_);

    return $self->post( { TRXTYPE => 'V', ORIGID => $pnref } );
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

=head1 SYNOPSIS

    use WebService::PayPal::PaymentsAdvanced;
    my $payments = WebService::PayPal::PaymentsAdvanced->new(
        {
            password => 'seekrit',
            user     => 'username',
            vendor   => 'somevendor',
        }
    );

    my $response = $payments->create_secure_token(
        {
            AMT            => 100,
            TRXTYPE        => 'S',
            VERBOSITY      => 'HIGH',
            BILLINGTYPE    => 'MerchantInitiatedBilling',
            CANCELURL      => 'https://example.com/cancel',
            ERRORURL       => 'https://example.com/error',
            L_BILLINGTYPE0 => 'MerchantInitiatedBilling',
            NAME           => 'Chuck Norris',
            RETURNURL      => 'https://example.com/return',
        }
    );

    my $uri = $payments->hosted_form_uri( $response );

    # Store token data for later use.  You'll need to implement this yourself.
    $foo->freeze_token_data(
        token    => $response->secure_token,
        token_id => $response->secure_token_id,
    );

    # Later, when PayPal returns a silent POST or redirects the user to your
    # return URL:

    my $redirect_response = $payments->get_response_from_redirect(
        ip_address => $ip,
        params     => $params,
    );

    # Fetch the tokens from the original request. You'll need to implement
    # this yourself.

    my $thawed = $foo->get_thawed_tokens(...);

    # Don't do anything until you're sure the tokens are ok.
    if (   $thawed->secure_token ne $redirect->secure_token
        || $thawed->secure_token_id ne $response->secure_token_id ) {
        die 'Fraud!';
    }

    # Everything looks good.  Carry on!

print $response->secure_token;

=head1 DESCRIPTION

BETA BETA BETA.  The interface is still subject to change.

This is a wrapper around the "PayPal Payments Advanced" (AKA "PayPal Payflow
Link") hosted forms.  This code does things like facilitating secure token
creation, providing an URL which you can use to insert an hosted_form into
your pages and processing the various kinds of response you can get from
PayPal.

We also use various exception classes to make it easier for you to decide how
to handle the parts that go wrong.

=head1 OBJECT INSTANTIATION

The following parameters can be supplied to C<new()> when creating a new object.

=head2 Required Parameters

=head3 password

The value of the C<password> field you use when logging in to the Payflow
Manager.  (You'll probably want to create a specific user just for API calls).

=head3 user

The value of the C<user> field you use when logging in to the Payflow Manager.

=head3 vendor

The value of the C<vendor> field you use when logging in to the Payflow
Manager.

=head2 Optional Parameters

=head3 partner

The value of the C<partner> field you use when logging in to the Payflow
Manager. Defaults to C<PayPal>.

=head3 payflow_pro_uri

The hostname for the Payflow Pro API.  This is where token creation requests
get directed.  This already has a sensible (and correct) default, but it is
settable so that you can more easily mock API calls when testing.

=head3 payflow_link_uri

The hostname for the Payflow Link website.  This is the hosted service where
users will enter their payment information.  This already has a sensible (and
correct) default, but it is settable in case you want to mock it while testing.

=head3 production_mode

This is a C<Boolean>.  Set this to C<true> if when you are ready to process
real transactions.  Defaults to C<false>.

=head3 ua

You may provide your own UserAgent, but it must be of the L<LWP::UserAgent>
family.  If you do provide a UserAgent, be sure to set a sensible timeout
value.

This can be useful for debugging.  You'll be able to get detailed information
about the network calls which are being made.

    use LWP::ConsoleLogger::Easy qw( debug_ua );
    use LWP::UserAgent;
    use WebService::PayPal::PaymentsAdvanced;

    my $ua = LWP::UserAgent;
    debug_ua($ua);

    my $payments
        = WebService::PayPal::PaymentsAdvanced->new( ua => $ua, ... );

    # Now fire up a console and watch your network activity.

Check the tests which accompany this distribution for an example of how to mock
API calls using L<Test::LWP::UserAgent>.

=head3 validate_hosted_form_uri

C<Boolean>.  If enabled, this module will attempt to GET the uri which you'll
be providing to the end user.  This can help you identify issues on the PayPal
side.  This is helpful because you'll be able to log exceptions thrown by this
method and deal with them accordingly.  If you disable this option, you'll need
to rely on end users to report issues which may exist within PayPal's hosted
pages.  Defaults to C<true>.

=head2 Methods

=head3 create_secure_token

Create a secure token which you can use to create a hosted form uri.  Returns a
L<WebService::PayPal::PaymentsAdvanced::Response> object.

    use WebService::PayPal::PaymentsAdvanced;
    my $payments = WebService::PayPal::PaymentsAdvanced->new(...);

    my $response = $payments->create_secure_token(
        {
            AMT            => 100,
            TRXTYPE        => 'S',
            VERBOSITY      => 'HIGH',
            BILLINGTYPE    => 'MerchantInitiatedBilling',
            CANCELURL      => 'https://example.com/cancel',
            ERRORURL       => 'https://example.com/error',
            L_BILLINGTYPE0 => 'MerchantInitiatedBilling',
            NAME           => 'Chuck Norris',
            RETURNURL      => 'https://example.com/return'
        }
    );

    print $response->secure_token;

=head3 get_response_from_redirect

This method can be used to parse responses from PayPal to your return URL.
It's essentially a wrapper around
L<WebService::PayPal::PaymentsAdvanced::Response::FromRedirect>.  Returns a
L<WebService::PayPal::PaymentsAdvanced::Response> object.

    my $response = $payments->get_response_from_redirect(
        params     => $params,
    );
    print $response->message;

=head3 get_response_from_silent_post

This method can be used to validate responses from PayPal to your silent POST
url.  It's essentially a wrapper around
L<WebService::PayPal::PaymentsAdvanced::Response::FromSilentPost>.  If you
provide an ip_address parameter, it will be validated against a list of known
IPs which PayPal provides.  You're encouraged to provide an IP address in order
to prevent spoofing of payment responses.  See
L<WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST> for more
information on this behaviour.

This method returns a L<WebService::PayPal::PaymentsAdvanced::Response> object.

    my $response = $payments->get_response_from_redirect(
        ip_address => $ip,
        params     => $params,
    );
    print $response->message;

=head3 hosted_form_uri

Returns a L<URI> object which you can use either to insert an iframe into your
pages or redirect the user to PayPal directly in order to make a payment.

    use WebService::PayPal::PaymentsAdvanced;
    my $payments = WebService::PayPal::PaymentsAdvanced->new(
        validate_hosted_form_uri => 1, ... );

    my $response = $payments->create_secure_token(...);
    my $uri      = $payments->hosted_form_uri($response);

=head3 post

Generic method to post arbitrary params to PayPal.  Requires a C<HashRef> of
parameters and returns a L<WebService::PayPal::PaymentsAdvanced::Response>
object.  Any lower case keys will be converted to upper case before this
response is sent.

    use WebService::PayPal::PaymentsAdvanced;
    my $payments = WebService::PayPal::PaymentsAdvanced->new(...);

    my $response = $payments->post( { TRXTYPE => 'V', ORIGID => $pnref, } );
    say $response->message;

    # OR
    my $response = $payments->post( { trxtype => 'V', origid => $pnref, } );

=cut
