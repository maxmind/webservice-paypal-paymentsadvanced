#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::LWP::UserAgent;

use LWP::ConsoleLogger::Easy qw( debug_ua );
use Path::Tiny qw( path );
use WebService::PayflowPro;

{
    my $ua = LWP::UserAgent->new();
    debug_ua($ua);

    my $flow = WebService::PayflowPro->new(
        password            => 'seekrit',
        ua                  => $ua,
        user                => 'someuser',
        validate_iframe_uri => 0,            # requires network access
        vendor              => 'PayPal',
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
}

# Test parsing errors out of iFrame content.
{
    my ( $flow, $flow_res ) = get_mocked_flow( 'iframe-with-error.html' );

    like(
        exception { $flow->iframe_uri($flow_res) },
        qr{Secure Token is not enabled}, 'HTML error is in exception'
    );
}

# Test parsing iFrame content without errors.
{

    my ( $flow, $flow_res ) = get_mocked_flow( 'iframe.html' );
    is(
        exception { $flow->iframe_uri($flow_res) },
        undef, 'No exception when no HTML errors'
    );
}

sub get_mocked_flow {
    my $file = shift;

    my $ua = Test::LWP::UserAgent->new;

    $ua->map_response(
        'pilot-payflowpro.paypal.com',
        HTTP::Response->new(
            '200', 'OK',
            [ 'Content-Type' => 'text/html' ],
            'SECURETOKEN=FOO&SECURETOKENID=BAR&RESPMSG=approved&RESULT=0'
        )
    );

    $ua->map_response(
        'pilot-payflowlink.paypal.com',
        HTTP::Response->new(
            '200', 'OK',
            [ 'Content-Type' => 'text/html' ],
            path("t/$file")->slurp
        )
    );

    my $flow = WebService::PayflowPro->new(
        password            => 'seekrit',
        ua                  => $ua,
        user                => 'someuser',
        validate_iframe_uri => 1,            # mocking network access
        vendor              => 'PayPal',
    );
    my $flow_res = $flow->create_secure_token( { SECURETOKENID => 'BAR' } );
    return ($flow, $flow_res );
}
done_testing();
