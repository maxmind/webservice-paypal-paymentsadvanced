package WebService::PayPal::PaymentsAdvanced::Error::Generic;

use Moo;

use namespace::autoclean;

our $VERSION = '0.000025';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasParams';

extends 'Throwable::Error';

1;

# ABSTRACT: A generic error

=head1 SYNOPSIS

    use Try::Tiny;
    use WebService::PayPal::PaymentsAdvanced;
    my $payments = WebService::PayPal::PaymentsAdvanced->new(...);

    try {
        $payments->create_secure_token(...);
    }
    catch {
        die $_ unless blessed $_;
        if ( $_->isa('WebService::PayPal::PaymentsAdvanced::Error::Generic') )
        {
            log_generic_error(
                message => $_->message,
                params  => $_->params,
            );
        }

        # handle other exceptions
    };

=head1 DESCRIPTION

This class represents a generic error. It extends L<Throwable::Error>
and adds one attribute of its own.

=head1 METHODS

The C<< $error->message() >>, and C<< $error->stack_trace() >> methods are
inherited from L<Throwable::Error>.

=head2 params

Returns a C<HashRef> of params which was received from PayPal.

=cut
