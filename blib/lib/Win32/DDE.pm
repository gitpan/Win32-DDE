package Win32::DDE;

use strict;
use Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $AUTOLOAD);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);
@EXPORT = qw(
	DMLERR_ADVACKTIMEOUT
	DMLERR_BUSY
	DMLERR_DATAACKTIMEOUT
	DMLERR_DLL_NOT_INITIALIZED
	DMLERR_DLL_USAGE
	DMLERR_EXECACKTIMEOUT
	DMLERR_INVALIDPARAMETER
	DMLERR_LOW_MEMORY
	DMLERR_MEMORY_ERROR
	DMLERR_NOTPROCESSED
	DMLERR_NO_CONV_ESTABLISHED
	DMLERR_NO_ERROR
	DMLERR_POKEACKTIMEOUT
	DMLERR_POSTMSG_FAILED
	DMLERR_REENTRANCY
	DMLERR_SERVER_DIED
	DMLERR_SYS_ERROR
	DMLERR_UNADVACKTIMEOUT
	DMLERR_UNFOUND_QUEUE_ID
);
#	DMLERR_FIRST
#	DMLERR_LAST

$VERSION = '0.02';
$Win32::DDE::_DDEinst = undef;

sub AUTOLOAD {
 # This AUTOLOAD is used to 'autoload' constants from the constant()
 # XS function.  If a constant is not found then control is passed
 # to the AUTOLOAD in AutoLoader.

 my $constname;
 ($constname = $AUTOLOAD) =~ s/.*:://;
 my $val = constant($constname, @_ ? $_[0] : 0);
 if ($! != 0) {
  if ($! =~ /Invalid/) {
   $AutoLoader::AUTOLOAD = $AUTOLOAD;
   goto &AutoLoader::AUTOLOAD;
  }
  else {
   Carp::croak "Your vendor has not defined Win32::DDE macro $constname";
  }
 }
 eval "sub $AUTOLOAD { $val }";
 goto &$AUTOLOAD;
}


sub _LoadErrorTextHash {
 return if defined $Win32::DDE::_ErrorHash;
 my $eval;
 $Win32::DDE::_ErrorHash = {};
 foreach ( grep ( /^DMLERR_/, keys %Win32::DDE:: ) ) {
  next if /DMLERR_FIRST|DMLERR_LAST/;
  $eval .= "\$Win32::DDE::_ErrorHash->{Win32::DDE::$_()} = '$_';\n";
 }
 eval $eval; die "Win32::DDE couldn't load the error hash\n$@" if $@;
}

sub ErrorText {
 # could really really really get clever, do a bootstrap, then go through
 # the symbol table, look for everything that matches /^DMLERR_/, and add
 # it to the hash.
 Win32::DDE::_LoadErrorTextHash();
 my ($c) = shift;
 my ($r) = $Win32::DDE::_ErrorHash->{$c};
 $r = "Unknown DDE error ($c)" unless defined($r);
 $r;
}

sub Debug {
 my $old = Win32::DDE::dde_get_debug();
 if (@_) {
  Win32::DDE::dde_set_debug(shift);
 }
 $old;
}

bootstrap Win32::DDE $VERSION;

__END__

=head1 NAME

Win32::DDE - Perl extension for Win32 DDE

=head1 SYNOPSIS

  use Win32::DDE;

  if ($Client->Error == Win32::DDE::DMLERR_NO_CONV_ESTABLISHED) {
   die "Hey! start the silly DDE server!";
  }
  print Win32::DDE::ErrorText ($Client->Error);

=head1 OVERVIEW

This module is mostly the interface to the .xs that actually does the
low level interface to the DDEML, and the namespace to look up the DDEML
XTYP_* and DMLERR_* constants. It's mostly useless by itself.

The only added value here is the Win32::DDE::ErrorText function.

See L<Win32::DDE::Client> for the useful stuff.

=head1 FUNCTIONS

=over 4

=item ErrorText (CODE)

Return the printable name of a DDEML error code (i.e. 'DMLERR_FOOBAR').

=back

=head1 AUTHOR

Doug Wegscheid, wegscd@whirlpool.com

=head1 SEE ALSO

L<Win32::DDE::Client>

=cut
