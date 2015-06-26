use strict;
use warnings;

use HTTP::Response;
use Test::Fatal qw( exception );
use Test::More;
use WebService::PayflowPro::Response::FromHTTP;

{
    my $http_response = HTTP::Response->new( 200, undef, undef, 'RESULT=0' );

    my $payflow_response
        = WebService::PayflowPro::Response::FromHTTP->new(
        http_response => $http_response );

    ok( $payflow_response,          'got response' );
}

{
    my $http_response
        = HTTP::Response->new( 500, undef, undef, 'Server error' );

    isa_ok(
        exception {
            my $payflow_response
                = WebService::PayflowPro::Response::FromHTTP->new(
                http_response => $http_response );
        },
        'WebService::PayflowPro::Error::HTTP',
        'HTTP error thrown'
    );
}

done_testing();
