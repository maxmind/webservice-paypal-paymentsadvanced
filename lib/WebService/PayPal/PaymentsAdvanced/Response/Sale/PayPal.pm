package WebService::PayPal::PaymentsAdvanced::Response::Sale::PayPal;

use Moo;

our $VERSION = '0.000018';

extends 'WebService::PayPal::PaymentsAdvanced::Response::Sale';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasPayPal';

1;

__END__
# ABSTRACT: Response class for PayPal Sale transactions

=head1 DESCRIPTION

Response class for Sale transactions C<TRXTYPE=S>  You should not create this
response object directly. This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response::Sale> and includes the
methods provided by L<WebService::PayPal::PaymentsAdvanced::Role::HasPayPal>.
