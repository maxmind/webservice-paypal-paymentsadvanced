package WebService::PayflowPro::Response;

use Moo;

use MooX::HandlesVia;
use Types::Standard qw( HashRef InstanceOf );
use URI;
use URI::QueryParam;

has params => (
    is  => 'lazy',
    isa => HashRef,
);

has raw_response => (
    is       => 'ro',
    isa      => InstanceOf ['HTTP::Response'],
    required => 1,
    handles  => { http_response_code => 'code' },
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
    return $self->raw_response->is_success && $self->params->{RESULT} == 0;
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
