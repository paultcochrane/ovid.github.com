package Template::Plugin::Ovid;

use Less::Boilerplate;
use base 'Template::Plugin';

sub new ( $class, $context ) {
    bless {
        _CONTEXT        => $context,
        footnote_number => 1,
        footnote_names  => {},
        footnotes       => [],
    }, $class;
}

sub cite ( $self, $path, $name ) {
    return
      sprintf
'<a href="%s" target="_blank">%s</a> <span class="fa fa-external-link"></span>'
      => $path,
      $name;
}

sub add_footnote ( $self, $note, $name = $self->{footnote_number} ) {
    my $number = $self->{footnote_number}++;
    if ( exists $self->{footnote_names}{$name} ) {
        croak("Footnote '$name' already used");
    }
    $self->{footnote_names}{$name} = 1;
    my $href = qq{<sup><a href="#$name">$number</a></sup>};
    push $self->{footnotes}->@* => qq{<p id="$name">[$number] $note</p>};
    return $href;
}

sub link ( $self, $path, $name ) {
    return sprintf '<a href="%s">%s</a>' => $path, $name;
}

sub get_footnotes($self) {
    return $self->{footnotes};
}

sub has_footnotes($self) {
    return scalar $self->{footnotes}->@*;
}

1;

__END__

=head1 NAME

Template::Plugin::Ovid - Quick utils for my website

=head1 SYNOPSIS

    [% USE Ovid %]
    [% Ovid.link(url, name) %]
    [% Ovid.cite(url, name) %]

=head1 FUNCTIONS

=head2 C<link>

    [% Ovid.link(url, name) %]
    [% Ovid.link('/articles/some-article.html', 'Some Article') %]

Create an internal link to a page.

=head2 C<cite>

    [% Ovid.cite(url, name) %]

Lke C<Ovid.link>, but creates a link to an external site and opens in a new tab. However,
the link is a superscript number, (a C<< <sup> >> tag) to be small an unobtrusive.

We'll see later if this was a mistake.