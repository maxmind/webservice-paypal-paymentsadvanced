package WebService::PayPal::PaymentsAdvanced::Response::Inquiry::CreditCard;

use Moo;

extends 'WebService::PayPal::PaymentsAdvanced::Response::Inquiry';

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasCreditCard',
);

1;
