package WebService::PayPal::PaymentsAdvanced::Mocker::PayflowPro;

use Mojolicious::Lite;

use Data::GUID;
use Plack::Builder;
use URI::FromHash qw( uri_object );

# A GET request will be a request for the hosted form.  The GET is for an
# entirely different host name, so would make sense to move this into a
# different package.  One for mocking payflowpro and one for mocking
# payflowlink.  That would be less confusing in the case of stray GET requests.

# To summarize, GETs are requests for pilot-payflowlink.paypal.com and POSTs are
# requests for pilot-payflowpro.com

get '/' => sub {
    my $c = shift;
    $c->render( text => 'Hosted form would be here' );
};

post '/' => sub {
    my $c     = shift;
    my $clean = _filter_params($c);

    use DDP;
    p($clean);
    if ( $clean->{CREATESECURETOKEN} && $clean->{CREATESECURETOKEN} eq 'Y' ) {
        my %return = (
            RESULT        => 0,
            RESPMSG       => 'Approved',
            SECURETOKENID => $clean->{SECURETOKENID},
            SECURETOKEN   => Data::GUID->new->as_string,
        );

        my $res = uri_object( query => \%return );

        # Not sure if PayPal does any encoding on the way out
        $c->render( text => $res->query );
        return;
    }
    $c->render( text => 'Mocked URL not found', status => 404 );
};

sub _filter_params {
    my $c      = shift;
    my $params = $c->req->params->to_hash;
    my %filtered;
    foreach my $key ( keys %{$params} ) {
        my $value = $params->{$key};
        $key =~ s{\[\d*\]}{};
        $filtered{$key} = $value;
    }
    return \%filtered;
}

sub to_app {
    app->secrets( ['Tempus fugit'] );
    builder {
        app->start;
    }
}

1;

=head1 DESCRIPTION

A simple app to enable easy PPA mocking.

=head2 to_app

    use WebService::PayPal::PaymentsAdvanced::Mocker::PayflowPro;
    my $app = WebService::PayPal::PaymentsAdvanced::Mocker::PayflowPro->to_app;

If you require a Plack app to be returned, you'll need to give Mojo the correct
hint:

    use WebService::PayPal::PaymentsAdvanced::Mocker::PayflowPro;

    local $ENV{PLACK_ENV} = 'development'; #
    my $app = WebService::PayPal::PaymentsAdvanced::Mocker::PayflowPro->to_app;

=cut
