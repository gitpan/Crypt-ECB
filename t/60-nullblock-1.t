#!/usr/bin/perl -w

BEGIN { print "1..6\n" }

use Crypt::ECB;

my ($crypt, $cipher, $ks, $len, $nok, $enc, $dec, $test);

my $text = "0";
my $key  = "This is an at least 56 Byte long test key!!! It really is.";

my @ciphers = (
	       'Blowfish',
               'Blowfish_PP',
	       'DES',
	       'DES_PP',
	       'IDEA',
	       'Twofish2',
	      );

$crypt = Crypt::ECB->new;

foreach $cipher (@ciphers) {
    unless ($crypt->cipher($cipher)) {
	print "ok ".(++$test)." # skip, $cipher not installed\n";
        next;
    }

    $ks = ($crypt->{Keysize} or 8);
    $crypt->key(substr($key,0,$ks));

    $nok = 0;

    $crypt->padding(PADDING_AUTO);
    $enc = $crypt->encrypt($text);
    $nok++ unless $crypt->decrypt($enc) eq $text;

    print "not " if $nok;
    print "ok ".(++$test)."\n";
}
