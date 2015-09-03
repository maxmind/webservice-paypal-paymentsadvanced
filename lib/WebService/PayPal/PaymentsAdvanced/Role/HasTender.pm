package WebService::PayPal::PaymentsAdvanced::Role::HasTender;

use Moo::Role;

use Types::Standard qw( Bool );

has is_credit_card_transaction => (
    is      => 'lazy',
    isa     => Bool,
);

has is_paypal_transaction => (
    is      => 'ro',
    isa     => Bool,
    lazy    => 1,
    default => sub {
        shift->params->{TENDER} eq 'P';
    },
);

sub _build_is_credit_card_transaction {
    my $self = shift;
    return ( exists $self->params->{TENDER} && $self->params->{TENDER} eq 'CC' ) || exists $self->params->{CARDTYPE};
}

sub _build_is_paypal_transaction {
    my $self = shift;
    return ( exists $self->params->{TENDER} && $self->params->{TENDER} eq 'CC' ) || exists $self->params->{BAID} || !shift->is_credit_card_transaction;
}

1;
