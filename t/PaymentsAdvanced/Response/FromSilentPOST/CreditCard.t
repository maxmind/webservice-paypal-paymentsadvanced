use strict;
use warnings;

use Test::More;

use Scalar::Util qw( blessed );
use WebService::PayPal::PaymentsAdvanced::Mocker::SilentPOST;

use lib 't/lib';
use Util;

my $ppa    = Util::mocked_ppa;
my $mocker = WebService::PayPal::PaymentsAdvanced::Mocker::SilentPOST->new(
    secure_token_id => 'FOO' );

my $response = Util::mocked_ppa->get_response_from_silent_post(
    { params => $mocker->credit_card_success } );

is(
    blessed $response,
    'WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST::CreditCard',
    'CreditCard class'
);
ok( $response->transaction_time,           'transaction_time' );
ok( $response->pnref,                      'ppref' );
ok( !$response->is_paypal_transaction,     'not paypal transaction' );
ok( $response->is_credit_card_transaction, 'is_credit_card_transaction' );

done_testing();
