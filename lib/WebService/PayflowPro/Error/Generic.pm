package WebService::PayflowPro::Error::Generic;

use strict;
use warnings;

use Moo;

with 'WebService::PayflowPro::Role::Error::HasParams';

extends 'Throwable::Error';

1;

# ABSTRACT: A generic error
