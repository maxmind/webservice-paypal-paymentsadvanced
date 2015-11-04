package WebService::PayPal::PaymentsAdvanced::Response::FromHTTP;

use Moo;

our $VERSION = '0.000009';

use MooX::HandlesVia;
use MooX::StrictConstructor;
use Types::Standard qw( HashRef InstanceOf );
use Types::URI qw( Uri );
use URI;
use URI::QueryParam;
use WebService::PayPal::PaymentsAdvanced::Error::HTTP;

# Don't use HasParams role as we want to build params rather than require them.

has params => (
    is       => 'lazy',
    isa      => HashRef,
    init_arg => undef,
);

has _http_response => (
    is       => 'ro',
    isa      => InstanceOf ['HTTP::Response'],
    init_arg => 'http_response',
    required => 1,
    handles  => { _code => 'code', _content => 'content', },
);


has _request_uri => (
    init_arg => 'request_uri',
    is       => 'ro',
    isa      => Uri,
    coerce   => 1,
    required => 1,
);

sub BUILD {
    my $self = shift;
    return if $self->_http_response->is_success;

    WebService::PayPal::PaymentsAdvanced::Error::HTTP->throw(
        message       => 'HTTP error: ' . $self->_code,
        http_response => $self->_http_response,
        http_status   => $self->_code,
        request_uri   => $self->_request_uri,
    );
}

sub _build_params {
    my $self    = shift;
    my $results = URI->new( '?' . $self->_content );
    return $results->query_form_hash;
}

1;

__END__
# ABSTRACT: Response object for WebService::PayPal::PaymentsAdvanced instantiated from HTTP::Response object

=head1 DESCRIPTION

This module provides an interface for extracting returned params from an
L<HTTP::Response> object.  You won't need to this module directly if you are
using L<PayPal::PaymentsAdvanced/create_secure_token>.

Throws a L<WebService::PayPal::PaymentsAdvanced::Error::HTTP> exception if the
HTTP request was not successful.

=head1 OBJECT INSTANTIATION

The following parameters can be supplied to C<new()> when creating a new object.

=head2 Required Parameters

=head3 http_response

An L<HTTP::Response> object.

=head2 Methods

=head3 params

Returns a C<HashRef> of parameters which have been extracted from the
L<HTTP::Response> object.

=cut
