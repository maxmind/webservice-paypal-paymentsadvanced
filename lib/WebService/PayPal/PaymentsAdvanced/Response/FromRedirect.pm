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
# ABSTRACT: Response object for WebService::PayPal::PaymentsAdvanced instantiated via HashRef of params

=head1 DESCRIPTION

This module provides an interface for extracting returned params from an
L<HTTP::Response> object.  You won't need to this module directly if you are
using L<PayPal::PaymentsAdvanced/create_secure_token>.

Throws a L<WebService::PayPal::PaymentsAdvanced::Error::HTTP> exception if the
HTTP request was not successful.

=head1 OBJECT INSTANTIATION

The following parameters can be supplied to C<new()> when creating a new object.

=head2 Required Parameters

=head3 params

Returns a C<HashRef> of parameters which have been returned from PayPal via a
redirect or a silent POST.

=head2 Optional Parameters

=head3 ip_address

This is the IP address from which the PayPal params have been returned.  If
you provide an IP address, it will be validated against a list of known valid
IP addresses which have been provided by PayPal.  You are encouraged to
provide an IP in order to prevent spoofing.

This module will throw a
L<WebService::PayPal::PaymentsAdvanced::Error::IPVerification> exception if
the provided IP address cannot be validated.

=head2 Methods

=head3 params

Returns the same C<HashRef> of parameters which was initially provided to the
C<new> method.

=cut
