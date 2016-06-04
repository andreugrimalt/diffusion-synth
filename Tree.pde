class Tree {
  // Depth of the tree
  int i=8;
  // Matrix index
  int k=0;
  
  boolean yes=false;
  // Tree constructor
  Tree() {
    // Initialize matrix containing leaves positions
    leavesPos=new float [500][500];
  }

  // Draw the tree
  void drawBranches(float x, float y, float depth) {
    // All the branches have to be different
    float a=random(25);
    float b=random(20);
    // Base=brown, Top=green
    stroke(160-5*depth, 121+5*depth, 89-5*depth);
    // Base=thick, Top=thin
    strokeWeight(1.0/(depth+0.9));

    // Draw the branches
    line(x, y, x+a, y-b-15);
    line(x, y, x-a, y-b-15);

    // Draw the trunk
    if (depth==0) {
      line(x, y, x, (height/1.2)+50);
    }
    
    // Variables for the iteration
    float xNew1=x+a;
    float yNew1=y-b-15;
    float xNew2=x-a;
    float yNew2=y-b-15;

    // Iterate while depth<i
    if (depth<i) {

      drawBranches(xNew1, yNew1, depth+1);
      drawBranches(xNew2, yNew2, depth+1);
    }
    // Draw the leaves. More probability to have leaves on at top
    // than at the bottom
    for (int j=0;j<i;j++) {
      if (depth==j+1) {
        float r=random(1);
        if (r<0.5+(10*j/100)&&k<500) {
          fill(0, 200, 0);
          noStroke();
          ellipse(xNew1, yNew1, 2, 2);
          // Fill the matrix with the leave's position
          k++;
          leavesPos[k][0]=xNew1;
          leavesPos[k][1]=yNew1;
          // Constrain "k" for arrayIndexOutOfBounds
          k=constrain(k, 0, 480);
        }
      }
    }
  }
  
  // Detect when a particle is near a leaf
  void detectColision() {
    for (int i = 0; i < particles.size(); i++) {
      Particle particle=(Particle) particles.get(i);
      for (int k=0; k<leavesPos.length;k++) {
        float dx=leavesPos[k][0]-particle.x;
        float dy=leavesPos[k][1]-particle.y;
        float distance=sqrt(dx*dx+dy*dy);
        // If a particle is closer than 2, then draw a white ellipse
        if (distance<2) {
          fill(255);
          noStroke();
          ellipse(leavesPos[k][0], leavesPos[k][1], 2, 5);
          // yes=play the note
          yes=true;
          // Calculate the frequency from the "y" position
          float tempVol=pow(leavesPos[k][1]-50, 1.8);
          if(!Double.isNaN(tempVol)){
            dPhase2[k]=pow(leavesPos[k][1]-50, 1.8);
          }
          
          //println( dPhase2[k]);
        }
        else {
          yes=false;          
        }
      }
    }
  }
}