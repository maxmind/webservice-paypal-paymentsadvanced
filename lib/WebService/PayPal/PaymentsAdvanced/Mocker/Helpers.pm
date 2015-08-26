package WebService::PayPal::PaymentsAdvanced::Mocker::Helpers;

use Moo;

use Data::GUID;
use DateTime;
use DateTime::TimeZone;
use Types::Standard qw( InstanceOf );

has _time_zone => (
    is => 'lazy',
    isa => InstanceOf ['DateTime::TimeZone'],
    default =>
        sub { DateTime::TimeZone->new( name => 'America/Los_Angeles' ) },
);

sub unique_id {
    my $self = shift;
    my $length = shift || die 'length param required';

    my $id = Data::GUID->new->as_string;
    $id =~ s{-}{}g;
    return substr( $id, 0, $length );
}

sub datetime_now {
    my $self = shift;
    return DateTime->now( time_zone => $self->_time_zone );
}

1;
