package WebService::PayPal::PaymentsAdvanced::Mocker;

use Moo;

use Types::Standard qw( Bool );

has _plack => (
    is       => 'ro',
    isa      => Bool,
    init_arg => 'plack',
    default  => 0,
);

use WebService::PayPal::PaymentsAdvanced::Mocker::PayflowLink;
use WebService::PayPal::PaymentsAdvanced::Mocker::PayflowPro;

sub payflow_link {
    my $self = shift;

    local $ENV{PLACK_ENV} = 'development' if $self->_plack;
    return WebService::PayPal::PaymentsAdvanced::Mocker::PayflowLink->to_app;
}

sub payflow_pro {
    my $self = shift;

    local $ENV{PLACK_ENV} = 'development' if $self->_plack;
    return WebService::PayPal::PaymentsAdvanced::Mocker::PayflowPro->to_app;
}

1;

# ABSTRACT: A class which returns mocked PPA apps.

=head1 SYNOPSIS

    use WebService::PayPal::PaymentsAdvanced::Mocker;
    my $mocker = WebService::PayPal::PaymentsAdvanced::Mocker->new( plack => 1 );
    my $app = $mocker->payflow_pro; # returns a PSGI app

    # OR, to use with a mocking UserAgent
    use Test::LWP::UserAgent;
    use HTTP::Message::PSGI;

    my $ua = Test::LWP::UserAgent->new;
    my $mocker = WebService::PayPal::PaymentsAdvanced::Mocker->new( plack => 1 );
    $ua->register_psgi( 'pilot-payflowpro.paypal.com', $mocker->payflow_pro );
    $ua->register_psgi( 'pilot-payflowlink.paypal.com', $mocker->payflow_link );

    my $ppa = WebService::PayPal::PaymentsAdvanced->new(
        ua => $ua,
        ...
    );

=head1 DESCRIPTION

You can use this class to facilitate mocking your PPA integration.  When
running under $ENV{HARNESS_ACTIVE}, you can pass a Test::LWP::UserAgent to
L<WebService::PayPal::PaymentsAdvanced> as in the SYNOPSIS above.  Adjust the
hostnames as necessary.

=head2 new( plack => [0|1] )

The constructor accepts only one argument: C<plack>.  If you require a PSGI app
to be returned, you'll need to enable this option.  Disabled by default.

    use WebService::PayPal::PaymentsAdvanced::Mocker;
    my $mocker = WebService::PayPal::PaymentsAdvanced::Mocker->new( plack => 1 );
    my $app = $mocker->payflow_pro; # returns a PSGI app

=head2 payflow_link

Returns a Mojolicious::Lite app which mocks the Payflow Link web service.

=head2 payflow_pro

Returns a Mojolicious::Lite app which mocks the Payflow Pro web service.

=cut
