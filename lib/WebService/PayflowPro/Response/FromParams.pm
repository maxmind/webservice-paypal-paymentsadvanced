package WebService::PayflowPro::Response::FromParams;

use Moo;

use Carp qw( croak );
use List::AllUtils qw( any );
use MooX::HandlesVia;
use MooX::StrictConstructor;
use Types::Standard qw( Bool HashRef Str );

has ip_address => (
    is        => 'ro',
    isa       => Str,
    required  => 0,
    predicate => 'has_ip_address',
);

has ip_address_is_verified => (
    is       => 'lazy',
    isa      => Bool,
    init_arg => undef,
);

# Payflow IPs listed at
# https://ppmts.custhelp.com/app/answers/detail/a_id/883/kw/payflow%20Ip

has _ip_addresses => (
    is          => 'ro',
    isa         => HashRef,
    handles_via => 'Hash',
    handles     => { _all_verified_ip_addresses => 'values' },
    default     => sub {
        +{
            'agw.paypal.com'                              => '173.0.82.33',
            'buyerauth.verisign.com'                      => '173.0.82.36',
            'cr.cybercash.com'                            => '173.0.82.40',
            'manager.paypal.com'                          => '173.0.82.44',
            'payflow.verisign.com'                        => '173.0.82.47',
            'payflowlink.paypal.com'                      => '173.0.82.48',
            'payflowpro.paypal.com'                       => '173.0.82.162',
            'payflowpro.verisign.com'                     => '173.0.82.49',
            'partnermanager.paypal.com'                   => '173.0.82.46',
            'payments.verisign.com'                       => '173.0.82.51',
            'payments.verisign.com.au'                    => '173.0.82.171',
            'payments-reports.paypal.com/reportingengine' => '173.0.82.50',
            'paypalmanager.paypal.com'                    => '173.0.82.164',
            'registration.paypal.com'                     => '173.0.82.165',
            'xml-reg.paypal.com'                          => '173.0.82.172',
            'xml-reg.verisign.com/xmlreg'                 => '173.0.82.173',
        };
    },
);

has params => (
    is       => 'ro',
    isa      => HashRef,
    required => 1,
);

with 'WebService::PayflowPro::Role::Response';

sub _build_ip_address_is_verified {
    my $self = shift;

    croak 'IP address required for validation' unless $self->ip_address;

    return any { $_ eq $self->ip_address } $self->_all_verified_ip_addresses;
}

sub _build_success {
    my $self = shift;
    return $self->has_ip_address
        ? $self->ip_address_is_verified && $self->params->{RESULT} == 0
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
# ABSTRACT: Response object for WebService::PayflowPro instatiated via HashRef of params