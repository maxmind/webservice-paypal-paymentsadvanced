use strict;
use warnings;

use HTTP::Response;
use Test::Fatal qw( exception );
use Test::More;
use WebService::PayflowPro::Response::HTTP;
use WebService::PayflowPro::Response::FromParams;

my $http_response = HTTP::Response->new( 200, undef, undef, 'RESULT=0' );

my $payflow_response
    = WebService::PayflowPro::Response::HTTP->new( raw_response => $http_response );

ok( $payflow_response,          'got response' );
ok( $payflow_response->success, 'successful' );

done_testing();
