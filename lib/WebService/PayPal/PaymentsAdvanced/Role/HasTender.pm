package WebService::PayPal::PaymentsAdvanced::Role::HasTender;

use Moo::Role;

use Types::Standard qw( Bool );

has is_credit_card_transaction => (
    is      => 'ro',
    isa      => Bool,
    lazy    => 1,
    default => sub {
        shift->params->{TENDER} eq 'C';
    },
);

has is_paypal_transaction => (
    is      => 'ro',
    isa      => Bool,
    lazy    => 1,
    default => sub {
        shift->params->{TENDER} eq 'P';
    },
);

1;
