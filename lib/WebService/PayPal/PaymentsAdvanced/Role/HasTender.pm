package WebService::PayPal::PaymentsAdvanced::Role::HasTender;

use Moo::Role;

use Types::Standard qw( Bool StrictNum );

has amount => (
    is       => 'lazy',
    isa      => StrictNum,
    init_arg => undef,
    default  => sub { shift->params->{AMT} },
);

has is_credit_card_transaction => (
    is       => 'lazy',
    isa      => Bool,
    init_arg => undef,
);

has is_paypal_transaction => (
    is       => 'lazy',
    isa      => Bool,
    lazy     => 1,
    init_arg => undef,
);

sub _build_is_credit_card_transaction {
    my $self = shift;
    return ( exists $self->params->{TENDER}
            && $self->params->{TENDER} eq 'CC' )
        || exists $self->params->{CARDTYPE};
}

sub _build_is_paypal_transaction {
    my $self = shift;
    return ( exists $self->params->{TENDER}
            && $self->params->{TENDER} eq 'P' )
        || exists $self->params->{BAID}
        || !$self->is_credit_card_transaction;
}

1;
