// define function
fun void foo( string s )
{
  // infinite time loop
  while( true )
  {
	// print s
	<<< s >>>;
	// advance time
	500::ms => now;
  }
}

// spork shred, passing in "you" as argument to foo
spork ~ foo( "you" );
// advance time by 250 ms
250::ms => now;
// spork another shred
spork ~ foo( "me" );
// infinite time loop - to keep child shreds around
while( true )
1::second => now;