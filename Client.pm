#
#	Win32/DDE/Client.pm
#
#	This is the DDEML.DLL client side interface for perl.
#	Meant to smooth out the raw perl to C interface for the DDEML
#	And provide easy interfaces for the most commonly used functions.
#       
#	Author:		Doug Breshears
#	Created:	Aug 21 1995
#	Modified:	Doug Wegscheid Oct 8 1997
#		Handle the updated 32-bit XS interface			
#
package Win32::DDE::Client;
use strict;
use vars qw ( $AUTOLOAD );
use Win32::DDE;
use Win32::DDE::Callback;
use Carp;

$Win32::DDE::Client::Debug = 0;
$Win32::DDE::Client::Timeout = 1000;

sub CF_TEXT {1;};

sub AUTOLOAD {
 my $self = shift;
 my $type = ref($self) or Carp::croak "$self is not an object";
 my $name = $AUTOLOAD;
 $name =~ s/.*://; # strip fully-qualified portion

 # can't access fields that start with underscore
 if ($name =~ /^_/) {
  Carp::croak "Can't access `$name' field in class $type";
 }

 unless (exists ($self->{$name})) {
  Carp::croak "`$name' field in class $type doesn't exist";
 }

 my $old = $self->{$name};
 if (@_) {
  # to do: figure out a way to make some things readonly
  $self->{$name} = shift;
 }
 $old;
}

# new
# Constructor for the package DDEML
# Initializes the DDEML and Connects to the Server listed.
#
# new returns the self array,
# to see if there are errors do a $obj->Error, zero means no errors.

sub new {
 my($Pname, $ServName, $TopicName, $CBack) = @_;
 my $ret;

 my $proto = shift;
 my $class = ref($proto) || $proto;
 my $self = {};

 bless $self, $Pname;

 $self->{'_CallBackName'} = new Win32::DDE::Callback;
 $self->{'_Pname'} = $Pname;
 $self->{'_ServName'} = 0; 			# Handle to Server Name
 $self->{'_TopicName'} = 0; 			# Handle to Topic Name
 $self->{'_hConv'} = 0; 			# Handle to Dde Conversation
 $self->{'TimeOut'} = $Win32::DDE::Client::Timeout;	# Time out
 $self->_ClientError;

 if ($ret = Win32::DDE::DdeInitialize
  ($Win32::DDE::_DDEinst,$self->{'_CallBackName'},0,0) ) {

  $self->_ClientError($ret, "new", "DdeInitialize");
 } else {
  #Connect and get the Conversation started, etc...
  $self->_ConnectToServer($ServName, $TopicName);

  #Register this conversation with our main perl callback
  #so it can redirect any messages with this handle.
  Win32::DDE::Callback::AddItemtoCallbackList($self->{'_hConv'} , $CBack);
 }
 $self;
}

sub Poke {
 my ($self, $ItemName, $Data) = @_;
 $Data .= "\0";
 my $ret = $self->_ClientTrans($ItemName, Win32::DDE::XTYP_POKE(), $Data, length($Data));
 $ret;
}

sub Request {
 my($self, $ItemName) = @_;
 my $ret;
 my $hdata = $self->_ClientTrans($ItemName, Win32::DDE::XTYP_REQUEST(), 0, 0);
 if ($hdata) {
  my $buf;
  my $size = Win32::DDE::DdeGetData($hdata, 0, 0, 0);
  Win32::DDE::DdeGetData($hdata, $buf, $size, 0);
  $buf =~ s/\0.*$//s;
  $ret = $buf;
 } else {
  $ret = undef;
 }
 $ret;
}

sub Execute {
 my($self, $Cmd) = @_;
 $Cmd .= "\0";
 my $ret = $self->_ClientTrans(undef, Win32::DDE::XTYP_EXECUTE(),
  $Cmd, length($Cmd));
 $ret;
}

sub Disconnect {
 my ($self) = shift;
 Win32::DDE::DdeDisconnect($self->{'_hConv'}) if $self->{'_hConv'};
 $self->{'_hConv'} = undef;
 Win32::DDE::DdeFreeStringHandle($Win32::DDE::_DDEinst,$self->{'_ServName'})
  if $self->{'_ServName'};
 $self->{'_ServName'} = undef;
 Win32::DDE::DdeFreeStringHandle($Win32::DDE::_DDEinst,$self->{'_TopicName'})
  if $self->{'_TopicName'};
 $self->{'_TopicName'} = undef;
 # should do more checking here
 Win32::DDE::DdeUninitialize ($Win32::DDE::_DDEinst);
 1;
}

# bunch of untested, unsupported stuff here!

sub HotAdvise {
 my($self, $ItemName) = @_;
 my $ret = $self->_ClientTrans($ItemName, Win32::DDE::XTYP_ADVSTART(),0,0);
 $ret;
}

sub WarmAdvise {
 my($self, $ItemName) = @_;
 my $ret = $self->_ClientTrans($ItemName,
  (Win32::DDE::XTYP_ADVSTART() || Win32::DDE::XTYPF_NODATA()),0,0);
 $ret;
}

sub Unadvise
{
 my($self, $ItemName) = @_;
 my $ret = $self->_ClientTrans($ItemName, Win32::DDE::XTYP_ADVSTOP(),0,0);
 $ret;
}


###########################################################################
################# I N T E R N A L    F U N C T I O N S ####################
###########################################################################

