const int LAT = 10;  // Latch
const int SIN = 11;  // Serial data input (to bargraph)
const int CLK = 13;  // Clock
const int DELAY = 500;
const int swPin = 2;
const int musPin = 3;
int isRunning = false;
int toilet = 0;

void setup()
// Runs once upon reboot
{
  // Set pins to output
  pinMode( LAT, OUTPUT ); // led matrix
  pinMode( SIN, OUTPUT ); // led matrix
  pinMode( CLK, OUTPUT ); // led matrix
  pinMode( swPin, INPUT ); // ping that the switch is attached to
  pinMode( musPin, OUTPUT ); // pin that goes to the music controlling arduino
  Serial.begin( 9600 );
}

void clr() {
  // Set all the leds to 0
  Serial.print( "clearing\n" );
  int y = 31;
  for ( int x = 0; x < y; x++ ) {
    digitalWrite( LAT, LOW );
    digitalWrite( CLK, LOW );
    digitalWrite( SIN, 0 );
    digitalWrite( CLK, HIGH );
    digitalWrite( LAT, HIGH );
  }
}

void send_data( int gal, int del ) {
  if ( isRunning != true ) {
    isRunning = true; // this var makes sure we don't spin off 90329023 times
    Serial.print( "Sending info to display\n" );

	digitalWrite( musPin, HIGH ); // start the music

    for ( int x = -1; x < gal; x++ ) {
      digitalWrite( LAT, LOW );
      digitalWrite( CLK, LOW );
      digitalWrite( SIN, 1 );
      digitalWrite( CLK, HIGH );
      digitalWrite( LAT, HIGH );
      delay( DELAY );
    }
    delay( del );
    clr(); // clear the led's after we spit out the amount of stuff
    isRunning = false;
  } else {
    Serial.print( "Already running\n" );
  }
}

void flush_toilet() {
  clr();
  Serial.print( "flushing the toilet\n" );
  send_data( 7, 6000 ); // first number is # of gal, second is how long to wait for audio clip to end.
}

void loop() {  
  toilet = digitalRead( swPin );
  clr();
  delay( 10000 );
  if ( toilet == HIGH ) {
	  Serial.print( "Clicked the toilet button\n" );
	  flush_toilet();
   }
}
