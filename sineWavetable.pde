class SineWavetable{
  // Wave table constructor. It fills an array
  // of length= sample rate with a sine function.
  SineWavetable(){
    for(int i=0; i<N; i++){
      sine[i]=sin(2*PI*(float)i/(float)N);
    }
  }
}
