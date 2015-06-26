package WebService::PayflowPro::Error::IPVerification;

use Moo;

extends 'Throwable::Error';

use Types::Standard qw( Str );

has ip_address => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

with 'WebService::PayflowPro::Role::Error::HasParams';

1;

# ABSTRACT: A Payflow authentication error
