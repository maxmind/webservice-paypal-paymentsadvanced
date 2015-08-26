use strict;
use warnings;

use Test::More;

use WebService::PayPal::PaymentsAdvanced::Mocker::SilentPOST;

my $post = WebService::PayPal::PaymentsAdvanced::Mocker::SilentPOST->new;
ok( $post->paypal_success_params( SECURETOKENID => 'FOO' ), 'paypal_success_params' );

done_testing();
