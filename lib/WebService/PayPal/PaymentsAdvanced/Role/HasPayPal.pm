package WebService::PayPal::PaymentsAdvanced::Role::HasPayPal;

use Moo::Role;

our $VERSION = '0.000013';

use Types::Common::String qw( NonEmptyStr );

has reference_transaction_id => (
    is       => 'lazy',
    isa      => NonEmptyStr,
    init_arg => undef,
    default  => sub { shift->params->{BAID} },
);

1;

# ABSTRACT: Role which provides methods specifically for PayPal transactions

=head1 METHODS

=head2 reference_transaction_id

The id you will use in order to use this as a reference transaction (C<BAID>).
