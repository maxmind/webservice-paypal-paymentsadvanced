use strict;
use warnings;

use Test::More;

use WebService::PayPal::PaymentsAdvanced::Mocker::SilentPOST;

use lib 't/lib';
use Util;

my $ppa    = Util::mocked_ppa;
my $mocker = WebService::PayPal::PaymentsAdvanced::Mocker::SilentPOST->new;

my $response = $ppa->get_response_from_silent_post(
    { params => $mocker->paypal_success_params( SECURETOKENID => 'FOO' ) } );

ok( $response->transaction_time, 'transaction_time' );
ok( $response->ppref,            'ppref' );

done_testing();
