#!/usr/bin/perl -w

use Crypt::ECB qw(encrypt decrypt PADDING_AUTO);

my @ciphers =
(
	'Blowfish',
	'Blowfish_PP',
	'Camellia',
	'Camellia_PP',
	'CAST5',
	'CAST5_PP',
	'DES',
	'DES_PP',
	'IDEA',
	'Rijndael',
	'Rijndael_PP',
	'Twofish2',
);

print "1..", $#ciphers+1, "\n";

my ($crypt, $cipher, $key, $ks, $len, $nok, $enc1, $enc2, $dec1, $dec2, $test);

my $text = "0";
my $xkey = "This is an at least 56 Byte long test key!!! It really is.";

$crypt = Crypt::ECB->new;

$crypt->padding(PADDING_AUTO);

foreach $cipher (@ciphers)
{
	unless ($crypt->cipher($cipher))
	{
		print "ok ".(++$test)." # skip, $cipher not installed\n";
		next;
	}

	$ks = ($crypt->{Keysize} or 8);
	$key = substr($xkey, 0, $ks);
	$crypt->key($key);

	$nok = 0;

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
