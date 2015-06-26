package WebService::PayflowPro::Error::Authentication;

use Moo;

extends 'Throwable::Error';

with 'WebService::PayflowPro::Role::Error::HasParams';

1;

# ABSTRACT: A Payflow authentication error
