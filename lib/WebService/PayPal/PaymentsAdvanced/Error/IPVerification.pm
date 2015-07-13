package WebService::PayPal::PaymentsAdvanced::Error::IPVerification;

use Moo;

extends 'Throwable::Error';

use Types::Standard qw( Str );

has ip_address => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

with 'WebService::PayPal::PaymentsAdvanced::Role::Error::HasParams';

1;

# ABSTRACT: A Payments Advanced authentication error
