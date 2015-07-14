package WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST;

use Moo;

# The logic for these two classes is exactly the same.  We subclass rather than
# using roles so that we don't have to duplicate the BUILD method.

extends 'WebService::PayPal::PaymentsAdvanced::Response::FromRedirect';

1;

__END__
# ABSTRACT: Parse Payments Advanced response params which originate from a silent POST

=head1 DESCRIPTION

This module has the same internals and public interface as
L<WebService::PayPal::PaymentsAdvanced::Response::FromRedirect>.

=cut
