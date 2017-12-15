package WebService::PayPal::PaymentsAdvanced::Response::Authorization::CreditCard;

use Moo;

use namespace::autoclean;

our $VERSION = '0.000024';

extends 'WebService::PayPal::PaymentsAdvanced::Response::Authorization';

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard',
);

1;
__END__
# ABSTRACT: Response class for credit card Authorization transactions

=head1 DESCRIPTION

Response class for credit card Authorization transactions C<TRXTYPE=A>  You
should not create this response object directly. This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response::Authorization> and includes
the methods provided by
L<WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard>.
