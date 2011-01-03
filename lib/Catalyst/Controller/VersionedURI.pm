package Catalyst::Controller::VersionedURI;
# ABSTRACT: Revert Catalyst::Plugin::VersionedURI's munging

=head1 SYNOPSIS

    package MyApp::Controller::VersionedURI;

    use parent 'Catalyst::Controller::VersionedURI';

    1;

=head1 DESCRIPTION

This controller creates actions to catch the 
versioned uris created by C<Catalyst::Plugin::VersionedURI>.

=head1 SEE ALSO

L<Catalyst::Plugin::VersionedURI>

=cut

use strict;
use warnings;

use Moose;

BEGIN { extends 'Catalyst::Controller' }

after BUILDALL => sub {
    my $self = shift;
    my $app = $self->_app;

    my $regex = $app->versioned_uri_regex;

# we catch the old versions too
eval <<"END";
sub versioned :Regex('(${regex})v') {
    my ( \$self, \$c ) = \@_;

    my \$uri = \$c->req->uri;

    \$uri =~ s#(${regex})v.*?/#\$1#;

    \$c->res->redirect( \$uri );

}
END

};

1;
