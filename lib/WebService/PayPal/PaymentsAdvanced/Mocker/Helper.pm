package WebService::PayPal::PaymentsAdvanced::Mocker::Helper;

use Moo;

use Data::GUID;
use DateTime;
use DateTime::Format::MySQL;
use DateTime::TimeZone;
use Types::Standard qw( InstanceOf );

has _time_zone => (
    is => 'lazy',
    isa => InstanceOf ['DateTime::TimeZone'],
    default =>
        sub { DateTime::TimeZone->new( name => 'America/Los_Angeles' ) },
);

sub baid {
    my $self = shift;
    return 'B-' . $self->unique_id(17);
}

sub correlationid {
    return lc shift->unique_id(13);
}

sub pnref {
    return shift->unique_id(12);
}

sub ppref {
    return shift->unique_id(17);
}

sub secure_token {
    return shift->unique_id(25);
}

sub token {
    return 'EC-' . shift->unique_id(17);
}

sub transtime {
    return DateTime::Format::MySQL->format_datetime(shift->datetime_now );
}

sub unique_id {
    my $self = shift;
    my $length = shift || die 'length param required';

    my $id = Data::GUID->new->as_string;
    $id =~ s{-}{}g;
    return substr( $id, 0, $length );
}

sub datetime_now {
    return DateTime->now( time_zone => shift->_time_zone );
}

1;
