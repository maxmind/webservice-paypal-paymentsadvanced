package WebService::PayflowPro::Response::HTTP;

use Moo;

use MooX::HandlesVia;
use MooX::StrictConstructor;
use Types::Standard qw( HashRef InstanceOf );
use URI;
use URI::QueryParam;

has params => (
    is        => 'lazy',
    isa       => HashRef,
);

has raw_response => (
    is        => 'ro',
    isa       => InstanceOf ['HTTP::Response'],
    required  => 1,
    predicate => 'has_raw_response',
    handles   => { http_response_code => 'code' },
);

with 'WebService::PayflowPro::Role::Response';

sub _build_params {
    my $self    = shift;
    my $results = URI->new( '?' . $self->raw_response->content );
    return $results->query_form_hash;
}

sub _build_success {
    my $self = shift;
    return $self->has_raw_response
        ? $self->raw_response->is_success && $self->params->{RESULT} == 0
        : $self->params->{RESULT} == 0;
}

1;

__END__
# ABSTRACT: Response object for WebService::PayflowPro instantiated from HTTP::Response object
