package WebService::PayPal::PaymentsAdvanced::Error::HTTP;

use Moo;

use Types::Standard qw( InstanceOf Int );

extends 'Throwable::Error';

has http_status => (
    is       => 'ro',
    isa      => Int,
    required => 1,
);

has http_response => (
    is       => 'ro',
    isa      => InstanceOf ['HTTP::Response'],
    required => 1,
);

1;

# ABSTRACT: An HTTP transport error
