use strict;
use warnings;

use WebService::PayPal::PaymentsAdvanced::Response;
use Test::Fatal;
use Test::More;

my %params = (
    RESPMSG       => 'Approved',
    RESPMSG       => 'User authentication failed',
    RESULT        => 1,
    SECURETOKEN   => 'token',
    SECURETOKENID => 'token_id',
);

{
    isa_ok(
        exception {
            WebService::PayPal::PaymentsAdvanced::Response->new(
                params => \%params );
        },
        'WebService::PayPal::PaymentsAdvanced::Error::Authentication',
        'authentication exception'
    );
}

done_testing();
