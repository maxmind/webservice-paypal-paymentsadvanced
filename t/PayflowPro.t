#!/usr/bin/env perl;

use strict;
use warnings;

use LWP::ConsoleLogger::Easy qw( debug_ua );
use Test::More;
use WebService::PayflowPro;

my $ua = LWP::UserAgent->new();
debug_ua($ua);

my $flow = WebService::PayflowPro->new(
    password => 'seekrit',
    ua       => $ua,
    user     => 'someuser',
    vendor   => 'PayPal',
);

isa_ok( $flow, 'WebService::PayflowPro', 'new object' );

my $encoded = $flow->_pseudo_encode_args(
    { foo => 'xxx', bar => 'a space', baz => 'a +' } );

is( $encoded, 'bar[7]=a space&baz[3]=a +&foo[3]=xxx', 'pseudo encoding' );
is(
    $flow->_encode_credentials,
    'PARTNER=PayPal&PWD=seekrit&USER=someuser&VENDOR=PayPal',
    'encode credentials'
);

is_deeply(
    $flow->_force_upper_case( { foo => 1, BaR => 2 } ),
    { FOO => 1, BAR => 2 }, 'force upper case hash keys'
);

my $response = WebService::PayflowPro::Response->new(
    params => {
        RESULT        => 0,
        SECURETOKEN   => 'FOO',
        SECURETOKENID => 'BAR',
    }
);
my $url = $flow->iframe_uri($response);

ok( $url, "iframe url: $url" );

done_testing();
