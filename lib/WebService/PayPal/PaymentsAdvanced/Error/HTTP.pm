package WebService::PayPal::PaymentsAdvanced::Error::HTTP;

use Moo;

use Types::Standard qw( InstanceOf Int );

extends 'Throwable::Error';

has http_status => (
    is       => 'ro',
    isa      => Int,
    required => 1,
);

has http_response => (
    is       => 'ro',
    isa      => InstanceOf ['HTTP::Response'],
    required => 1,
);

1;

# ABSTRACT: An HTTP transport error

=head1 SYNOPSIS

    use Try::Tiny;
    use WebService::PayPal::PaymentsAdvanced;

    my $payments = WebService::PayPal::PaymentsAdvanced->new(
        validate_hosted_form_uri => 1, ... );
    my $response;

    my $uri;
    try {
        $response = $payments->create_secure_token(...);
    }
    catch {
        die $_ unless blessed $_;
        if ( $_->isa('WebService::PayPal::PaymentsAdvanced::Error::HTTP') ) {
            log_http_error(
                message       => $_->message,
                response_code => $_->http_status,
                http_content  => $_->http_response->content,
            );
        }

        # handle other exceptions
    };

=head1 DESCRIPTION

This class represents an error which is embedded into the HTML of a hosted
form.   It will only be thrown if you have enabled
L<WebService::PayPal::PaymentsAdvanced/validate_hosted_form_uri>.

It extends L<Throwable::Error> and adds one attribute of its own.

=head1 METHODS

The C<< $error->message() >>, and C<< $error->stack_trace() >> methods are
inherited from L<Throwable::Error>.

=head2 http_response

Returns the L<HTTP::Response> object which was returned when attempting to GET
the hosted form.

=head2 http_status

Returns the HTTP status code for the response.

=cut