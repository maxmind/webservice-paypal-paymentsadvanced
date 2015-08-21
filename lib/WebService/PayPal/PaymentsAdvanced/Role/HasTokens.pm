package WebService::PayPal::PaymentsAdvanced::Role::HasTokens;

use Moo::Role;

use Types::Standard qw( Str );

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

sub _build_secure_token {
    my $self = shift;
    return $self->params->{SECURETOKEN};
}

sub _build_secure_token_id {
    my $self = shift;
    return $self->params->{SECURETOKENID};
}

1;
