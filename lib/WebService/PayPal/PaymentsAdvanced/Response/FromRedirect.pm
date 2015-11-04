package WebService::PayPal::PaymentsAdvanced::Response::FromRedirect;

use Moo;

our $VERSION = '0.000009';

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasParams',
    'WebService::PayPal::PaymentsAdvanced::Role::HasMessage',
);

1;

__END__
# ABSTRACT: Response object for generated via HashRef of GET params

=head1 DESCRIPTION

This module provides an interface for extracting returned params from an
L<HTTP::Response> object.  You won't need to this module directly if you are
using L<PayPal::PaymentsAdvanced/create_secure_token>.

Throws a L<WebService::PayPal::PaymentsAdvanced::Error::HTTP> exception if the
HTTP request was not successful.

=head1 OBJECT INSTANTIATION

The following parameters can be supplied to C<new()> when creating a new object.

=head2 Required Parameters

=head3 params

Returns a C<HashRef> of parameters which have been returned from PayPal via a
redirect or a silent POST.

=head2 Methods

=head3 params

Returns the same C<HashRef> of parameters which was initially provided to the
C<new> method.

=head2 message

Returns the value of the C<RESPMSG> param.

=cut
