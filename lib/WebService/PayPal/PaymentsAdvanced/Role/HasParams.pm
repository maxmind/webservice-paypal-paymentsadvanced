package WebService::PayPal::PaymentsAdvanced::Role::HasParams;

use Moo::Role;

our $VERSION = '0.000009';

use Types::Standard qw( HashRef );

has params => (
    is       => 'ro',
    isa      => HashRef,
    required => 1,
);

1;

__END__
#ABSTRACT: Role which provides params attribute to exception and response classes.
