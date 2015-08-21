package WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard;

use Moo::Role;

use Types::Standard qw( Str );

# An array is the obvious choice for card_type, but the hash leaves no room for
# error. List taken from
# https://developer.paypal.com/docs/classic/payflow/integration-guide/#transaction-responses

has card_type => (
    is       => 'ro',
    isa      => Str,
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_card_type',
);

has expiration_date => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
    builder  => '_build_expiration_date',
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
    return $card_types{ $self->_params->{CARDTYPE} };
}

sub _build_expiration_date {
    my $self = shift;

    # Will be in MMYY
    my $date = $self->_params->{EXPDATE};

    # This breaks in about 75 years.
    return sprintf( '20%s-%s', substr( $date, 2, 2 ), substr( $date, 0, 2 ) );
}

1;
