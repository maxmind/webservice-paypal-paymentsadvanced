#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::LWP::UserAgent;

use LWP::ConsoleLogger::Easy qw( debug_ua );
use Path::Tiny qw( path );
use WebService::PayPal::PaymentsAdvanced;

{
    my $ua = LWP::UserAgent->new();
    debug_ua($ua);

    my $payments = WebService::PayPal::PaymentsAdvanced->new(
        password            => 'seekrit',
        ua                  => $ua,
        user                => 'someuser',
        validate_iframe_uri => 0,            # requires network access
        vendor              => 'PayPal',
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
        { FOO => 1, BAR => 2 }, 'force upper case hash keys'
    );

    my $response = WebService::PayPal::PaymentsAdvanced::Response->new(
        params => {
            RESULT        => 0,
            SECURETOKEN   => 'FOO',
            SECURETOKENID => 'BAR',
        }
    );
    my $url = $payments->iframe_uri($response);

    ok( $url, "iframe url: $url" );
}

# Test parsing errors out of iFrame content.
{
    my ( $payments, $payments_res ) = get_mocked_payments( 'iframe-with-error.html' );

    like(
        exception { $payments->iframe_uri($payments_res) },
        qr{Secure Token is not enabled}, 'HTML error is in exception'
    );
}

# Test parsing iFrame content without errors.
{

    my ( $payments, $payments_res ) = get_mocked_payments( 'iframe.html' );
    is(
        exception { $payments->iframe_uri($payments_res) },
        undef, 'No exception when no HTML errors'
    );
}

sub get_mocked_payments {
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

    my $payments = WebService::PayPal::PaymentsAdvanced->new(
        password            => 'seekrit',
        ua                  => $ua,
        user                => 'someuser',
        validate_iframe_uri => 1,            # mocking network access
        vendor              => 'PayPal',
    );
    my $payments_res = $payments->create_secure_token( { SECURETOKENID => 'BAR' } );
    return ($payments, $payments_res );
}
done_testing();
