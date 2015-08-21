package WebService::PayPal::PaymentsAdvanced::Response::FromSilentPOST;

use Moo;

use List::AllUtils qw( any );
use MooX::HandlesVia;
use MooX::StrictConstructor;
use Types::Standard qw( Bool HashRef Str );
use WebService::PayPal::PaymentsAdvanced::Error::IPVerification;

with(
    'WebService::PayPal::PaymentsAdvanced::Role::HasParams',
    'WebService::PayPal::PaymentsAdvanced::Role::HasTender',
    'WebService::PayPal::PaymentsAdvanced::Role::HasTokens',
    'WebService::PayPal::PaymentsAdvanced::Role::HasResultValidation',
);

sub BUILD {
    my $self = shift;

    $self->_validate_result;

    return
        if !$self->_has_ip_address
        || $self->_has_ip_address && $self->_ip_address_is_verified;

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
    predicate => '_has_ip_address',
);

has _ip_address_is_verified => (
    is       => 'ro',
    isa      => Bool,
    lazy     => 1,
    init_arg => undef,
    builder  => '_build_ip_address_is_verified',
);

# Payments Advanced IPs listed at
# https://www.paypal-techsupport.com/app/answers/detail/a_id/883/kw/payflow%20Ip

has _ip_addresses => (
    is          => 'ro',
    isa         => HashRef,
    handles_via => 'Hash',
    handles     => { _all_verified_ip_addresses => 'values' },
    default     => sub {
        +{
            'notify.paypal.com' => '173.0.81.65',
        };
    },
);

sub _build_ip_address_is_verified {
    my $self = shift;

    return any { $_ eq $self->_ip_address } $self->_all_verified_ip_addresses;
}

1;

__END__
# ABSTRACT: Response object generated via Silent POST params

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
