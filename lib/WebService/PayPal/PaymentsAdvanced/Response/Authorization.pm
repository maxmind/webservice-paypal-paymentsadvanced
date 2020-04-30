package WebService::PayPal::PaymentsAdvanced::Response::Authorization;

use Moo;

use namespace::autoclean;

our $VERSION = '0.000027';

extends 'WebService::PayPal::PaymentsAdvanced::Response';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime',
    'WebService::PayPal::PaymentsAdvanced::Role::HasTender';

1;
__END__
# ABSTRACT: Response class for Sale transactions

=head1 DESCRIPTION

Response class for Authorization transactions C<TRXTYPE=A>  You should not create this
response object directly. This module inherits from
L<WebService::PayPal::PaymentsAdvanced::Response> and includes the methods
provided by L<WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime>
and L<WebService::PayPal::PaymentsAdvanced::Role::HasTender>.
