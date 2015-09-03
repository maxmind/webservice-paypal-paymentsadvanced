package WebService::PayPal::PaymentsAdvanced::Response::Inquiry;

use Moo;

extends 'WebService::PayPal::PaymentsAdvanced::Response';

with 'WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime',
    'WebService::PayPal::PaymentsAdvanced::Role::HasTender';

1;
