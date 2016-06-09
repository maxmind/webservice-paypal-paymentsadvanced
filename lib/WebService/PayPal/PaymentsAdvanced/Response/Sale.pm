package WebService::PayPal::PaymentsAdvanced::Response::Sale;

use Moo;

our $VERSION = '0.000020';

extends 'WebService::PayPal::PaymentsAdvanced::Response';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime',
    'WebService::PayPal::PaymentsAdvanced::Role::HasTender';

1;
__END__
# ABSTRACT: Response class for Sale transactions

=head1 DESCRIPTION

Response class for Sale transactions C<TRXTYPE=S>  You should not create this
response object directly. This module inherits from
L<WebService::PayPal::PaymentsAdvanced::Response> and includes the methods
provided by L<WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime>
and L<WebService::PayPal::PaymentsAdvanced::Role::HasTender>.
