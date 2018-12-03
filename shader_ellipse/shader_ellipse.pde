PShader mShader;
float weight = 7;
float freq = .0003f;
float amp = 7.;
boolean circle = false;

void setup() {
  size(800, 800, P3D);
  mShader = loadShader("frag.glsl", "vert.glsl");
  mShader.set("weight", weight);
  mShader.set("stroke", 1., .64, .3);
  mShader.set("alphaScale", 1.f);
  strokeWeight(weight); 
  stroke(255);
  blendMode(ADD);
}

void draw() {
  mShader.set("time", (float)millis());
  mShader.set("scale", map(mouseY, 0, height, 0, .01) );
  mShader.set("mouse", float(mouseX-width/2), float(mouseY-height/2));
  mShader.set("frequency", freq);
  mShader.set("deformAmount", 100.f);
  mShader.set("amplitude", map(mouseX, 0, width, 0, 50));
  mShader.set("circle", circle);
  shader(mShader);
  background(0);
  noFill();
  ellipse(width/2, height/2, 400, 400);
  ellipse(width/2, height/2, 400, 395);
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