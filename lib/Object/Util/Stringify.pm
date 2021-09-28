package Object::Util::Stringify;

use strict;
use warnings;

use Scalar::Util qw(blessed refaddr);

use Exporter qw(import);

# AUTHORITY
# DATE
# DIST
# VERSION

our @EXPORT_OK = qw(
                       set_stringify
                       unset_stringify
               );

my %Overloaded_Packages;
my %Object_Strings; # key=refaddr, val=string
sub set_stringify {
    require overload;

    my ($obj, $str) = @_;

    die "First argument must be a blessed reference" unless blessed($obj);

    my $obj_pkg = ref $obj;
    $Object_Strings{ refaddr($obj) } = $str;
    $obj_pkg->overload::OVERLOAD(q("") => \&_overload_string)
        unless $Overloaded_Packages{$obj_pkg}++;

    # return the obj for convenience
    $obj;
}

sub unset_stringify {
    my ($obj, $str) = @_;

    die "First argument must be a blessed reference" unless blessed($obj);

    my $obj_pkg = ref $obj;
    delete $Object_Strings{ refaddr($obj) };

    # return the obj for convenience
    $obj;
}

sub _overload_string {
    my $obj = shift;
    my $key = refaddr $obj;
    exists($Object_Strings{$key}) ? $Object_Strings{$key} : $obj;
}

1;
# ABSTRACT: Utility routines related to object stringification

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use Object::Util::Stringify qw(
     set_stringify
     unset_stringify
 );

 # An easy way to set what string an object should stringify to
 set_stringify($obj, "oh my!");
 print $obj; # => prints "oh my!"

 # Remove stringification
 unset_stringify($obj);
 print $obj; # => prints the standard stringification, e.g. My::Package=HASH(0x562847e245e8)


=head1 DESCRIPTION

Keywords: overload, stringify, stringification


=head1 FUNCTIONS

=head2 set_stringify

Usage:

 set_stringify($obj, $str);

Set object stringification to C<$str>.

Caveats: cloned object currently will not inherit the stringification.

=head2 unset_stringify

Usage:

 unset_stringify($obj);

Reset/remove object stringification.


=head1 SEE ALSO

L<overload>

L<TPrintable>

=cut
