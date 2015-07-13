package WebService::PayPal::PaymentsAdvanced::Error::Authentication;

use Moo;

extends 'Throwable::Error';

with 'WebService::PayPal::PaymentsAdvanced::Role::Error::HasParams';

1;

# ABSTRACT: A Payments Advanced authentication error
