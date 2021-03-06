package WebService::PayPal::PaymentsAdvanced::Role::HasParams;

use Moo::Role;

use namespace::autoclean;

our $VERSION = '0.000028';

use Types::Standard qw( HashRef );

has params => (
    is       => 'ro',
    isa      => HashRef,
    required => 1,
);

1;

__END__
#ABSTRACT: Role which provides params attribute to exception and response classes.

=head1 METHODS

=head2 params

The parameters returned by PayPal
