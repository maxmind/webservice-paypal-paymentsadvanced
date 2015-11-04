package WebService::PayPal::PaymentsAdvanced::Error::Role::HasHTTPResponse;

use Moo::Role;

our $VERSION = '0.000008';

use Types::Standard qw( InstanceOf Int );
use Types::URI qw( Uri );

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

has request_uri => (
    is       => 'ro',
    isa      => Uri,
    coerce   => 1,
    required => 1,
);

1;

__END__
#ABSTRACT: Role which provides attributes for an error in an HTTP response.
