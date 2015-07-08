#!/usr/bin/env perl;

use strict;
use warnings;

use Data::GUID;
use LWP::ConsoleLogger::Easy qw( debug_ua );
use Path::Tiny qw( path );
use Test::Fatal;
use Test::More;
use Test::RequiresInternet( 'pilot-payflowpro.paypal.com' => 443 );
use WebService::PayflowPro;

my $ua = LWP::UserAgent->new();
debug_ua($ua);

{
    foreach my $production_mode ( 0, 1 ) {
        my $flow = WebService::PayflowPro->new(
            password        => 'seekrit',
            production_mode => $production_mode,
            ua              => $ua,
            user            => 'someuser',
            vendor          => 'PayPal',
        );

        isa_ok( $flow, 'WebService::PayflowPro', 'new object' );

        isa_ok(
            exception {
                my $res = $flow->create_secure_token;
            },
            'WebService::PayflowPro::Error::Authentication',
            $production_mode ? 'production' : 'sandbox'
        );
    }
}

my $file = path('t/config.pl');
SKIP: {
    skip 'config file required for live tests', 2, unless $file->exists;

    my $config = eval $file->slurp;

    my $flow = WebService::PayflowPro->new(
        password => $config->{password},
        ua       => $ua,
        user     => $config->{user},
        vendor   => $config->{vendor},
    );

    my $token_id = Data::GUID->new->as_string;

    my $create_token = {
        AMT           => 1.01,
        BILLINGTYPE   => 'MerchantInitiatedBilling',
        CANCELURL     => 'http://example.com/cancel',
        ERRORURL      => 'http://example.com/error',
        LBILLINGTYPE  => 'MerchantInitiatedBilling',
        NAME          => 'Foo Bar Baz',
        RETURNURL     => 'http://example.com/return',
        SECURETOKENID => $token_id,
        TRXTYPE       => 'S',
        VERBOSITY     => 'HIGH',
    };

    {
        my $res = $flow->create_secure_token($create_token);

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
        my $res = $flow->create_secure_token($create_token);
        ok( $res->secure_token, 'gets token when module generates own id' );
    }
}

done_testing();
