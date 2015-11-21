#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::LWP::UserAgent;

use HTTP::Message::PSGI;
use LWP::ConsoleLogger::Easy qw( debug_ua );
use Path::Tiny qw( path );
use WebService::PayPal::PaymentsAdvanced;
use WebService::PayPal::PaymentsAdvanced::Mocker;

use lib 't/lib';
use Util;

{
    my $ua = LWP::UserAgent->new();
    debug_ua($ua);

    my $payments = WebService::PayPal::PaymentsAdvanced->new(
        password                 => 'seekrit',
        ua                       => $ua,
        user                     => 'someuser',
        validate_hosted_form_uri => 0,            # requires network access
        vendor                   => 'PayPal',
    );

    isa_ok( $payments, 'WebService::PayPal::PaymentsAdvanced', 'new object' );

    my $encoded = $payments->_pseudo_encode_args(
        { foo => 'xxx', bar => 'a space', baz => 'a +' } );

    is( $encoded, 'bar[7]=a space&baz[3]=a +&foo[3]=xxx', 'pseudo encoding' );
    is(
        $payments->_encode_credentials,
        'PARTNER=PayPal&PWD=seekrit&USER=someuser&VENDOR=PayPal',
        'encode credentials'
    );

    is_deeply(
        $payments->_force_upper_case( { foo => 1, BaR => 2 } ),
        { FOO => 1, BAR => 2 },
        'force upper case hash keys'
    );
}

{
    my ( $payments, $payments_res )
        = get_mocked_payments('test-data/hosted-form-with-error.html');

    like(
        exception { $payments_res->hosted_form_uri },
        qr{Secure Token is not enabled},
        'HTML error is in exception'
    );
}

{

    my ( $payments, $payments_res )
        = get_mocked_payments('test-data/hosted-form.html');
    is(
        exception { $payments_res->hosted_form_uri },
        undef, 'No exception when no HTML errors'
    );
}

{
    my $ppa = Util::mocked_ppa();
    foreach my $params ( ['FOO'], [ 'FOO', 12.99 ] ) {
        my $res = $ppa->capture_delayed_transaction( @{$params} );
        ok( $res, 'capture_delayed_transaction' );
        ok(
            $res->transaction_time,
            'transaction_time: ' . $res->transaction_time
        );
        ok( $res->pnref, 'pnref' );
        ok( $res->ppref, 'ppref' );
    }
}

{
    my $ppa = Util::mocked_ppa();
    my $res = $ppa->inquiry_transaction('FOO');
    ok( $res, 'inquiry_transaction' );
    ok(
        $res->transaction_time,
        'transaction_time: ' . $res->transaction_time
    );
    ok( $res->pnref, 'pnref' );

    # XXX this blows up on ppref
    ok( $res->card_type,                  'card_type' );
    ok( $res->card_last_four_digits,      'credit_card' );
    ok( $res->card_expiration,            'expiration' );
    ok( $res->amount,                     'amount' );
    ok( $res->is_credit_card_transaction, 'is_credit_card_transaction' );
    ok( !$res->is_paypal_transaction,     'is_paypal_transaction' );
}

{
    my $ppa    = Util::mocked_ppa();
    my $amount = 16;
    my $res
        = $ppa->auth_from_credit_card_reference_transaction( 'FOO', $amount );
    ok( $res, 'auth_from_credit_card_reference_transaction' );
    ok(
        $res->transaction_time,
        'transaction_time: ' . $res->transaction_time
    );
    ok( $res->pnref, 'pnref' );
    ok( $res->ppref, 'ppref' );
    is( $res->amount, $amount, 'amount' );
    ok( $res->is_credit_card_transaction, 'is_credit_card_transaction' );
    ok( !$res->is_paypal_transaction,     'is_paypal_transaction' );
}

{
    my $ppa    = Util::mocked_ppa();
    my $amount = 15;
    my $res
        = $ppa->sale_from_credit_card_reference_transaction( 'FOO', $amount );
    ok( $res, 'sale_from_credit_card_reference_transaction' );
    ok(
        $res->transaction_time,
        'transaction_time: ' . $res->transaction_time
    );
    ok( $res->pnref, 'pnref' );
    ok( $res->ppref, 'ppref' );
    is( $res->amount, $amount, 'amount' );
    ok( $res->is_credit_card_transaction, 'is_credit_card_transaction' );
    ok( !$res->is_paypal_transaction,     'is_paypal_transaction' );
}

{
    my $ppa    = Util::mocked_ppa();
    my $amount = 23.99;
    my $res    = $ppa->auth_from_paypal_reference_transaction(
        'FOO',
        $amount,
        'USD'
    );
    ok( $res, 'auth_from_paypal_reference_transaction' );
    ok(
        $res->transaction_time,
        'transaction_time: ' . $res->transaction_time
    );
    ok( $res->pnref, 'pnref' );
    ok( $res->ppref, 'ppref' );
    is( $res->amount, $amount, 'amount' );
    ok( !$res->is_credit_card_transaction, 'is_credit_card_transaction' );
    ok( $res->is_paypal_transaction,       'is_paypal_transaction' );
}

{
    my $ppa    = Util::mocked_ppa();
    my $amount = 24.99;
    my $res    = $ppa->sale_from_paypal_reference_transaction(
        'FOO',
        $amount,
        'USD'
    );
    ok( $res, 'sale_from_paypal_reference_transaction' );
    ok(
        $res->transaction_time,
        'transaction_time: ' . $res->transaction_time
    );
    ok( $res->pnref, 'pnref' );
    ok( $res->ppref, 'ppref' );
    is( $res->amount, $amount, 'amount' );
    ok( !$res->is_credit_card_transaction, 'is_credit_card_transaction' );
    ok( $res->is_paypal_transaction,       'is_paypal_transaction' );
}

sub get_mocked_payments {
    my $file = shift;

    my $ua = Test::LWP::UserAgent->new;

    my $mocker
        = WebService::PayPal::PaymentsAdvanced::Mocker->new( plack => 1 );

    $ua->register_psgi( 'pilot-payflowpro.paypal.com', $mocker->payflow_pro );

    $ua->map_response(
        'pilot-payflowlink.paypal.com',
        HTTP::Response->new(
            '200', 'OK',
            [ 'Content-Type' => 'text/html' ], path("t/$file")->slurp
        )
    );

    my $payments = WebService::PayPal::PaymentsAdvanced->new(
        password                 => 'seekrit',
        ua                       => $ua,
        user                     => 'someuser',
        validate_hosted_form_uri => 1,            # mocking network access
        vendor                   => 'PayPal',
    );
    my $payments_res
        = $payments->create_secure_token( { SECURETOKENID => 'BAR' } );
    return ( $payments, $payments_res );
}
done_testing();
