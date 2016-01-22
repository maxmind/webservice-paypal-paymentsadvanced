package WebService::PayPal::PaymentsAdvanced::Role::HasMessage;

use Moo::Role;

our $VERSION = '0.000016';

use Types::Common::String qw( NonEmptyStr );

has message => (
    is       => 'lazy',
    isa      => NonEmptyStr,
    init_arg => undef,
);

sub _build_message {
    my $self = shift;
    return $self->params->{RESPMSG};
}

1;

__END__
#ABSTRACT: Role which provides message attribute to exception and response classes.
