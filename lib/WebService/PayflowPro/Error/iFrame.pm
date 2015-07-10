package WebService::PayflowPro::Error::iFrame;

use strict;
use warnings;

use Moo;

use Types::Standard qw( InstanceOf );

has http_response => (
    is       => 'ro',
    isa      => InstanceOf ['HTTP::Response'],
    required => 1,
);

extends 'Throwable::Error';

1;

# ABSTRACT: An error message which has been parsed out of an iFrame
