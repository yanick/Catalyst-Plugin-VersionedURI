Project=~/work/perl-modules/Catalyst-Plugin-VersionedURI CD=. {
lib=lib CD=. filter="**/*.pm"  {
  Catalyst/Plugin/VersionedURI.pm
  Catalyst/Controller/VersionedURI.pm
}
test=t CD=. filter='t/**/*.t' {
}
dist=. {
  MANIFEST
  MANIFEST.SKIP
  dist.ini
}
}
