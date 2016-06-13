package WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST::PayPal;

use Moo;

our $VERSION = '0.000021';

extends 'WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasPayPal';

1;

__END__

# ABSTRACT: Response class for PayPal Silent POST transactions

=pod

=head1 DESCRIPTION

Response class for PayPal Silent POST transactions C<TRXTYPE=I>  You should not
create this response object directly.  This class inherits from
L<WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST> and includes
the methods provided by
L<WebService::PayPal::PaymentsAdvanced::Role::HasPayPal>.
