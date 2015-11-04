package WebService::PayPal::PaymentsAdvanced::Error::HostedForm;

use Moo;

our $VERSION = '0.000009';

extends 'Throwable::Error';

with 'WebService::PayPal::PaymentsAdvanced::Error::Role::HasHTTPResponse';

1;

# ABSTRACT: An error message which has been parsed out of a hosted form

=head1 SYNOPSIS

    use Try::Tiny;
    use WebService::PayPal::PaymentsAdvanced;

    my $payments = WebService::PayPal::PaymentsAdvanced->new(...);
    my $response = $payments->create_secure_token(...);

    my $uri;
    try {
        $uri = $payments->hosted_form_uri($response);
    }
    catch {
        die $_ unless blessed $_;
        if (
            $_->isa(
                'WebService::PayPal::PaymentsAdvanced::Error::HostedForm')
            ) {
            log_hosted_form_error(
                message          => $_->message,
                response_content => $_->http_response->content,
            );
        }

        # handle other exceptions
    };

=head1 DESCRIPTION

This class represents an error which is embedded into the HTML of a hosted
form.   It will only be thrown if you have enabled
L<WebService::PayPal::PaymentsAdvanced/validate_hosted_form_uri>.

It extends L<Throwable::Error> and adds one attribute of its own.  The message
attribute (inherited from L<Throwable::Error>) will contain the error message
which was parsed out of the content of the HTML.


=head1 METHODS

The C<< $error->message() >>, and C<< $error->stack_trace() >> methods are
inherited from L<Throwable::Error>.

=head2 http_response

Returns the L<HTTP::Response> object which was returned when attempting to GET
the hosted form.

=head2 http_status

Returns the HTTP status code for the response.

=head2 request_uri

The URI of the request that caused the error.

=cut
