package WebService::PayPal::PaymentsAdvanced::Response::Void;

use Moo;

use namespace::autoclean;

our $VERSION = '0.000026';

extends 'WebService::PayPal::PaymentsAdvanced::Response';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime';

1;
__END__

# ABSTRACT: Response class for voiding transactions

=pod

=head1 DESCRIPTION

Response class for transaction voiding C<TRXTYPE=V>  You should not
create this response object directly.  This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response> and includes the methods
provided by L<WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime>.
