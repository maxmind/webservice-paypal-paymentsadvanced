package WebService::PayflowPro;

use Moo;

use feature qw( say );

use Carp qw( croak );
use Data::GUID;
use LWP::UserAgent;
use Types::Standard qw( Bool InstanceOf Str );
use URI;
use URI::FromHash qw( uri uri_object );
use URI::QueryParam;
use WebService::PayflowPro::Response;

has password => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has user => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has vendor => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has partner => (
    is      => 'ro',
    isa     => Str,
    default => 'PayPal'
);

has production_mode => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
);

has ua => (
    is      => 'ro',
    default => sub {
        LWP::UserAgent->new;
    }
);

has host => (
    is => 'lazy',
);

sub _build_host {
    my $self = shift;
    return $self->production_mode
        ? 'payflowpro.paypal.com'
        : 'pilot-payflowpro.paypal.com';
}

sub create_secure_token {
    my $self = shift;
    my $args = shift;

    my %post = map { uc $_ => $args->{$_} } keys %{$args};

    $post{PARTNER}           = $self->partner;
    $post{PWD}               = $self->password;
    $post{USER}              = $self->user;
    $post{VENDOR}            = $self->vendor;
    $post{CREATESECURETOKEN} = 'Y';

    $post{SECURETOKENID} ||= Data::GUID->new->as_string;

    # Create key/value pairs, this may not be totally correct.
    # https://metacpan.org/source/PLOBBES/Business-OnlinePayment-PayflowPro-1.01/PayflowPro.pm#L276

    my $pairs = uri_object( query => \%post )->query_form_hash;
    my $payflow_url = uri( scheme => 'https', host => $self->host );

    my $response = $self->ua->post( $payflow_url, Content => $pairs );

    my $res
        = WebService::PayflowPro::Response->new( raw_response => $response );

    # this should never happen
    if ( $res->success && $res->secure_token_id ne $post{SECURETOKENID} ) {
        croak sprintf(
            'Secure token ids do not match: yours(%s) theirs (%s)',
            $post{SECURETOKENID}, $res->secure_token_id
        );
    }

    return $res;
}

1;

__END__
#ABSTRACT: A simple wrapper around the PayflowPro web service
