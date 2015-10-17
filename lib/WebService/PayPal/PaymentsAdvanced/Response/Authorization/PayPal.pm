package WebService::PayPal::PaymentsAdvanced::Response::Authorization::PayPal;

use Moo;

extends 'WebService::PayPal::PaymentsAdvanced::Response::Authorization';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasPayPal';

1;

__END__
# ABSTRACT: Response class for PayPal Authorization transactions

=head1 DESCRIPTION

Response class for Authorization transactions C<TRXTYPE=A>  You should not
create this response object directly. This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response::Authorization> and includes
the methods provided by
L<WebService::PayPal::PaymentsAdvanced::Role::HasPayPal>.