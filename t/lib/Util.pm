package Util;

use strict;
use warnings;
use feature qw( say );

use LWP::ConsoleLogger::Easy qw( debug_ua );
use LWP::UserAgent;
use Path::Tiny qw( path );
use WebService::PayPal::PaymentsAdvanced;

sub config {
    my $file = path('t/test-data/config.pl');
    die 'config file required for this script' unless $file->exists;

    ## no critic (BuiltinFunctions::ProhibitStringyEval)
    my $config = eval $file->slurp;
    return $config;
}

sub ppa {
    my %args = @_;

    my $ua = LWP::UserAgent->new;
    debug_ua($ua);
    my $config = config();
    return WebService::PayPal::PaymentsAdvanced->new(
        password                 => $config->{password},
        ua                       => $ua,
        user                     => $config->{user},
        validate_hosted_form_uri => 1,
        vendor                   => $config->{vendor},
        %args,
    );
}

1;
