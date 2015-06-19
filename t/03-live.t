#!/usr/bin/env perl;

use strict;
use warnings;

use Data::GUID;
use Data::Printer;
use LWP::ConsoleLogger::Easy qw( debug_ua );
use Path::Tiny qw( path );
use Test::More;
use Test::RequiresInternet( 'pilot-payflowpro.paypal.com' => 443 );
use WebService::PayflowPro;

my $ua = LWP::UserAgent->new();
debug_ua($ua);

{
    my $flow = WebService::PayflowPro->new(
        password => 'seekrit',
        ua       => $ua,
        user     => 'someuser',
        vendor   => 'PayPal',
    );

    isa_ok( $flow, 'WebService::PayflowPro', 'new object' );

    my $res = $flow->create_secure_token;

    ok( !$res->success, 'failed' );
    like( $res->message, qr{failed}i, 'auth failed' );
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

    my $token = {
        AMT               => 1.01,
        INVNUM            => '000002',
        NAME              => 'Foo Bar Baz',
        PONUM             => '000002-1',
        SECURETOKENID     => $token_id,
        TRXTYPE           => 'S',
        VERBOSITY         => 'HIGH',
    };

    my $res = $flow->create_secure_token($token);

    ok( $res,          'got response' );
    ok( $res->success, 'success' );
    is( $res->http_response_code, 200, '200 response' );
    like( $res->message, qr{approved}i, 'approved' );
    ok( $res->secure_token, 'secure token' );
    cmp_ok( $res->secure_token_id, 'eq', $token_id, 'token id unchanged' );

    diag np $res->params;

    delete $token->{SECURETOKENID};

    my $res = $flow->create_secure_token($token);
    ok( $res->success, 'Let module create the token id' );
}

done_testing();
