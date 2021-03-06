package WebService::PayPal::PaymentsAdvanced::Response::Inquiry::PayPal;

use Moo;

use namespace::autoclean;

our $VERSION = '0.000028';

extends 'WebService::PayPal::PaymentsAdvanced::Response::Inquiry';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasPayPal';

1;
__END__

# ABSTRACT: Response class for PayPal Inquiry transactions

=pod

=head1 DESCRIPTION

Response class for PayPal Inquiry transactions C<TRXTYPE=I>  You should not
create this response object directly. This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response::Inquiry> and includes the
methods provided by L<WebService::PayPal::PaymentsAdvanced::Role::HasPayPal>.
