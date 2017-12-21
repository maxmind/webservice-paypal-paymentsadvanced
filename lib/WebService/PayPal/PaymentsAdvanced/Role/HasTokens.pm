package WebService::PayPal::PaymentsAdvanced::Role::HasTokens;

use Moo::Role;

use namespace::autoclean;

our $VERSION = '0.000025';

use Types::Common::String qw( NonEmptyStr );

has secure_token => (
    is       => 'lazy',
    isa      => NonEmptyStr,
    init_arg => undef,
);

has secure_token_id => (
    is       => 'lazy',
    isa      => NonEmptyStr,
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

__END__

# ABSTRACT: Provides roles for dealing with secure tokens

=head2 secure_token

Returns C<SECURETOKEN> param

=head2 secure_token_id

Returns C<SECURETOKENID> param
