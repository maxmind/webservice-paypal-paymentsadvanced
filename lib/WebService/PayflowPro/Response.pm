package WebService::PayflowPro::Response;

use Moo;

use Carp qw( croak );
use MooX::HandlesVia;
use Types::Standard qw( HashRef InstanceOf );
use URI;
use URI::QueryParam;

sub BUILD {
    my $self = shift;
    unless ( $self->has_params || $self->has_raw_response ) {
        croak 'You must provide either params or an HTTP::Response object.';
    }
}

has params => (
    is        => 'lazy',
    isa       => HashRef,
    predicate => 'has_params',
);

has raw_response => (
    is        => 'ro',
    isa       => InstanceOf ['HTTP::Response'],
    required  => 0,
    predicate => 'has_raw_response',
    handles   => { http_response_code => 'code' },
);

has success => (
    is => 'lazy',
);

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

sub message {
    my $self = shift;
    return $self->params->{RESPMSG};
}

sub secure_token {
    my $self = shift;
    return $self->params->{SECURETOKEN};
}

sub secure_token_id {
    my $self = shift;
    return $self->params->{SECURETOKENID};
}

1;

__END__
# ABSTRACT: Response object for WebService::PayflowPro
