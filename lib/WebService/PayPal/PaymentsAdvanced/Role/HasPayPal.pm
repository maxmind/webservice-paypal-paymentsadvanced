package WebService::PayPal::PaymentsAdvanced::Role::HasPayPal;

use Moo::Role;

our $VERSION = '0.000008';

use Types::Common::String qw( NonEmptyStr );

has reference_transaction_id => (
    is       => 'lazy',
    isa      => NonEmptyStr,
    init_arg => undef,
    default  => sub { shift->params->{BAID} },
);

1;
