package WebService::PayPal::PaymentsAdvanced::Role::ClassFor;

use Moo::Role;

our $VERSION = '0.000010';

sub _class_for {
    my $self = shift;
    return 'WebService::PayPal::PaymentsAdvanced::' . shift;
}

1;
