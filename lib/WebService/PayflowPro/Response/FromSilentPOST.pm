package WebService::PayflowPro::Response::SilentPOST;

use Moo;

# The logic for these two classes is exactly the same.  We subclass rather than
# using roles so that we don't have to duplicate the BUILD method.

extends 'WebService::PayflowPro::Response::FromRedirect';

1;
