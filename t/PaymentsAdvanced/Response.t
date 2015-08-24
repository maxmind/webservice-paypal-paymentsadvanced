use strict;
use warnings;

use WebService::PayPal::PaymentsAdvanced::Response;
use Test::Fatal;
use Test::More;

my %params = (
    RESULT        => 0,
    RESPMSG       => 'Approved',
    SECURETOKEN   => 'token',
    SECURETOKENID => 'token_id',
);

{
    isa_ok(
        exception {
            WebService::PayPal::PaymentsAdvanced::Response->new(
                params => {
                    %params,
                    RESULT  => 1,
                    RESPMSG => 'User authentication failed'
                }
            );
        },
        'WebService::PayPal::PaymentsAdvanced::Error::Authentication',
        'authentication exception'
    );
}

done_testing();
