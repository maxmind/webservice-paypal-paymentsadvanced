package WebService::PayflowPro::Role::Response;

use Moo::Role;

use Types::Standard qw( HashRef InstanceOf );
use URI;
use URI::QueryParam;

has success => (
    is => 'lazy',
);

sub message {
    my $self = shift;
    return $self->params->{RESPMSG};
}

sub secure_token {
    my $self = shift;
    return $self->params->{SECURETOKEN};
}

sub secure_token_id {
    my $self = shift;
    return $self->params->{SECURETOKENID};
}

1;

__END__
# ABSTRACT: Response Role for WebService::PayflowPro
