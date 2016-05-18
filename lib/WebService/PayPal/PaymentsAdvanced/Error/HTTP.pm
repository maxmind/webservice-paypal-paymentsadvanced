package WebService::PayPal::PaymentsAdvanced::Error::HTTP;

use Moo;

our $VERSION = '0.000018';

extends 'Throwable::Error';

with 'WebService::PayPal::PaymentsAdvanced::Error::Role::HasHTTPResponse';

sub throw_from_http_response {
    my $self = shift;
    my %args = @_;

    my $response = $args{http_response};

    die q{"http_response" parameter is required} unless $response;

    my $message = delete $args{message_prefix} || q{};

    # LWP::UA doesn't throw exceptions or have sane error handling. It just
    # sticks things in random, sometimes-undocumented headers and passes back
    # a fake response.
    if ( ( $response->header('Client-Warning') || q{} ) eq
        'Internal response' ) {
        $message
            .= 'User-agent internal error: ' . ( $response->content || q{} );
    }
    elsif ( my $died_header = $response->header('X-Died') ) {
        $message .= 'User-agent died: ' . $died_header;
    }
    elsif ( my $aborted_header = $response->header('Client-Aborted') ) {
        $message .= 'User-agent aborted: ' . $aborted_header;
    }
    else {
        # Given none of the above were set, this _might_ be a real HTTP
        # error.
        $message .= 'HTTP error: ' . $response->code;
    }
    $self->throw(
        message     => $message,
        http_status => $response->code,
        %args
    );
}

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

This class represents an HTTP transport error.

It extends L<Throwable::Error> and adds one attribute of its own.

=head1 METHODS

The C<< $error->message() >>, and C<< $error->stack_trace() >> methods are
inherited from L<Throwable::Error>.

=head2 http_response

Returns the L<HTTP::Response> object which was returned when attempting the
HTTP request.

=head2 http_status

Returns the HTTP status code for the response.

=head2 request_uri

The URI of the request that caused the HTTP error.

=cut
