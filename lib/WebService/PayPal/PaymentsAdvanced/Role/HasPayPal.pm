package WebService::PayPal::PaymentsAdvanced::Role::HasPayPal;

use Moo::Role;

use Types::Standard qw( Str );

has reference_transaction_id => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
    default  => sub { shift->params->{BAID} },
);

1;
