# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..13\n"; }
END {print "not ok 1\n" unless $loaded;}
use Win32::DDE::Client;
$loaded = 1;
print "ok 1\n";

sub skip {
 map { print "ok $_ (skipped)\n" } @_;
}

sub ok {
 my ($n, $result, @info) = @_;
 if ($result) {
  print "ok $n\n";
 } else {
  print "not ok $n\n";
  print "# @info\n" if @info;
 }
}

# is there a clever way builtin to the test stuff to say verbose or not?
# Win32::DDE::Debug(1);

($server, $good_topic, $good_item) = ('Server', 'FILE1', 'ITEM1');
$bad_item = 'BADBADBAD';
$bad_topic = 'FILE2';	# if a second server is running, test 4 will flunk

# uncomment this to deliberately flunk tests 8 and 10
# $bad_item = 'ITEM2';

print "# ", Win32::DDE::Dde_XS_rcs_string(), "\n";
print "# ", Win32::DDE::Dde_XS_compile_date(), "\n";

# can we find an error constant?
ok 2, Win32::DDE::DMLERR_NO_CONV_ESTABLISHED(),
 'DMLERR_NO_CONV_ESTABLISHED not defined or false';

# can we find an error message?
ok 3, ($i = Win32::DDE::ErrorText(Win32::DDE::DMLERR_NO_CONV_ESTABLISHED()))
  eq 'DMLERR_NO_CONV_ESTABLISHED',
 'ErrorText didn\'t return the correct error message, got $i';

# we get the right thing if we try to begin an invalid conversation?
# this test will flunk if you have a second server running (the connect
# will succeed)
$Client = new Win32::DDE::Client ($server, $bad_topic);
ok 4, $Client->Error == Win32::DDE::DMLERR_NO_CONV_ESTABLISHED,
 'Initiating a conversation to an invalid server returned ',
 Win32::DDE::ErrorText($Client->Error), "\n# ", $Client->ErrorText;

# can we begin a conversation
$Client = new Win32::DDE::Client ($server, $good_topic);
ok 5, !$Client->Error,
 'Unable to begin conversation', $Client->ErrorText;

unless ($Client->Error) {

 # can we request data
 $hesays = $Client -> Request ($good_item);
 ok 6, defined($hesays),
  'Unable to request valid information ', $Client->ErrorText;

 $hesays =~ s/\r/\\r/mg;
 $hesays =~ s/\n/\\n/mg;
 print "# got requested data '$hesays'\n";

 # can we put it back?
 ok 7, $Client->Poke ($good_item, ++$hesays),
  'Unable to poke valid information', $Client->ErrorText;

 # can we request invalid data
 $hesays = $Client -> Request ($bad_item);
 ok 8, !defined($hesays),
  'It let me request invalid information';

 # do we get a correct code?
 ok 9, $Client->Error == Win32::DDE::DMLERR_NOTPROCESSED,
  'An invalid request returned the wrong error code', $Client -> ErrorText;

 # can we put invalid data
 ok 10, !$Client -> Poke ($bad_item, 'BADVALUE'),
  'It let me poke invalid information';

 # do we get a correct code?
 ok 11, $Client -> Error == Win32::DDE::DMLERR_NOTPROCESSED,
  'An invalid poke returned the wrong error code', $Client -> ErrorText;

 # can we do an execute?
 ok 12, $Client -> Execute ('COMMAND'),
  'Unable to do an Execute', $Client->ErrorText;

 # can we disconnect?
 ok 13, $Client -> Disconnect,
  'Can\'t disconnect';

} else {
 skip 6..13;
}
