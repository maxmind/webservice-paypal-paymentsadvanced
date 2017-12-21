package WebService::PayPal::PaymentsAdvanced::Response::Capture;

use Moo;

use namespace::autoclean;

our $VERSION = '0.000025';

extends 'WebService::PayPal::PaymentsAdvanced::Response';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime';

1;
__END__

# ABSTRACT: Response class for Capture transactions

=pod

=head1 DESCRIPTION

Response class for captured delayed transactions C<TRXTYPE=D>  You should not
create this response object directly.  This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response> and includes the methods
provided by L<WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime>.
