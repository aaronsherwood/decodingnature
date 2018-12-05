PShader mShader;
float weight = 7;
float freq = .0003f;
float amp = 7.;
boolean circle = false;
PVector position;

void setup() {
  size(800, 800, P3D);
  mShader = loadShader("frag_fill.glsl", "vert_fill.glsl");
  position = new PVector(width/2,height/2);
}

void draw() {
  background(0);
  
  //press mouse to deform shape
  mShader.set("mouse", float(mouseX-width/2), float(mouseY-height/2));
  mShader.set("time", (float)millis());
  mShader.set("scale", .005f );
  mShader.set("frequency", freq);
  mShader.set("deformAmount", 100.f);
  mShader.set("amplitude", 30.f);
  shader(mShader);
  pushStyle();
  noStroke();
  fill(255);
  //have it move around based on noise a little
  float locX = noise(millis()*.0001)*width;
  float locY = noise(millis()*.0003)*height;
  //subtract the current position from the mosue position to get direction towards the noise loc
  PVector noiseVelocity = new PVector(locX, locY).sub(position);
  //scale that vector down to 3%, so noise is slightly stronger than the mouse force
  noiseVelocity.mult(.03);
  //have it move slightly towards the mouse too
  //subtract the current position from the mosue position to get direction towards mouse
  PVector mouseVelocity = new PVector(mouseX, mouseY).sub(position);
  //scale that vector down to 1%
  mouseVelocity.mult(.01);
  //add these velocities to the position
  position.add(noiseVelocity);
  position.add(mouseVelocity);
  ellipse(position.x, position.y, 400, 400);
  popStyle();
}

void keyPressed() {
  if (keyCode==UP) { 
    freq+=.00001f;
  }
  if (keyCode==DOWN)
    freq-=.00001f;
}

void mousePressed() {
  mShader.set("mousePressed", true);
}

void mouseReleased() {
  mShader.set("mousePressed", false);
}