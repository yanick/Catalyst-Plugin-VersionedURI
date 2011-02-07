package MTimeApp;

use strict;
use warnings;

use Catalyst qw/ VersionedURI /;

our $VERSION = '1.2.3';

__PACKAGE__->config({
    VersionedURI => {
        uri => [ qw# foo/ bar  # ],
        mtime => 1,
    }
});

__PACKAGE__->setup;

1;
