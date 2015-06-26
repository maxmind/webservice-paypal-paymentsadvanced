requires "Data::GUID" => "0";
requires "LWP::UserAgent" => "0";
requires "List::AllUtils" => "0";
requires "Moo" => "0";
requires "Moo::Role" => "0";
requires "MooX::HandlesVia" => "0";
requires "MooX::StrictConstructor" => "0";
requires "Throwable::Error" => "0";
requires "Types::Standard" => "0";
requires "URI" => "0";
requires "URI::FromHash" => "0";
requires "URI::QueryParam" => "0";
requires "feature" => "0";
requires "perl" => "5.010";
requires "strict" => "0";
requires "warnings" => "0";

on 'build' => sub {
  requires "Module::Build" => "0.28";
};

on 'test' => sub {
  requires "HTTP::Response" => "0";
  requires "LWP::ConsoleLogger::Easy" => "0";
  requires "Path::Tiny" => "0";
  requires "Test::Fatal" => "0";
  requires "Test::More" => "0";
  requires "Test::RequiresInternet" => "0";
  requires "perl" => "5.010";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "Module::Build" => "0.28";
  requires "perl" => "5.010";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Spelling" => "0.12";
  requires "Test::Synopsis" => "0";
};
