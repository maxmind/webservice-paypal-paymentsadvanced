package WebService::PayPal::PaymentsAdvanced::Response;

use Moo;

use Types::Standard qw( Str );

has pnref => (
    is      => 'lazy',
    isa     => Str,
    default => sub { shift->_params->{PNREF} },
);

has ppref => (
    is      => 'lazy',
    isa     => Str,
    default => sub { shift->_params->{PPREF} },
);

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
PayPal response, regardless of whether it comes from token creation, a redirect
or a silent POST.  It will be used as a parent class for other response
classes.  You should never need to create this object yourself.

=head1 METHODS

=head2 message

The contents of PayPal's RESPMSG parameter.

=head2 params

A C<HashRef> of parameters which have been returned by PayPal.

=head2 pnref

The contents of PayPal's PNREF parameter.

=head2 ppref

The contents of PayPal's PNREF parameter.

=head1 SEE ALSO

L<WebService::PayPal::PaymentsAdvanced::Response::FromHTTP>,
L<WebService::PayPal::PaymentsAdvanced::Response::FromRedirect>,
L<WebService::PayPal::PaymentsAdvanced::Response::FromSilentPost>,

=cut
