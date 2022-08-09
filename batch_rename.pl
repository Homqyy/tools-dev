use warnings;
use strict;
use IO::Dir;
use File::Basename;

########################################## function

sub usage
{
    print "Usage: $0 <dir> <old_prefix> <new_prefix>\n"
}

sub rename
{
    my ($path, $old_prefix, $new_prefix, $level) = @_;

    my $bn = basename $path;
    my $dn = dirname $path;

    return 0 if ($bn eq "." || $bn eq "..");

    print "    " x $level . "$bn";

    unless (-d $path)
    {
        my $new_name = $bn;
        if ($new_name =~ s/^$old_prefix/$new_prefix/)
        {
            print " => $new_name";
            rename "$dn/$bn", "$dn/$new_name";
        }

        print " [f]\n";

        return 0;
    }

    print " [d]\n";

    my $d = IO::Dir->new("$dn/$bn");

    if (defined $d)
    {
        while (defined (my $name = $d->read))
        {
            &rename("$dn/$bn/$name", $old_prefix, $new_prefix, $level+1);
        }
    }
}

##########################################

if (@ARGV != 3)
{
    &usage();
    exit 1;
}

&rename(@ARGV, 0)


