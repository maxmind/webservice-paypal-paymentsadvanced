package WebService::PayPal::PaymentsAdvanced::Response::Inquiry;

use Moo;

extends 'WebService::PayPal::PaymentsAdvanced::Response';

use Types::Standard qw( Bool );

has is_credit_card_transaction => (
    is      => 'ro',
    isa     => Bool,
    lazy    => 1,
    default => sub {
        shift->params->{CARDTYPE};
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
