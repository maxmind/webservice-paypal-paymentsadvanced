package WebService::PayPal::PaymentsAdvanced::Mocker::PayflowPro;

use Mojolicious::Lite;

use Data::GUID;
use DateTime;
use Plack::Builder;
use URI::FromHash qw( uri_object );

app->types->type( nvp => 'text/namevalue' );

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

    if ( $clean->{CREATESECURETOKEN} && $clean->{CREATESECURETOKEN} eq 'Y' ) {
        my %return = (
            RESULT        => 0,
            RESPMSG       => 'Approved',
            SECURETOKENID => $clean->{SECURETOKENID},
            SECURETOKEN   => Data::GUID->new->as_string,
        );

        _render_response( $c, \%return );
        return;
    }

    if ( $clean->{TRXTYPE} && $clean->{TRXTYPE} eq 'D' ) {
        my $dt     = DateTime->now;
        my %return = (
            CORRELATIONID => _new_id(12),
            FEEAMT        => 1.75,
            PAYMENTTYPE   => 'instant',
            PENDINGREASON => 'completed',
            PNREF         => 'B' . _new_id(11),
            PPREF         => _new_id(17),
            RESPMSG       => 'Approved',
            RESULT        => 0,
            TRANSTIME     => $dt->ymd . q{ } . $dt->hms,
        );

        _render_response( $c, \%return );
        return;
    }
    $c->render( text => 'Mocked URL not found', status => 404 );
};

sub _render_response {
    my $c      = shift;
    my $params = shift;

    my $res    = uri_object( query => $params );
    $c->render( text => $res->query, format => 'nvp' );
}

sub _new_id {
    my $length = shift;

    my $id     = Data::GUID->new->as_string;
    $id =~ s{-}{}g;
    $id = substr( $id, 0, $length );
    return $id;
}

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