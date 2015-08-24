package WebService::PayPal::PaymentsAdvanced::Role::HasUA;

use Moo::Role;

use LWP::UserAgent;
use Types::Standard qw( InstanceOf );

has ua => (
    is      => 'ro',
    isa     => InstanceOf ['LWP::UserAgent'],
    default => sub {
        my $ua = LWP::UserAgent->new;
        $ua->timeout(5);
        return $ua;
    },
);

1;