package WebService::PayPal::PaymentsAdvanced::Error::Authentication;

use Moo;

our $VERSION = '0.000009';

extends 'Throwable::Error';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasParams';

1;

# ABSTRACT: A Payments Advanced authentication error

=head1 SYNOPSIS

    use Try::Tiny;
    use WebService::PayPal::PaymentsAdvanced;
    my $payments = WebService::PayPal::PaymentsAdvanced->new(...);

    try {
        $payments->create_secure_token(...);
    }
    catch {
        die $_ unless blessed $_;
        if (
            $_->isa(
                'WebService::PayPal::PaymentsAdvanced::Error::Authentication')
            ) {
            log_auth_error(
                message => $_->message,
                params  => $_->params,
            );
        }

        # handle other exceptions
    };

=head1 DESCRIPTION

This class represents an authentication error returned by PayPal. It extends
L<Throwable::Error> and adds one attribute of its own.

=head1 METHODS

The C<$error->message()>, and C<$error->stack_trace()> methods are
inherited from L<Throwable::Error>.

=head2 params

Returns a C<HashRef> of params which was received from to PayPal.

=cut
