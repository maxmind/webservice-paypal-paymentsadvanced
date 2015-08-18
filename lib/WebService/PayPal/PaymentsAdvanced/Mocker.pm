package WebService::PayPal::PaymentsAdvanced::Mocker;

use Moo;

use WebService::PayPal::PaymentsAdvanced::Mocker::PayflowLink;
use WebService::PayPal::PaymentsAdvanced::Mocker::PayflowPro;

sub payflow_link {
    return WebService::PayPal::PaymentsAdvanced::Mocker::PayflowLink->to_app;
}

sub payflow_pro {
    return WebService::PayPal::PaymentsAdvanced::Mocker::PayflowPro->to_app;
}

1;

=head1 DESCRIPTION

A simple app to enable easy PPA mocking.

=head2 payflow_link

Returns a Mojolicious::Lite app which mocks the Payflow Link web service.

=head2 payflow_pro

Returns a Mojolicious::Lite app which mocks the Payflow Pro web service.

=cut
