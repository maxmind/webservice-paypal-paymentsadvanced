use strict;
use warnings;

use HTTP::Response;
use Test::More;
use WebService::PayflowPro::Response;

my $http_response = HTTP::Response->new( 200, undef, undef, 'RESULT=0' );

my $payflow_response
    = WebService::PayflowPro::Response->new( raw_response => $http_response );

ok( $payflow_response,          'got response' );
ok( $payflow_response->success, 'successful' );

done_testing();
