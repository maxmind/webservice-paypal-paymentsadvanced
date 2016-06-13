package WebService::PayPal::PaymentsAdvanced::Mocker::PayflowLink;

use Mojolicious::Lite;

our $VERSION = '0.000021';

# A GET request will be a request for the hosted form.

get '/' => sub {
    my $c = shift;
    $c->render( text => 'Hosted form would be here' );
};

sub to_app {
    app->secrets( ['Tempus fugit'] );
    app->start;
}

1;

__END__

# ABSTRACT: A simple app to enable easy Payflow Link (hosted form) mocking

=head1 DESCRIPTION

A simple app to enable easy Payflow Link (hosted form) mocking.

=head2 to_app

    use WebService::PayPal::PaymentsAdvanced::Mocker::PayflowLink;
    my $app = WebService::PayPal::PaymentsAdvanced::Mocker::PayflowLink->to_app;

If you require a Plack app to be returned, you'll need to give Mojo the correct
hint:

    use WebService::PayPal::PaymentsAdvanced::Mocker::PayflowLink;

    local $ENV{PLACK_ENV} = 'development'; #
    my $app = WebService::PayPal::PaymentsAdvanced::Mocker::PayflowLink->to_app;

=cut
