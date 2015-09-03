package WebService::PayPal::PaymentsAdvanced::Response::Sale::CreditCard;

use Moo;

extends 'WebService::PayPal::PaymentsAdvanced::Response::Sale';

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard',
);

1;
