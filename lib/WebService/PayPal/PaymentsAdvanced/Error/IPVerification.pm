package WebService::PayPal::PaymentsAdvanced::Error::IPVerification;

use Moo;

use namespace::autoclean;

our $VERSION = '0.000023';

extends 'Throwable::Error';

use Types::Common::String qw( NonEmptyStr );

has ip_address => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
);

with 'WebService::PayPal::PaymentsAdvanced::Role::HasParams';

1;

# ABSTRACT: A Payments Advanced IP verification error

=head1 SYNOPSIS

    use Try::Tiny;
    use WebService::PayPal::PaymentsAdvanced;

    my $payments = WebService::PayPal::PaymentsAdvanced->new(...);

    my $redirect_response;

    my $uri;
    try {
        $redirect_response = $payments->get_response_from_redirect(
            ip_address => $ip,
            params     => $params,
        );
    }
    catch {
        die $_ unless blessed $_;
        if (
            $_->isa(
                'WebService::PayPal::PaymentsAdvanced::Error::IPVerification')
            ) {
            log_fraud(
                message              => $_->message,
                fraudster_ip_address => $_->ip_address,
            );
        }

        # handle other exceptions
    };

=head1 DESCRIPTION

This class represents an error in validating the ip_address which has posted
back a PayPal return or silent POST url.  It will only occur if you provide an
IP address to the
L<WebService::PayPal::PaymentsAdvanced/get_response_from_redirect> or
L<WebService::PayPal::PaymentsAdvanced/get_response_from_silent_post>

It extends L<Throwable::Error> and adds two attributes of its own.  The message
attribute (inherited from L<Throwable::Error>) will contain the error message
which was parsed out of the content of the HTML.

=head1 METHODS

The C<< $error->message() >>, and C<< $error->stack_trace() >> methods are
inherited from L<Throwable::Error>.

=head2 ip_address

Returns the IP address of the request which was made to your application.

=head2 params

Returns a C<HashRef> of params which was received from to PayPal.

=cut
