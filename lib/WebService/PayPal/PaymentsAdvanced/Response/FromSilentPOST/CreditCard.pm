package WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST::CreditCard;

use Moo;

extends 'WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST';

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard',
);

1;
