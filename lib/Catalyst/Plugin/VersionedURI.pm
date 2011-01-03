package Catalyst::Plugin::VersionedURI;
BEGIN {
  $Catalyst::Plugin::VersionedURI::AUTHORITY = 'cpan:yanick';
}
BEGIN {
  $Catalyst::Plugin::VersionedURI::VERSION = '0.1.0';
}
# ABSTRACT: add version component to uris


use 5.10.0;

use strict;
use warnings;

use Moose::Role;

our @uris;

sub initialize_uri_regex {
    my $self = shift;

    my $conf = $self->config->{VersionedURI}{uri} 
        or return;

    @uris = ref($conf) ? @$conf : ( $conf );
    s#^/## for @uris;
    s#(?<!/)$#/# for @uris;

    return join '|', @uris;
}

sub versioned_uri_regex {
    my $self = shift;
    state $uris_re = $self->initialize_uri_regex;
    return $uris_re;
}

around uri_for => sub {
    my ( $code, $self, @args ) = @_;

    my $uri = $self->$code(@args);

    if ( my $uris_re = $self->versioned_uri_regex ) {
        my $base = $self->req->base;
        $base =~ s#(?<!/)$#/#;  # add trailing '/'

        state $version = $self->VERSION;

        $$uri =~ s#(^\Q$base\E$uris_re)#${1}v$version/#;
    }

    return $uri;
};

1;


__END__
=pod

=head1 NAME

Catalyst::Plugin::VersionedURI - add version component to uris

=head1 VERSION

version 0.1.0

=head1 SYNOPSIS

In your config file:

    <VersionedURI>
        uri  static/
    </VersionedURI>

In C<MyApp.pm>:

   package MyApp;

   use Catalyst qw/ VersionedURI /;

=head1 DESCRIPTION

C<Catalyst::Plugin::VersionedURI> adds a versioned component
to uris matching a given set of regular expressions provided in
the configuration file. In other word, it'll -- for example -- convert

    /static/images/foo.png

into

    /static/v1.2.3/images/foo.png

This can be useful, mainly, to have the
static files of a site magically point to a new location upon new
releases of the application, and thus bypass previously set expiration times.

The versioned component of the uri resolves to C<v>I<$MyApp::VERSION>.

=head1 CONFIGURATION

=head2 uri

The plugin's accepts any number of C<uri> configuration elements, which are 
taken as regular expressions to be matched against the uris. The regular
expressions are implicitly anchored at the beginning of the uri, and at the
end by a '/'. 

=head1 WEB SERVER-SIDE CONFIGURATION

Of course, the redirection to a versioned uri is a sham
to fool the browsers into refreshing their cache. Usually
we configure the front-facing web server to point back to 
the same directory.

=head2 Apache

Typically, the configuration on the Apache side used in conjecture with
this plugin will look like:

    <Directory /home/myapp/static>
        RewriteEngine on
        RewriteRule ^v[0123456789._]+/(.*)$ /myapp/static/$1 [PT]
 
        ExpiresActive on
        ExpiresDefault "access plus 1 year"
    </Directory>

=head1 YOU BROKE MY DEVELOPMENT SERVER, YOU INSENSITIVE CLOD!

While the plugin is working fine with a web-server front-end, it's going to seriously cramp 
your style if you use, for example, the application's standalone server, as
now all the newly-versioned uris are not going to resolve to anything. 
The obvious solution is, well, fairly obvious: remove the VersionedURI 
configuration stanza from your development configuration file.

If, for whatever reason, you absolutly want your application to deal with the versioned 
paths with or without the web server front-end, you can use
L<Catalyst::Controller::VersionedURI>, which will undo what
C<Catalyst::Plugin::VersionedURI> toiled to shoe-horn in.

=head1 SEE ALSO

=over

=item Blog entry introducing the module: L<http://babyl.dyndns.org/techblog/entry/versioned-uri>.

=item L<Catalyst::Controller::VersionedURI>

=back

=head1 AUTHOR

Yanick Champoux <yanick@babyl.dyndns.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

