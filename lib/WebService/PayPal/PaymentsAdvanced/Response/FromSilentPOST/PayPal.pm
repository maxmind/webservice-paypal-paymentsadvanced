package WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST::PayPal;

use Moo;

extends 'WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST';

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasTender',
    'WebService::PayPal::PaymentsAdvanced::Role::HasTokens',
);

1;
