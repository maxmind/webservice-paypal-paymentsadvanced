package WebService::PayPal::PaymentsAdvanced::Role::HasResultValidation;

use Moo::Role;

use WebService::PayPal::PaymentsAdvanced::Error::Authentication;
use WebService::PayPal::PaymentsAdvanced::Error::Generic;

sub _validate_result {
    my $self = shift;

    my $result = $self->params->{RESULT};

    return if defined $result && !$result;

    if ( $result && $result == 1 ) {
        WebService::PayPal::PaymentsAdvanced::Error::Authentication->throw(
            message => 'Authentication error: ' . $self->message,
            params  => $self->params,
        );
    }

    WebService::PayPal::PaymentsAdvanced::Error::Generic->throw(
        message => $self->message,
        params  => $self->params,
    );
}

1;
