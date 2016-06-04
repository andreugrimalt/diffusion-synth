import java.util.Random.*;

// Tree image
PImage pg;

//Tree object
Tree tree;

// Matrix with the position of the leaves
float[][] leavesPos;

// AudioThread
AudioThread audioThread;
//Sine wave table
SineWavetable sineWave;

// Variables for the group velocity of the particles system
float randomDirectionX, randomDirectionY;

// Variables for the timer
float timeElapsed, startTime;
boolean bang=false;

// Arraylist containing the particles
ArrayList particles;

// Array containing particles' frequencies
float [] dPhase;
float [] phase;
// Array containing leaves' frequencies
float [] phase2;
float [] dPhase2;
//// Array containing volumes
float [] volLeave;
float [] volParticle;

// Sample rate
int N=44100;

// Array containing the sine wave table
float [] sine;

void setup() {
  frameRate(300);
  size(622, 350);
  smooth();

  // Initialize tree
  tree = new Tree();

  // Draw a tree and make a screen capture
  tree.drawBranches(width/2, height/1.2, 0);
  saveFrame();
  // Load the screen capture
  pg=loadImage("screen-0000.tif");

  // Initialize arrays
  particles=new ArrayList();
  phase=new float[500];
  phase2=new float[500];
  dPhase=new float[500];
  dPhase2=new float[500];
  volParticle=new float[500];
  volLeave=new float[500];

  // Set the group velocity of the particles system
  randomDirectionX=random(0, 0);
  randomDirectionY=random(0.1, 0.2);


  // Create the AudioThread object, which will connect to the audio 
  // interface and get it ready to use
  audioThread = new AudioThread();
  // Start the audioThread, which will cause it to continually call 'getAudioOut' (see below)
  audioThread.start();
  // Initialize audio arrays
  sine=new float[N];
  sineWave= new SineWavetable();
  
  // Add particles to the system
  for(int i=0; i<20; i++){
    particles.add(new Particle(width/2,height/1.5));
  }
}

void draw() {
  background(50,50,255);

  // Display the tree image
  image(pg, 0, 0);

  // Call a method that detects colisions between
  // particles and leaves
  tree.detectColision();

  // Particles can be added with the mouse
  if (mousePressed) {

    for (int i=0; i<2; i++) {
      particles.add(new Particle(mouseX, mouseY));
    }
  }

  // Call the methods of the Particle class
  for (int i=0; i<particles.size(); i++) {
    Particle particle=(Particle) particles.get(i);
    particle.moveParticle();
    particle.linkParticles();
    particle.bounce();
    particle.Alive();
  }

  // Check if the particle has colide, if so, then
  // remove it from the arrayList
  for (int j=particles.size()-1; j>=0; j--) {
    Particle particle=(Particle) particles.get(j);
    if (!particle.alive) {
      particles.remove(j);
    }
    //println(particles.size());
  }

  // Each particle horitzontal position is a frequency
  // and the distance between them is the volume
  for (int j=0; j<particles.size(); j++) {
    Particle particle=(Particle) particles.get(j);
    dPhase[j]=(particle.x)+220;
    volParticle[j]=(particle.volumeD)/10;
  }
}

// This function gets called when you press the escape key in the sketch
void stop() {
  // Tell the audio to stop
  audioThread.quit();
  // Call the version of stop defined in our parent class, in case it does anything vital
  super.stop();
}

// This gets called by the audio thread when it wants some audio
// we should fill the sent buffer with the audio we want to send to the 
// audio output
void generateAudioOut(float[] buffer) {

  // Fill the buffer with the sine values and the 
  // correspondent frequencies.
  for (int i=0; i<buffer.length; i++) {
    for (int j=0;j<particles.size(); j++) {
      buffer[i]*=0.99;
      Particle particle=(Particle) particles.get(j);

      buffer[i]+= (volParticle[j]*sine[(int)phase[j]])+(volLeave[j]*sine[(int)phase2[j]]);

      // Volume envelope for the leaves
      volLeave[j]*=0.999;
      /*if (volLeave[j]<0.0001) {
        volLeave[j]=0;
      }*/
      //println(buffer[i]);
      // If a leave detects a colision, then the 
      // volume is 0.01
      if (tree.yes) {
        volLeave[j]=0.1;
      }
      // This calculates the phases in terms of the frequencies
      phase[j] = (phase[j] + dPhase[j]) % sine.length;
      phase2[j] = (phase2[j] + dPhase2[j]) % sine.length;
      println(phase2[j]);
    }
    // Reduce the main volume for avoiding distorsion
    buffer[i] *=0.8;

    
    
  }
}