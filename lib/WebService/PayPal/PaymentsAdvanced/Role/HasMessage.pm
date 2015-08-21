package WebService::PayPal::PaymentsAdvanced::Role::HasMessage;

use Moo::Role;

use Types::Standard qw( Str );

has message => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
);

sub _build_message {
    my $self = shift;
    return $self->params->{RESPMSG};
}

1;

__END__
#ABSTRACT: Role which provides message attribute to exception and response classes.
