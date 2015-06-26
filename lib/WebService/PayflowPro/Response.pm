package WebService::PayflowPro::Response;

use Moo;

use Types::Standard qw( Str );
use WebService::PayflowPro::Error::Authentication;

has params => (
    is       => 'ro',
    required => 1,
);

has message => (
    is  => 'lazy',
    isa => Str,
);

has secure_token => (
    is  => 'lazy',
    isa => Str,
);

has secure_token_id => (
    is  => 'lazy',
    isa => Str,
);

sub BUILD {
    my $self = shift;

    my $result = $self->params->{RESULT};

    return if defined $result && !$result;

    if ( $result == 1 ) {
        WebService::PayflowPro::Error::Authentication->throw(
            message => 'Authentication error: ' . $self->message,
            params  => $self->params,
        );
    }

    WebService::PayflowPro::Error::Generic->throw(
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
