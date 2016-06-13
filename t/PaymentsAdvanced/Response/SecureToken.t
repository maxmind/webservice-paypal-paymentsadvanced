use strict;
use warnings;

use HTTP::Response;
use Test::Fatal;
use Test::LWP::UserAgent;
use Test::More;
use WebService::PayPal::PaymentsAdvanced::Response::SecureToken;

my %params = (
    RESULT        => 0,
    RESPMSG       => 'Approved',
    SECURETOKEN   => 'token',
    SECURETOKENID => 'token_id',
);

{
    my $res
        = WebService::PayPal::PaymentsAdvanced::Response::SecureToken->new(
        nonfatal_result_codes    => [0],
        params                   => \%params,
        payflow_link_uri         => 'http://example.com',
        validate_hosted_form_uri => 0,
        );

    is( $res->message,         'Approved', 'message' );
    is( $res->secure_token,    'token',    'token' );
    is( $res->secure_token_id, 'token_id', 'secure_token_id' );

    ok( $res,                  'can create response object' );
    ok( $res->hosted_form_uri, 'hosted_form_uri' );
}

subtest 'test error' => sub {
    my $ua = Test::LWP::UserAgent->new;

    $ua->map_response(
        'example.com',
        HTTP::Response->new(
            '500', 'OK',
            [ 'Content-Type' => 'text/html' ], q{}
        )
    );

    my $res
        = WebService::PayPal::PaymentsAdvanced::Response::SecureToken->new(
        nonfatal_result_codes    => [0],
        params                   => \%params,
        payflow_link_uri         => 'http://example.com',
        validate_hosted_form_uri => 1,
        ua                       => $ua,
        );

    my $ex = exception { $res->hosted_form_uri };

    isa_ok( $ex, 'WebService::PayPal::PaymentsAdvanced::Error::HTTP' );
    like(
        $ex,
        qr{\Qhosted_form URI does not validate (http://example.com?SECURETOKEN=token&SECURETOKENID=token_id):HTTP error (500):\E},
        'received correct exception text'
    );
};

done_testing();
