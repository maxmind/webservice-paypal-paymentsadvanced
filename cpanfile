requires "Data::GUID" => "0";
requires "DateTime" => "0";
requires "DateTime::Format::MySQL" => "0";
requires "DateTime::TimeZone" => "0";
requires "HTTP::Message::PSGI" => "0";
requires "HTTP::Status" => "0";
requires "LWP::Protocol::https" => "0";
requires "LWP::UserAgent" => "0";
requires "List::AllUtils" => "0";
requires "Mojolicious::Lite" => "0";
requires "Moo" => "1.004005";
requires "Moo::Role" => "0";
requires "MooX::HandlesVia" => "0";
requires "MooX::StrictConstructor" => "0";
requires "Test::LWP::UserAgent" => "0";
requires "Throwable::Error" => "0";
requires "Type::Params" => "0";
requires "Types::Common::Numeric" => "0";
requires "Types::Common::String" => "0";
requires "Types::Standard" => "0";
requires "Types::URI" => "0";
requires "URI" => "1.69";
requires "URI::FromHash" => "0";
requires "URI::QueryParam" => "0";
requires "Web::Scraper" => "0";
requires "feature" => "0";
requires "namespace::autoclean" => "0";
requires "perl" => "5.014";

on 'test' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "HTTP::Response" => "0";
  requires "LWP::ConsoleLogger::Easy" => "0";
  requires "Mozilla::CA" => "20130114";
  requires "Path::Tiny" => "0";
  requires "Scalar::Util" => "0";
  requires "Test::Fatal" => "0";
  requires "Test::More" => "0.96";
  requires "Test::RequiresInternet" => "0";
  requires "Try::Tiny" => "0";
  requires "lib" => "0";
  requires "strict" => "0";
  requires "warnings" => "0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Code::TidyAll::Plugin::Test::Vars" => "0.02";
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Parallel::ForkManager" => "1.19";
  requires "Perl::Critic" => "1.126";
  requires "Perl::Tidy" => "20160302";
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Pod::Wordlist" => "0";
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::CPAN::Meta::JSON" => "0.16";
  requires "Test::CleanNamespaces" => "0.15";
  requires "Test::Code::TidyAll" => "0.50";
  requires "Test::Mojibake" => "0";
  requires "Test::More" => "0.96";
  requires "Test::NoTabs" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Spelling" => "0.12";
  requires "Test::Vars" => "0.009";
  requires "Test::Version" => "2.05";
  requires "perl" => "5.006";
  requires "strict" => "0";
  requires "warnings" => "0";
};
