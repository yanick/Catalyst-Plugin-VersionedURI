package Catalyst::Controller::VersionedURI;
BEGIN {
  $Catalyst::Controller::VersionedURI::AUTHORITY = 'cpan:yanick';
}
BEGIN {
  $Catalyst::Controller::VersionedURI::VERSION = '1.0.0';
}
# ABSTRACT: Revert Catalyst::Plugin::VersionedURI's munging


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

__END__
=pod

=head1 NAME

Catalyst::Controller::VersionedURI - Revert Catalyst::Plugin::VersionedURI's munging

=head1 VERSION

version 1.0.0

=head1 SYNOPSIS

    package MyApp::Controller::VersionedURI;

    use parent 'Catalyst::Controller::VersionedURI';

    1;

=head1 DESCRIPTION

This controller creates actions to catch the 
versioned uris created by C<Catalyst::Plugin::VersionedURI>
with the I<in_path> parameter set to I<true>.

=head1 SEE ALSO

L<Catalyst::Plugin::VersionedURI>

=head1 AUTHOR

Yanick Champoux <yanick@babyl.dyndns.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

