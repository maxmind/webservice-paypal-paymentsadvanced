use strict;
use warnings;

use WebService::PayflowPro::Response;
use Test::Fatal;
use Test::More;

my %params = (
    RESULT        => 0,
    RESPMSG       => 'Approved',
    SECURETOKEN   => 'token',
    SECURETOKENID => 'token_id',
);

{
    my $res = WebService::PayflowPro::Response->new( params => \%params );

    is( $res->message,         'Approved', 'message' );
    is( $res->secure_token,    'token',    'token' );
    is( $res->secure_token_id, 'token_id', 'secure_token_id' );

    ok( $res, 'can create response object' );
}

{
    isa_ok(
        exception {
            WebService::PayflowPro::Response->new(
                params => {
                    %params,
                    RESULT  => 1,
                    RESPMSG => 'User authentication failed'
                }
            );
        },
        'WebService::PayflowPro::Error::Authentication',
        'authentication exception'
    );
}

done_testing();
