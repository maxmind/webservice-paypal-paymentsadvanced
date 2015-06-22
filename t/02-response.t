use strict;
use warnings;

use HTTP::Response;
use Test::Fatal qw( exception );
use Test::More;
use WebService::PayflowPro::Response;

like(
    exception { WebService::PayflowPro::Response->new }, qr/either/,
    'dies if neither params nor response object provided'
);

my $http_response = HTTP::Response->new( 200, undef, undef, 'RESULT=0' );

my $payflow_response
    = WebService::PayflowPro::Response->new( raw_response => $http_response );

ok( $payflow_response,          'got response' );
ok( $payflow_response->success, 'successful' );

my $params = {
    ACCT            => 9990,
    AMT             => 1.01,
    AUTHCODE        => 111111,
    AVSADDR         => 'Y',
    AVSDATA         => 'YYY',
    AVSZIP          => 'Y',
    BILLTOCOUNTRY   => 'US',
    BILLTOFIRSTNAME => 'Foo Bar',
    BILLTOLASTNAME  => 'Baz',
    BILLTONAME      => 'Foo Bar Baz',
    CARDTYPE        => 3,
    CORRELATIONID   => 'd064d8ae25107',
    COUNTRY         => 'US',
    COUNTRYTOSHIP   => 'US',
    CVV2MATCH       => 'Y',
    EXPDATE         => 1118,
    FIRSTNAME       => 'Foo Bar Baz',
    IAVS            => 'N',
    LASTNAME        => 'Baz',
    METHOD          => 'CC',
    NAME            => 'Foo Bar Baz',
    PNREF           => 'B73P7D8BB233',
    PPREF           => '75135880JY956953W',
    PROCAVS         => 'X',
    PROCCVV2        => 'M',
    RESPMSG         => 'Approved',
    RESULT          => 0,
    SECURETOKEN     => '8PbL3UE8NaUGOQdAtGzAY8wZf',
    SECURETOKENID   => 'DB034C3E-1914-11E5-9F6E-A581E074F348',
    SHIPTOCOUNTRY   => 'US',
    TAX             => 0.00,
    TENDER          => 'CC',
    TRANSTIME       => '2015-06-22 12:28:52',
    TRXTYPE         => 'S',
    TYPE            => 'S',
};

{
    my $res = WebService::PayflowPro::Response->new( params => $params );
    ok( $res->success, 'new with params success' );
    is( $res->message, 'Approved', 'response message' );
}

done_testing();
