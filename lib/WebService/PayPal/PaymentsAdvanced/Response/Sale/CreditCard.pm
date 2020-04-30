package WebService::PayPal::PaymentsAdvanced::Response::Sale::CreditCard;

use Moo;

use namespace::autoclean;

our $VERSION = '0.000027';

extends 'WebService::PayPal::PaymentsAdvanced::Response::Sale';

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard',
);

1;
__END__
# ABSTRACT: Response class for credit card Sale transactions

=head1 DESCRIPTION

Response class for credit card Sale transactions C<TRXTYPE=S>  You should not
create this response object directly. This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response::Sale> and includes the
methods provided by
L<WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard>.
