package WebService::PayPal::PaymentsAdvanced::Response::Inquiry;

use Moo;

our $VERSION = '0.000014';

extends 'WebService::PayPal::PaymentsAdvanced::Response';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime',
    'WebService::PayPal::PaymentsAdvanced::Role::HasTender';

1;
__END__

# ABSTRACT: Response class for Inquiry transactions

=pod

=head1 DESCRIPTION

Response class for Inquiry transactions C<TRXTYPE=I>  You should not create
this response object directly. This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response> and includes the methods
provided by L<WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime>
and L<WebService::PayPal::PaymentsAdvanced::Role::HasTender>.
