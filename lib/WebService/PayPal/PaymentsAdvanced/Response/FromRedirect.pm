package WebService::PayPal::PaymentsAdvanced::Response::FromRedirect;

use Moo;

use List::AllUtils qw( any );
use MooX::HandlesVia;
use MooX::StrictConstructor;
use Types::Standard qw( Bool HashRef Str );
use WebService::PayPal::PaymentsAdvanced::Error::IPVerification;

sub BUILD {
    my $self = shift;

    return
        if !$self->has_ip_address
        || $self->has_ip_address && $self->_ip_address_is_verified;

    WebService::PayPal::PaymentsAdvanced::Error::IPVerification->throw(
        message => $self->_ip_address . ' is not a verified PayPal address',
        ip_address => $self->_ip_address,
        params     => $self->params,
    );
}

has _ip_address => (
    is        => 'ro',
    isa       => Str,
    init_arg  => 'ip_address',
    required  => 0,
    predicate => 'has_ip_address',
);

has _ip_address_is_verified => (
    is       => 'ro',
    isa      => Bool,
    lazy     => 1,
    init_arg => undef,
    builder  => '_build_ip_address_is_verified',
);

# Payments Advanced IPs listed at
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

sub _build_ip_address_is_verified {
    my $self = shift;

    return any { $_ eq $self->_ip_address } $self->_all_verified_ip_addresses;
}

1;

__END__
# ABSTRACT: Response object for WebService::PayPal::PaymentsAdvanced instatiated via HashRef of params
