package WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard;

use Moo::Role;

use Types::Common::Numeric qw( PositiveInt );
use Types::Standard qw( Str );

# An array is the obvious choice for card_type, but the hash leaves no room for
# error. List taken from
# https://developer.paypal.com/docs/classic/payflow/integration-guide/#transaction-responses

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
