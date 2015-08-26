package WebService::PayPal::PaymentsAdvanced::Mocker::SilentPOST;

use Moo;

use Types::Standard qw( InstanceOf );
use WebService::PayPal::PaymentsAdvanced::Mocker::Helper;

has _helper => (
    is => 'lazy',
    isa =>
        InstanceOf ['WebService::PayPal::PaymentsAdvanced::Mocker::Helper'],
    default =>
        sub { WebService::PayPal::PaymentsAdvanced::Mocker::Helper->new },
);

sub paypal_success_params {
    my $self = shift;
    my %args = @_;

    die 'SECURETOKENID missing' unless $args{SECURETOKENID};

    return {
        'ADDRESSTOSHIP'   => '1 Main St',
        'AMT'             => '50.00',
        'AVSADDR'         => 'Y',
        'AVSDATA'         => 'YYY',
        'AVSZIP'          => 'Y',
        'BAID'            => $self->_helper->baid,
        'BILLTOCOUNTRY'   => 'US',
        'BILLTOEMAIL'     => 'paypal_buyer@example.com',
        'BILLTOFIRSTNAME' => 'Test',
        'BILLTOLASTNAME'  => 'Buyer',
        'BILLTONAME'      => 'Test Buyer',
        'CITYTOSHIP'      => 'San Jose',
        'CORRELATIONID'   => $self->_helper->correlationid,
        'COUNTRY'         => 'US',
        'COUNTRYTOSHIP'   => 'US',
        'EMAIL'           => 'paypal_buyer@example.com',
        'FIRSTNAME'       => 'Test',
        'INVNUM'          => '61',
        'INVOICE'         => '61',
        'LASTNAME'        => 'Buyer',
        'METHOD'          => 'P',
        'NAME'            => 'Test Buyer',
        'NAMETOSHIP'      => 'Test Buyer',
        'PAYERID'         => 'R8RAGUNASE6VA',
        'PAYMENTTYPE'     => 'instant',
        'PENDINGREASON'   => 'authorization',
        'PNREF'           => $self->_helper->pnref,
        'PPREF'           => $self->_helper->ppref,
        'RESPMSG'         => 'Approved',
        'RESULT'          => '0',
        'SECURETOKEN'     => $self->_helper->secure_token,
        'SHIPTOCITY'      => 'San Jose',
        'SHIPTOCOUNTRY'   => 'US',
        'SHIPTOSTATE'     => 'CA',
        'SHIPTOSTREET'    => '1 Main St',
        'SHIPTOZIP'       => '95131',
        'STATETOSHIP'     => 'CA',
        'TAX'             => '0.00',
        'TENDER'          => 'P',
        'TOKEN'           => $self->_helper->token,
        'TRANSTIME'       => $self->_helper->transtime,
        'TRXTYPE'         => 'A',
        'TYPE'            => 'A',
        'ZIPTOSHIP'       => '95131',
        %args
    };
}

1;
