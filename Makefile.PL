use ExtUtils::MakeMaker;
WriteMakefile(
	      NAME         => 'Crypt::ECB',
	      VERSION_FROM => 'ECB.pm',
	      'linkext'    => {LINKTYPE => ''},
	      'dist'       => {COMPRESS => 'gzip', SUFFIX => 'gz'},
);
