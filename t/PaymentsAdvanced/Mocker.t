use strict;
use warnings;

use Test::LWP::UserAgent;
use Test::More;

use WebService::PayPal::PaymentsAdvanced::Mocker;

{
    my $mocker
        = WebService::PayPal::PaymentsAdvanced::Mocker->new( plack => 1 );
    isa_ok( $mocker->mocked_ua, 'Test::LWP::UserAgent', 'ua' );
}

{
    my $mocker = WebService::PayPal::PaymentsAdvanced::Mocker->new(
        plack => 1,
        ua    => Test::LWP::UserAgent->new( network_fallback => 0 ),
    );
    isa_ok( $mocker->mocked_ua, 'Test::LWP::UserAgent', 'ua' );
}

done_testing();
