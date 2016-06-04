import java.util.Random;
class Particle {
  // Is the particle in the arrayList?
  boolean alive=true;
  // Position, "x" and "y" speed, horitzontal and vertical gauss variance
  // (in case a non isotropic diffusion)
  float x, y, brX, brY, sigmaX, sigmaY;
  // Java Random
  Random r=new Random();
  // Variables for the timer
  int startTime;
  float timeElapsed;
  // Variables for loosing energy when bouncing 
  // on a window edge
  float bounceX=1;
  float bounceY=1;
  // Distance
  float distance1=0;
  // Volume
  float volumeD;
  // Particle constructor. Initial position and gauss variance
  Particle(float xPos, float yPos) {
    startTime=millis();
    x=xPos;
    y=yPos;
    sigmaX=2;
    sigmaY=2;
  }

  //Move the particle
  void moveParticle() {

    // Change the velocity every 1 millisecond
    if (timer(1)) {
      brX=gaussianRand(sigmaX, bounceX*randomDirectionX);
      brY=gaussianRand(sigmaY, -bounceY*randomDirectionY);
      // Constrain just in case positions are higher than
      // the window 
      x=constrain(x, 0, width);
      y=constrain(y, 0, height);
    }
    // Move the particle
    x+=brX;
    y+=brY;
  }

  // Add particles to the arrayList
  void createParticle() {
    particles.add(new Particle(width/2, height/1.4));
  }

  // Draw the particle (actually only the links
  // are drawn, this is for economising power)
  void linkParticles() {

    

    for (int i=0; i< particles.size(); i++) {
      Particle particle=(Particle) particles.get(i);
      // Calculate the distance between particles
      float dx=x-particle.x;
      float dy=y-particle.y;
      float distance=sqrt(dx*dx+dy*dy);
      stroke(255, 255, 0,255*(1/distance));
      strokeWeight(1);
      // If smaller than 80 and higher than 1.
      // The "higher than 1" is for not considering
      // the distance to myself (particle to the same particle)
      // because that distance is always <80.
      if (distance<80&&distance>1) {
        // Draw the links
        line(x, y, particle.x, particle.y);
        // Calculate the volume for each particle.
        
        distance1=pow(2, -distance/5);
        // Interpolate between values for avoiding clicks
        if (volumeD < distance1) {
          volumeD+= 0.00001;
        }
        if (volumeD > distance1) {
          volumeD*= 0.9;
        }
      }
    }
  }

  // Bounce on the walls and loose energy when doing so
  void bounce() {
    if (x<=0||x>=width) {
      brX*=-1;

      bounceX*=-0.5;
    }
    if (y<=0||y>=height) {
      brY*=-1;

      bounceY*=-0.5;
    }
  }

  // Calculate a gaussian random
  float gaussianRand(float variance, float mean) {
    float value=variance*((float)r.nextGaussian())+mean;
    return value;
  }

  // Timer function
  boolean timer(float dt) {
    timeElapsed=millis()-startTime;
    boolean bang=false;

    if (timeElapsed>dt) {
      bang=true;
      startTime=millis();
    }
    else {
      bang=false;
    }
    return bang;
  }

  // Remove the particle if it's closer that 0.5 to a leave
  void Alive() {

    for (int k=0; k<leavesPos.length;k++) {
      float dx=leavesPos[k][0]-x;
      float dy=leavesPos[k][1]-y;
      float distance=sqrt(dx*dx+dy*dy);
      if (distance<0.5) {
        alive=false;
        //println(particles.size());
      }
    }
  }
}