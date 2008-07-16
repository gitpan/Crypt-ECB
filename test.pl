#!/usr/bin/perl -w

use Crypt::ECB;

my ($path, $retval, $ok);

my $crypt = Crypt::ECB->new;

print "Checking your perl installation for cipher modules:\n";

foreach $path (@INC) {
    while (<$path/Crypt/*.pm>) {
	s|^.*Crypt/||;
	s|\.pm$||;
	$retval = 0;
	eval { $retval = $crypt->cipher($_) };
	print " Found $_.\n" if $retval and ++$ok;
    }
}

unless ($ok) {
    print "There are no crypt modules installed that I know of."
	. " Attention: Crypt::ECB will not be of any use to you"
	. " unless you install some cipher module(s).\n";
}
