package WebService::PayPal::PaymentsAdvanced::Error::Generic;

use strict;
use warnings;

use Moo;

with 'WebService::PayPal::PaymentsAdvanced::Role::Error::HasParams';

extends 'Throwable::Error';

1;

# ABSTRACT: A generic error