sub _ClientTrans
{
 my($self, $ItemName, $TransType ,$Data, $Length) = @_;
 my $retval = 1;
 my $Null = 0;
 my $temp = 0;

 $self->_ClientError;

 # we have a problem if _hString returns 0
 if (defined ($ItemName)) {
  unless ($temp = $self->_hString($ItemName)) {
   $self->_ClientError("_ClientTrans", "_hString..ItemName");
   return 0;
  }
 }
  
 # we have a problem if DDEClientTransaction returns 0
 $retval = Win32::DDE::DdeClientTransaction (
  $Data, $Length, $self->{'_hConv'}, $temp, &CF_TEXT, $TransType, 
  $self->{'TimeOut'}, $Null);

 unless ($retval) {
  $self->_ClientError("_ClientTrans", "_ClientTrans");
 }

 if ($temp) {
  unless ($self->_fString($temp)) {
   $self->_ClientError("_ClientTrans", "_fString");
   $retval = 0;
  }
 }
 $retval;
}

sub _ClientError
{
 my $self = shift;

 if (@_ == 0) {
  $self->{Error} = 0;
  $self->{ErrorText} = "no error";
  return;
 }

 if (@_ == 3) {
  $self->{Error} = shift;
 } else {
  $self->{Error} = Win32::DDE::DdeGetLastError($Win32::DDE::_DDEinst);
 }
 my $errtext = Win32::DDE::ErrorText($self->{Error});

 my ($sub, $call) = @_;
 $self->{ErrorText} = "$self->{'_Pname'},$self->{Error},$errtext,$sub,$call";
}

sub _hString
{
 my($self,$string) = @_;
 my $ret = Win32::DDE::DdeCreateStringHandle($Win32::DDE::_DDEinst, $string, 0);
}

sub _fString
{
 my($self,$string) = @_;
 my $ret = Win32::DDE::DdeFreeStringHandle($Win32::DDE::_DDEinst, $string);
}

sub DESTROY {
# This sub will disconnect and unitialize the dde
 my $self = shift;

 $self->Disconnect();
 Win32::DDE::DdeUninitialize($Win32::DDE::_DDEinst);
}

sub _ConnectToServer
{	
 my($self, $ServName, $TopicName) = @_;
  
 $self->{'_ServName'} = $self->_hString($ServName);
 unless ($self->{'_ServName'}) {
  $self->_ClientError("_ConnectToServer","_hString..ServName");
  return 0;
 }
    
 $self->{'_TopicName'} = $self->_hString($TopicName);
 unless ($self->{'_TopicName'}) {
  $self->_ClientError("_ConnectToServer","_hString..TopicName");
  return 0;
 }

 $self->{'_hConv'} = Win32::DDE::DdeConnect($Win32::DDE::_DDEinst,
	$self->{'_ServName'}, $self->{'_TopicName'});
 unless ($self->{'_hConv'}) {
  $self->_ClientError("_ConnectToServer","DdeConnect..ServName..TopicName");
  return 0;
 }
  
 1;
}

1;

__END__

=head1 NAME

Win32::DDE::Client - Perl extension for Win32 DDE client

=head1 SYNOPSIS

  use Win32::DDE::Client;

  $Client = new Win32::DDE::Client ('Server', 'Topic');
  die "Unable to initiate conversation" if $Client->Error;

  defined ($hesays = $Client->Request ('ITEM1')) ||
	die "DDE request failed"; 

  $Client->Poke ('ITEM2', 'VALUE2') ||
	die "DDE poke failed";

  $Client->Execute ('COMMAND') ||
	die "DDE execute failed";

  $Client->Disconnect;

=head1 DESCRIPTION

C<Win32::DDE::Client> is a class implementing a simple DDE client in Perl.

=head1 CONSTRUCTOR

=over 4

=item new (SERVER, TOPIC)

This is the constructor for a new Win32::DDE::Client object. C<SERVER> and
C<TOPIC> are the server and topic names for the server to connect to. A server
object will be returned, regardless of the success or failure of the connect;
you will have to use the Error method to figure out if the connect succeeded or
not.

=back

=head1 METHODS

Unless otherwise stated all methods return either a I<true> or I<false>
value, with I<true> meaning that the operation was a success. When a method
states that it returns a value, failure will be returned as I<undef>.

=over 4

=item Request(ITEM)

Returns the value of ITEM from the DDE server.

=item Poke (ITEM, VALUE)

Pokes VALUE into ITEM at the DDE server.

=item Execute (CMD)

Executes CMD at the DDE server.

=item Disconnect

Disconnects from the DDE server. This will get done when the object is
DESTROYed, but you can make it happen sooner by invoking it explicitly.

=item Error

Returns the error code from the last DDE operation that took place (the connect
that took place in the constructor, a Request, Poke, or Execute). Error codes
can be checked using the Win32::DDE::DMLERR* functions (DMLERR_NO_ERROR,
DMLERR_NO_CONV_ESTABLISHED, and DMLERR_NOTPROCESSED are particularly popular).

See the ErrorText function in L<Win32::DDE> for a way to make these useful.

=item ErrorMessage

Returns a somewhat cryptic error message from the last DDE operation that took
place (the connect that took place in the constructor, a Request, Poke, or
Execute).

This method will give a little more detail than a 
Win32::DDE::ErrorMessage($Client->Error).

=item Timeout ([NEWVALUE])

If NEWVALUE is present, set the timeout value (in milliseconds) used for 
DDE operations; return the old value.

The timeout value is initially set to $Win32::DDE::Client::Timeout when the
object is constructed. $Win32::DDE::Client::Timeout is set to 1000 when the 
module is loaded.

=back

=head1 AUTHORS

Doug Breshears
Gurusamy Sarathy, gsar@umich.edu
current maintainer, Doug Wegscheid, wegscd@whirlpool.com

=head1 SEE ALSO

L<Win32::DDE>

=cut
