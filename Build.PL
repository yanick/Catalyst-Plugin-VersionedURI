
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Carp' => '0',
    'Catalyst' => '0',
    'Module::Build' => '0.3601',
    'Scalar::Util' => '0',
    'Test::More' => '0.94',
    'Test::WWW::Mechanize::Catalyst' => '0',
    'parent' => '0'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'add version component to uris',
  'dist_author' => [
    'Yanick Champoux <yanick@babyl.dyndns.org>'
  ],
  'dist_name' => 'Catalyst-Plugin-VersionedURI',
  'dist_version' => '0.1.0',
  'license' => 'perl',
  'module_name' => 'Catalyst::Plugin::VersionedURI',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Catalyst::Controller' => '0',
    'Moose' => '0',
    'Moose::Role' => '0',
    'perl' => '5.10.0'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
