package WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST::CreditCard;

use Moo;

our $VERSION = '0.000019';

extends 'WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST';

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard',
);

1;

__END__

# ABSTRACT: Response class for Credit Card Silent POST transactions

=pod

=head1 DESCRIPTION

Response class for Credit Card Silent POST transactions C<TRXTYPE=I>  You
should not create this response object directly.  This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST> and includes
the methods provided by
L<WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard>.
