
package Win32::DDE::Callback;

@EXPORT = qw(AddItemtoCallbackList);

#
# MainDdeCallback
# 
# Subroutine that gets called from the ddecall.c
# This was registered with the ddecall.c in the call to DdeInitialize.
#
# All this does is route the messages to the appropriate outside callback
# that was registerd with the sub AddItemtoCallbackList in the constructor
# once the handle to the conversation was obtained.
#
# It looks up the proper callback to use with the sub GetItemFromCallbackList
# and calls the sub.
#
# This may seem confusing because this does not receive the $self array
# which means this sub in "instance-less" because it must recieve
# callbacks for all instances of the DDEML.
#
# This could be moved up into the "C" code and register things there, but I 
# decided it was just as easy here and maybe more flexible. At least to see 
# what works best before hard coded.
#
#
#

$ItemCallBackList = {};

sub new
{
 my $Pname = shift;
 return ("$Pname\::MainDdeCallback");
}


sub MainDdeCallback
{
 my($type, $fmt, $hconv, $hsz1, $hsz2, $hdata, $dwdata1, $dwdata2) = @_;
 my $Return = 0;

 # print "Got a Callback\n";
 $runsub = &GetItemFromCallbackList($hconv);
 &$runsub($type, $fmt, $hconv, $hsz1, $hsz2, $hdata, $dwdata1, $dwdata2);
 # print "Runsub = $runsub, Hconv = $hconv, tada = $ItemCallbackList->{$hconv}\n";
 &main::TestCB($type, $fmt, $hconv, $hsz1, $hsz2, $hdata, $dwdata1, $dwdata2);
 # print "Sub ran\n";

 return 0;
}

sub AddItemtoCallbackList
{
 my($Item, $CallbackFunc) = @_;
 $ItemCallbackList->{$Item} = $CallbackFunc;
# print "Adding Conversation!, HCONV = $Item, FUNC = $CallbackFunc\n";
# print "From list func = $ItemCallbackList->{$Item}\n";
}

sub GetItemFromCallbackList
{
 my $Item = shift;
 return($ItemCallbackList->{$Item});
}

1;

__END__

=head1 NAME

Win32::DDE::Callback - Perl extension for Win32 DDE callback

=head1 SYNOPSIS

ha!

=head1 TO DO

Test, debug, document; this hasn't been touched since the original version, and
doesn't seem to be used by Win32::DDE::Client, so no rush :)

=head1 AUTHOR

Doug Brashears

=head1 SEE ALSO

Win32::DDE
Win32::DDE::Client

=cut
