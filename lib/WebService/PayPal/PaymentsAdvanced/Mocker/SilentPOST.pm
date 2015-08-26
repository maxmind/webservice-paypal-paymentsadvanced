package WebService::PayPal::PaymentsAdvanced::Mocker::SilentPOST;

use Moo;

sub paypal_success_params {
    my $self = shift;
    my %args = @_;

    return {
        'ADDRESSTOSHIP'   => '1 Main St',
        'AMT'             => '50.00',
        'AVSADDR'         => 'Y',
        'AVSDATA'         => 'YYY',
        'AVSZIP'          => 'Y',
        'BAID'            => 'B-0R272292V1545574R',
        'BILLTOCOUNTRY'   => 'US',
        'BILLTOEMAIL'     => 'paypal_buyer@example.com',
        'BILLTOFIRSTNAME' => 'Test',
        'BILLTOLASTNAME'  => 'Buyer',
        'BILLTONAME'      => 'Test Buyer',
        'CITYTOSHIP'      => 'San Jose',
        'CORRELATIONID'   => '60dee20fe6b74',
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
        'PNREF'           => 'B1PP8A36E2A6',
        'PPREF'           => '2CN92845U6332150A',
        'RESPMSG'         => 'Approved',
        'RESULT'          => '0',
        'SECURETOKEN'     => '8mabQcfgohUm3WeCIv1jVvQiz',
        'SECURETOKENID'   => 'EF2CB000-4BFB-11E5-8575-FE909B07F07B',
        'SHIPTOCITY'      => 'San Jose',
        'SHIPTOCOUNTRY'   => 'US',
        'SHIPTOSTATE'     => 'CA',
        'SHIPTOSTREET'    => '1 Main St',
        'SHIPTOZIP'       => '95131',
        'STATETOSHIP'     => 'CA',
        'TAX'             => '0.00',
        'TENDER'          => 'P',
        'TOKEN'           => 'EC-0NY99380TU249803G',
        'TRANSTIME'       => '2015-08-26 07:08:55',
        'TRXTYPE'         => 'A',
        'TYPE'            => 'A',
        'ZIPTOSHIP'       => '95131',
        %args
    };
}

1;
