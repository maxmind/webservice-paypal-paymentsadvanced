package WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime;

use Moo::Role;

use namespace::autoclean;

our $VERSION = '0.000027';

use feature qw( state );

use DateTime::TimeZone;
use DateTime::Format::MySQL;
use Types::Standard qw( InstanceOf Maybe );

has transaction_time => (
    is  => 'lazy',
    isa => Maybe [ InstanceOf ['DateTime'] ],
);

sub _build_transaction_time {
    my $self = shift;

    state $time_zone
        = DateTime::TimeZone->new( name => 'America/Los_Angeles' );

    return undef unless my $transtime = $self->params->{TRANSTIME};

    my $dt = DateTime::Format::MySQL->parse_datetime($transtime);
    $dt->set_time_zone($time_zone);
    return $dt;
}
1;

__END__

# ABSTRACT: Role which converts TRANSTIME into a DateTime object

=head2 transaction_time

Returns C<TRANSTIME> in the form of a DateTime object
