use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::DDE',
    'VERSION_FROM' => 'DDE.pm',
    'PM'	=> {
	'DDE.pm' => '$(INST_LIBDIR)/DDE.pm',
	'Client.pm' => '$(INST_LIBDIR)/DDE/Client.pm',
	'Callback.pm' => '$(INST_LIBDIR)/DDE/Callback.pm',
    },
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
);
