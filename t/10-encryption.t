#!/usr/bin/perl -w

BEGIN { print "1..5\n" }

use Crypt::ECB;

my ($crypt, $cipher, $ks, $enc, $test);

my $text = "This is just some dummy text!\n";
my $key  = "This is an at least 56 Byte long test key!!! It really is.";

my %data = (
	    'Blowfish',
    '0bc9ff2cfa46ba9f783a4cb66e2fea9b0b34a5d7cc73d74542db1a7afa9eb300',

	    'Blowfish_PP',
    '52a037af4a2aea2d10cc09183b433f1a12c5ce734067d597da040861fed3ae61',

	    'DES',
    'a47b1b2c90fb3b7a7367c1844d3d07e620b943fdc6728a05e5cf69afe49da6e8',

	    'DES_PP',
    'a47b1b2c90fb3b7a7367c1844d3d07e620b943fdc6728a05e5cf69afe49da6e8',

	    'IDEA',
    '58678df1889afedbd336fe64a6fb39ab08156a201f832e9a8a2fd460251ebe24',

# Twofish2 taken out for the moment, 'cause I'm not sure
# about the test data. At least on some machines the test
# script reports an error.
#	    'Twofish2',
#    '0958c674179aefaf13de8b25a613174dc40a90b80918bce55d314c86ecd3db45',
	   );

$crypt = Crypt::ECB->new;

$crypt->padding(PADDING_AUTO);

foreach $cipher (sort keys %data) {
    unless ($crypt->cipher($cipher)) {
	print "ok ".(++$test)." # skip, $cipher not installed\n";
        next;
    }

    $ks = ($crypt->{Keysize} or 8);
    $crypt->key(substr($key,0,$ks));

    $enc = $crypt->encrypt_hex($text);
    print "not " unless $enc eq $data{$cipher};
    print "ok ".(++$test)."\n";
}
