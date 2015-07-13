use strict;
use warnings;

use HTTP::Response;
use Test::Fatal qw( exception );
use Test::More;
use WebService::PayPal::PaymentsAdvanced::Response::FromHTTP;

{
    my $http_response = HTTP::Response->new( 200, undef, undef, 'RESULT=0' );

    my $payments_response
        = WebService::PayPal::PaymentsAdvanced::Response::FromHTTP->new(
        http_response => $http_response );

    ok( $payments_response,          'got response' );
}

{
    my $http_response
        = HTTP::Response->new( 500, undef, undef, 'Server error' );

    isa_ok(
        exception {
            my $payments_response
                = WebService::PayPal::PaymentsAdvanced::Response::FromHTTP->new(
                http_response => $http_response );
        },
        'WebService::PayPal::PaymentsAdvanced::Error::HTTP',
        'HTTP error thrown'
    );
}

done_testing();
