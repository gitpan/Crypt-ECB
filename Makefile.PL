use ExtUtils::MakeMaker;
WriteMakefile(
	      NAME         => 'Crypt::ECB',
	      VERSION_FROM => 'ECB.pm',
	      'dist'       => {COMPRESS => 'gzip', SUFFIX => 'gz'},
);
