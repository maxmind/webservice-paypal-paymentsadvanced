package WebService::PayPal::PaymentsAdvanced::Role::HasTransactionTime;

use Moo::Role;

use feature qw( state );

use DateTime::TimeZone;
use DateTime::Format::MySQL;
use Types::Standard qw( InstanceOf );

has transaction_time => (
    is => 'lazy',
    isa => InstanceOf ['DateTime'],
);

sub _build_transaction_time {
    my $self = shift;

    state $time_zone
        = DateTime::TimeZone->new( name => 'America/Los_Angeles' );
    my $dt = DateTime::Format::MySQL->parse_datetime(
        $self->params->{TRANSTIME} );
    $dt->set_time_zone($time_zone);
    return $dt;
}
1;
