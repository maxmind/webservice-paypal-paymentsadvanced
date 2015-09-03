package WebService::PayPal::PaymentsAdvanced::Role::TransactionType;

use Moo::Role;

use Types::Standard qw( Bool );

has is_credit_card_transaction => (
    is      => 'ro',
    isa     => Bool,
    lazy    => 1,
    default => sub {
        exists shift->params->{CARDTYPE};
    },
);

has is_paypal_transaction => (
    is      => 'ro',
    isa     => Bool,
    lazy    => 1,
    default => sub {
        !shift->is_credit_card_transaction;
    },
);

1;
