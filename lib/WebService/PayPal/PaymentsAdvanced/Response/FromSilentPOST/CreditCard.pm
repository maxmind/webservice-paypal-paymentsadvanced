package WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST::CreditCard;

use Moo;

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard',
    'WebService::PayPal::PaymentsAdvanced::Role::HasMessage',
    'WebService::PayPal::PaymentsAdvanced::Role::HasParams',
    'WebService::PayPal::PaymentsAdvanced::Role::HasTender',
    'WebService::PayPal::PaymentsAdvanced::Role::HasTokens',
);

1;
