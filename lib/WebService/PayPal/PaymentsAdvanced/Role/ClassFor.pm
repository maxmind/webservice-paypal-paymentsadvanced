package WebService::PayPal::PaymentsAdvanced::Role::ClassFor;

use Moo::Role;

sub _class_for {
    my $self = shift;
    return 'WebService::PayPal::PaymentsAdvanced::' . shift;
}

1;