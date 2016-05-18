package WebService::PayPal::PaymentsAdvanced::Mocker::Helper;

use Moo;

our $VERSION = '0.000018';

use Data::GUID;
use DateTime;
use DateTime::Format::MySQL;
use DateTime::TimeZone;
use Types::Standard qw( InstanceOf );

has _time_zone => (
    is  => 'lazy',
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
    return DateTime::Format::MySQL->format_datetime( shift->datetime_now );
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

__END__

# ABSTRACT: Helper methods used when mocking PayPal web services

=head1 DESCRIPTION

Helper methods used when mocking PayPal web

=head1 SYNOPSIS

    use WebService::PayPal::PaymentsAdvanced::Mocker::Helper;
    my $helper = WebService::PayPal::PaymentsAdvanced::Mocker::Helper->new;

    print $helper->transtime;

=head2 baid

Returns a new, unique BAID

=head2 correlationid

Returns a new, unique CORRELATIONID

=head2 pnref

Returns a new, unique PNREF

=head2 ppref

Returns a new, unique PPREF

=head2 secure_token

Returns a new, unique SECURETOKEN

=head2 token

Returns a new, unique SECURETOKENID

=head2 transtime

Returns a TRANSTIME based on the current time

=head2 unique_id( $length )

A generic method for creating unique ids.

=head2 datetime_now

Returns a new DateTime object with the current time, using the same time zone
which the PayPal services use.
