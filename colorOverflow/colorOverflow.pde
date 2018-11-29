int r = -1000;

void setup() {}

void draw() {
  int rr = bounce(r);
  fill(rr,0, 0);
  rect(20, 20, 60, 60);
  r++;
  println(rr+" "+r);
}

//*WRAP*
//Values that exceed the limits are wrapped around 
//to the opposite limit with a modulo operation. 
//(256 wraps to 0, 257 wraps to 1, 
//and -1 wraps to 255, -2 wraps to 254, etc.) 
int wrap(int v) {
  if(v>255)
  v=v%255;
  else if (v<255)
  v= (v%255)+255;
  return v;
}

//*BOUNCE*
//Values that exceed the limits are folded back 
//in the opposite direction. 
//(256 is folded back to 254, 
//257 is folded back to 253, 
//and -1 is folded back to 1, -2 to 2, etc.
int bounce(int v) {
  //your solution
  //if (v>255) v = 255-(v%255);
  //else if (v<0) v = abs(v%255);
  
  //my solution
  if (v>255) v+=2*(255-v);
  if (v<0) v-=v*2;
  if (v<0 || v>255)
    v=bounce(v);
  return v;
}