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

done_testing();
