package WebService::PayflowPro::Role::Error::HasParams;

use Moo::Role;

use Types::Standard qw( HashRef );

has params => (
    is       => 'ro',
    isa      => HashRef,
    required => 1,
);

1;

__END__
#ABSTRACT: Role which provides a params attribute to exception classes.
