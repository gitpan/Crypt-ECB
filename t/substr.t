#!/usr/bin/perl -w

BEGIN { print "1..6\n" }

use Crypt::ECB;

my ($crypt, $cipher, $ks, $len, $nok, $enc, $dec, $test);

my $text = "This is just some dummy text!\n";
my $key  = "This is an at least 56 Byte long test key!!! It really is.";

my @data = (
	    'Blowfish',
	    'Blowfish_PP',
	    'DES',
	    'DES_PP',
	    'IDEA',
	    'Twofish2',
	   );

$crypt = Crypt::ECB->new;

$crypt->padding(PADDING_AUTO);

foreach $cipher (@data) {
    unless ($crypt->cipher($cipher)) {
	print "ok ".(++$test)." # skip, $cipher not installed\n";
        next;
    }

    $ks = ($crypt->{Keysize} or 8);
    $crypt->key(substr($key,0,$ks));

    $nok = 0;
    foreach $len (0..length($text))
    {
	$enc = $crypt->encrypt(substr($text,0,$len));
	$dec = $crypt->decrypt($enc);
	$nok++ unless substr($text,0,$len) eq $dec;
    }
    print "not " if $nok;
    print "ok ".(++$test)."\n";
}
