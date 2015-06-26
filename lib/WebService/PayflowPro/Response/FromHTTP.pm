package WebService::PayflowPro::Response::FromHTTP;

use Moo;

use MooX::HandlesVia;
use MooX::StrictConstructor;
use Types::Standard qw( HashRef InstanceOf );
use URI;
use URI::QueryParam;
use WebService::PayflowPro::Error::HTTP;

has params => (
    is  => 'lazy',
    isa => HashRef,
);

has _http_response => (
    is       => 'ro',
    isa      => InstanceOf ['HTTP::Response'],
    init_arg => 'http_response',
    required => 1,
    handles  => { _code => 'code', _content => 'content', },
);

sub BUILD {
    my $self = shift;
    return if $self->_http_response->is_success;

    WebService::PayflowPro::Error::HTTP->throw(
        message       => 'HTTP error: ' . $self->_code,
        http_response => $self->_http_response,
        http_status   => $self->_code,
    );
}

sub _build_params {
    my $self    = shift;
    my $results = URI->new( '?' . $self->_content );
    return $results->query_form_hash;
}

1;

__END__
# ABSTRACT: Response object for WebService::PayflowPro instantiated from HTTP::Response object
