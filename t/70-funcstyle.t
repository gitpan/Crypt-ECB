#!/usr/bin/perl -w

BEGIN { print "1..6\n" }

use Crypt::ECB qw(encrypt decrypt PADDING_AUTO);

my ($crypt, $cipher, $ks, $len, $nok, $enc1, $enc2, $dec1, $dec2, $test);

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
    $key = substr($key, 0, $ks);
    $crypt->key($key);

    $nok = 0;

    $crypt->padding(PADDING_AUTO);

    $enc1 = $crypt->encrypt($text);
    $enc2 = encrypt($key, $cipher, $text, PADDING_AUTO);
    $nok++ unless ($enc1 eq $enc2);

    $dec1 = $crypt->decrypt($enc1);
    $dec2 = decrypt($key, $cipher, $enc2, PADDING_AUTO);
    $nok++ unless ($dec1 eq $text);
    $nok++ unless ($dec2 eq $text);

    print "not " if $nok;
    print "ok ".(++$test)."\n";
}
