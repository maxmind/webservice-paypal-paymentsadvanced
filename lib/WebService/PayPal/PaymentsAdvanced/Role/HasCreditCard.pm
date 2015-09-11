package WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard;

use Moo::Role;

use Types::Common::Numeric qw( PositiveInt );
use Types::Standard qw( Str );

has card_type => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
);

has card_expiration => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
);

has card_last_four_digits => (
    is       => 'lazy',
    isa      => PositiveInt,
    init_arg => undef,
    default  => sub { shift->params->{ACCT} },
);

has reference_transaction_id => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
    default  => sub { shift->pnref },
);

sub _build_card_type {
    my $self = shift;

    my %card_types = (
        0 => 'VISA',
        1 => 'MasterCard',
        2 => 'Discover',
        3 => 'American Express',
        4 => q{Diner's Club},
        5 => 'JCB',
    );
    return $card_types{ $self->params->{CARDTYPE} };
}

sub _build_card_expiration {
    my $self = shift;

    # Will be in MMYY
    my $date = $self->params->{EXPDATE};

    # This breaks in about 75 years.
    return sprintf( '20%s-%s', substr( $date, 2, 2 ), substr( $date, 0, 2 ) );
}

1;

__END__
# ABSTRACT: Role which provides methods specifically for credit card transactions

=head2 card_type

A human readable credit card type.  One of:

    VISA
    MasterCard
    Discover
    American Express
    Diner's Club
    JCB

=head2 card_expiration

The month and year of the credit card expiration.

=head card_last_four_digits

The last four digits of the credit card.

=head2 reference_transaction_id

The id you will use in order to use this as a reference transaction (C<pnref>).
