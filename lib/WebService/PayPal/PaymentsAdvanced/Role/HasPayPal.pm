package WebService::PayPal::PaymentsAdvanced::Role::HasPayPal;

use Moo::Role;

use Types::Common::String qw( NonEmptyStr );

has reference_transaction_id => (
    is       => 'lazy',
    isa      => NonEmptyStr,
    init_arg => undef,
    default  => sub { shift->params->{BAID} },
);

1;
