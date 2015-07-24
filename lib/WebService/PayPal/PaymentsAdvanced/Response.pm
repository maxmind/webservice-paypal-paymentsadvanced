package WebService::PayPal::PaymentsAdvanced::Response;

use Moo;

use Types::Standard qw( HashRef Str );
use WebService::PayPal::PaymentsAdvanced::Error::Authentication;

has params => (
    is       => 'ro',
    isa      => HashRef,
    required => 1,
);

has message => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
);

has secure_token => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
);

has secure_token_id => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
);

sub BUILD {
    my $self = shift;

    my $result = $self->params->{RESULT};

    return if defined $result && !$result;

    if ( $result && $result == 1 ) {
        WebService::PayPal::PaymentsAdvanced::Error::Authentication->throw(
            message => 'Authentication error: ' . $self->message,
            params  => $self->params,
        );
    }

    WebService::PayPal::PaymentsAdvanced::Error::Generic->throw(
        message => $self->message,
        params  => $self->params,
    );
}

sub _build_message {
    my $self = shift;
    return $self->params->{RESPMSG};
}

sub _build_secure_token {
    my $self = shift;
    return $self->params->{SECURETOKEN};
}

sub _build_secure_token_id {
    my $self = shift;
    return $self->params->{SECURETOKENID};
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
