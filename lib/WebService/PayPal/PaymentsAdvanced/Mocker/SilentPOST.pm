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

    return $self->_validate_args(
        {
            'ADDRESSTOSHIP'   => '1 Main St',
            'AMT'             => '50.00',
            'AVSADDR'         => 'Y',
            'AVSDATA'         => 'YYY',
            'AVSZIP'          => 'Y',
            'BAID'            => 'XXX',
            'BILLTOCOUNTRY'   => 'US',
            'BILLTOEMAIL'     => 'paypal_buyer@example.com',
            'BILLTOFIRSTNAME' => 'Test',
            'BILLTOLASTNAME'  => 'Buyer',
            'BILLTONAME'      => 'Test Buyer',
            'CITYTOSHIP'      => 'San Jose',
            'CORRELATIONID'   => 'XXX',
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
            'PNREF'           => 'XXX',
            'PPREF'           => 'XXX',
            'RESPMSG'         => 'Approved',
            'RESULT'          => '0',
            'SECURETOKEN'     => 'XXX',
            'SHIPTOCITY'      => 'San Jose',
            'SHIPTOCOUNTRY'   => 'US',
            'SHIPTOSTATE'     => 'CA',
            'SHIPTOSTREET'    => '1 Main St',
            'SHIPTOZIP'       => '95131',
            'STATETOSHIP'     => 'CA',
            'TAX'             => '0.00',
            'TENDER'          => 'P',
            'TOKEN'           => 'XXX',
            'TRANSTIME'       => 'XXX',
            'TRXTYPE'         => 'A',
            'TYPE'            => 'A',
            'ZIPTOSHIP'       => '95131',
        },
        \%args,
    );
}

sub credit_card_success_params {
    my $self = shift;
    my %args = @_;

    return $self->_validate_args(
        {
            ACCT          => 4482,
            AMT           => 50.00,
            AUTHCODE      => 111111,
            AVSADDR       => 'Y',
            AVSDATA       => 'YYY',
            AVSZIP        => 'Y',
            BILLTOCOUNTRY => 'US',
            CARDTYPE      => 3,
            CORRELATIONID => 'fb36aaa2675e',
            COUNTRY       => 'US',
            COUNTRYTOSHIP => 'US',
            CVV2MATCH     => 'Y',
            EMAILTOSHIP   => q{},
            EXPDATE       => 1221,
            IAVS          => 'N',
            INVNUM        => 69,
            INVOICE       => 69,
            LASTNAME      => 'NotProvided',
            METHOD        => 'CC',
            PNREF         => 'B13P8A3DC93A',
            PPREF         => '67X48437L6824800J',
            PROCAVS       => 'X',
            PROCCVV2      => 'M',
            RESPMSG       => 'Approved',
            RESULT        => 0,
            SECURETOKEN   => '9dWh93jXhkkOi4C3INWBAWgxN',
            SECURETOKENID => '2C57ECE0-4D07-11E5-86F7-FC7F9B07F07B',
            SHIPTOCOUNTRY => 'US',
            TAX           => 0.00,
            TENDER        => 'CC',
            TRANSTIME     => '2015-08-27 15:01:42',
            TRXTYPE       => 'A',
            TYPE          => 'A',
        },
        \%args
    );
}

sub credit_card_duplicate_invoice_id_params {
    my $self = shift;
    my %args = @_;

    return $self->_validate_args(
        {
            'ACCT'          => '4482',
            'AMT'           => '50.00',
            'AVSDATA'       => 'XXN',
            'BILLTOCOUNTRY' => 'US',
            'CARDTYPE'      => '3',
            'COUNTRY'       => 'US',
            'COUNTRYTOSHIP' => 'US',
            'EMAILTOSHIP'   => q{},
            'EXPDATE'       => '1221',
            'HOSTCODE'      => '10536',
            'INVNUM'        => '64',
            'INVOICE'       => '64',
            'LASTNAME'      => 'NotProvided',
            'METHOD'        => 'CC',
            'PNREF'         => 'XXX',
            'RESULT'        => '30',
            'SECURETOKEN'   => 'XXX',
            'SHIPTOCOUNTRY' => 'US',
            'TAX'           => '0.00',
            'TENDER'        => 'CC',
            'TRANSTIME'     => 'XXX',
            'TRXTYPE'       => 'A',
            'TYPE'          => 'A',
            'RESPMSG' =>
                'Duplicate trans:  10536-The transaction was refused as a result of a duplicate invoice ID supplied.  Attempt with a new invoice ID',
        },
        \%args
    );
}

sub _validate_args {
    my $self         = shift;
    my $default_args = shift;
    my $user_args    = shift;

    $default_args = $self->_set_defaults($default_args);
    die 'SECURETOKENID missing' unless $user_args->{SECURETOKENID};

    return { %{$default_args}, %{$user_args} };
}

sub _set_defaults {
    my $self     = shift;
    my $defaults = shift;

    my %method_for = (
        BAID          => 'baid',
        CORRELATIONID => 'correlationid',
        PNREF         => 'pnref',
        PPREF         => 'ppref',
        TRANSTIME     => 'transtime',
        SECURETOKEN   => 'secure_token',
        TOKEN         => 'token',
    );

    for my $key ( keys %method_for ) {
        if ( exists $defaults->{$key} ) {
            my $method = $method_for{$key};
            $defaults->{$key} = $self->_helper->$method;
        }
    }
    return $defaults;
}

1;
