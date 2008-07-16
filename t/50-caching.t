#!/usr/bin/perl -w

use Crypt::ECB;

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

my ($crypt, $cipher, $ks, $len, $nok, $enc, $dec, $test);

my $text = "This is just some dummy text!\n";
my $key  = "This is an at least 56 Byte long test key!!! It really is.";

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
	$crypt->key(substr($key,0,$ks));

	$nok = 0;
	foreach (1..3)
	{
		$crypt->caching( 1-($crypt->caching) ); # toggle caching

		$enc = $crypt->encrypt($text);

		# if caching off, cipherobj must be empty, and vice versa
		$nok++ if $crypt->caching ^ ($crypt->{cipherobj} ne '');

		$dec = $crypt->decrypt($enc);

		$nok++ unless $text eq $dec;
	}
	print "not " if $nok;
	print "ok ".(++$test)."\n";
}
