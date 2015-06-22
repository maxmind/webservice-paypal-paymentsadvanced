use strict;
use warnings;

use Test::More;
use Test::Fatal qw( exception );
use WebService::PayflowPro::Response::FromParams;

SKIP: {
    skip 'no idea why this is messing with the test plan', 1;
    like(
        exception {
            WebService::PayflowPro::Response::FromParams->new( params => {} )
        },
        qr/required for validation/,
        'dies if ip_address is missing and strict checking not disabled'
    );
}

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

my $res = WebService::PayflowPro::Response::FromParams->new(
    params              => $params,
    validate_ip_address => 0,
);

ok( $res->success, 'new with params success' );
is( $res->message, 'Approved', 'response message' );

done_testing();
