package WebService::PayPal::PaymentsAdvanced::Response;

use Moo;

use Types::Standard qw( HashRef Str );
use WebService::PayPal::PaymentsAdvanced::Error::Authentication;
use WebService::PayPal::PaymentsAdvanced::Error::Generic;

# XXX responses with tokens should be in a different class

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasParams',
    'WebService::PayPal::PaymentsAdvanced::Role::HasMessage',
    'WebService::PayPal::PaymentsAdvanced::Role::HasResultValidation',
);

sub BUILD {
    my $self = shift;
    $self->_validate_result;
}

1;

__END__
#ABSTRACT: Generic response object

=head1 SYNOPSIS

    use WebService::PayPal::PaymentsAdvanced::Response;
    my $response = WebService::PayPal::PaymentsAdvanced::Response->new(
        params => $params );

=head1 DESCRIPTION

This module provides a consistent interface for getting information from a
PayPal response, regardless of whether it comes from token creation, a
redirect or a silent POST.

=head1 OBJECT INSTANTIATION

The following parameters can be supplied to C<new()> when creating a new object.

=head2 Required Parameters

=head3 params

A C<HashRef> of parameters which have been returned by PayPal.

=head2 secure_token

Returns the PayPal SECURETOKEN param.

=head2 secure_token_id

Returns the PayPal SECURETOKENID param.  If you are using this module
directly, you should check that the returned value is the same as the
SECURETOKENID which you initially provided to PayPal.

=head1 SEE ALSO

L<WebService::PayPal::PaymentsAdvanced::Response::FromHTTP>,
L<WebService::PayPal::PaymentsAdvanced::Response::FromRedirect>,
L<WebService::PayPal::PaymentsAdvanced::Response::FromSilentPost>,

=cut
