#!/usr/bin/env perl;

use strict;
use warnings;

use Data::GUID;
use LWP::ConsoleLogger::Easy qw( debug_ua );
use Path::Tiny qw( path );
use Test::Fatal;
use Test::More;
use Test::RequiresInternet( 'pilot-payflowpro.paypal.com' => 443 );
use WebService::PayPal::PaymentsAdvanced;

my $ua = LWP::UserAgent->new();
debug_ua($ua);

{
    foreach my $production_mode ( 0, 1 ) {
        my $payments = WebService::PayPal::PaymentsAdvanced->new(
            password        => 'seekrit',
            production_mode => $production_mode,
            ua              => $ua,
            user            => 'someuser',
            vendor          => 'PayPal',
        );

        isa_ok( $payments, 'WebService::PayPal::PaymentsAdvanced', 'new object' );

        isa_ok(
            exception {
                my $res = $payments->create_secure_token;
            },
            'WebService::PayPal::PaymentsAdvanced::Error::Authentication',
            $production_mode ? 'production' : 'sandbox'
        );
    }
}

my $file = path('t/config.pl');
SKIP: {
    skip 'config file required for live tests', 2, unless $file->exists;

    my $config = eval $file->slurp;

    my $payments = WebService::PayPal::PaymentsAdvanced->new(
        password            => $config->{password},
        ua                  => $ua,
        user                => $config->{user},
        validate_iframe_uri => 1,
        vendor              => $config->{vendor},
    );

    my $token_id = Data::GUID->new->as_string;

    my $create_token = {
        AMT           => 100,
        BILLINGTYPE   => 'MerchantInitiatedBilling',
        CANCELURL     => 'http://example.com/cancel',
        ERRORURL      => 'http://example.com/error',
        LBILLINGTYPE0 => 'MerchantInitiatedBilling',
        NAME          => 'WebService::PayPal::PaymentsAdvanced',
        RETURNURL     => 'http://example.com/return',
        SECURETOKENID => $token_id,
        TRXTYPE       => 'S',
        VERBOSITY     => 'HIGH',
    };

    {
        my $res = $payments->create_secure_token($create_token);

        ok( $res, 'got response' );
        like( $res->message, qr{approved}i, 'approved' );
        ok( $res->secure_token, 'secure token' );
        cmp_ok(
            $res->secure_token_id, 'eq', $token_id,
            'token id unchanged'
        );
    }

    delete $create_token->{SECURETOKENID};

    {
        my $res = $payments->create_secure_token($create_token);
        ok( $res->secure_token, 'gets token when module generates own id' );

        my $uri = $payments->iframe_uri($res);
        ok( $uri, 'got uri for iframe ' . $uri );
    }
}

done_testing();
