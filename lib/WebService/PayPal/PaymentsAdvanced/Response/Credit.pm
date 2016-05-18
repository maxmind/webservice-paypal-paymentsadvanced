package WebService::PayPal::PaymentsAdvanced::Response::Credit;

use Moo;

our $VERSION = '0.000019';

extends 'WebService::PayPal::PaymentsAdvanced::Response';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime';

1;
__END__

# ABSTRACT: Response class to refund (credit) transactions

=pod

=head1 DESCRIPTION

Response class for transaction refunding C<TRXTYPE=C>  You should not
create this response object directly.  This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response> and includes the methods
provided by L<WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime>.
