PShader mShader;
float weight = 3;
float freq = .00024f;
float amp = 7.;
boolean circle = false;
int scl = 4;
int cols = 800/scl;
int rows = 800/scl;
PShape plane;
float octaves = 3;

void setup() {
  size(800, 800, P3D);
  mShader = loadShader("frag.glsl", "vert.glsl");
  mShader.set("weight", weight);
  //mShader.set("stroke", .0f,.2f,.6f);
  mShader.set("stroke", .3f,.5f,.9f);
  mShader.set("alphaScale", .75f);
  //mShader.set("extrude",true);
  strokeWeight(weight);  
  blendMode(ADD);
  plane = createShape();
  for (int y = 0; y < rows; y++) {
    plane.beginShape(LINES);
    for (int x = 0; x < cols; x++) {
      //rows
      plane.vertex(x*scl, y*scl, 0);
      plane.vertex(x*scl, (y+1)*scl, 0);
      if (x>0) {//since x-1
        //columns
        plane.vertex(x*scl, y*scl, 0);
        plane.vertex((x-1)*scl, y*scl, 0);
      }
    }
    plane.endShape();
  }
  noCursor();
}

void draw() {
  mShader.set("time", (float)millis());
  mShader.set("scale", .005 );
  mShader.set("mouse", float(mouseX), float(mouseY));
  mShader.set("frequency", freq);
  mShader.set("amplitude", amp+sin(frameCount*.01)*2);
  mShader.set("octaves", octaves);
  mShader.set("circle", circle);
  shader(mShader);
  background(0);
  pushMatrix();
  translate(5, height/3, -100);
  rotateX(PI/2.4);
  shape(plane,0,0);
  popMatrix();
}

void keyPressed() {
  if (keyCode==UP) { 
    octaves=constrain(octaves+1,0,20);
  }
  if (keyCode==DOWN)
    octaves=constrain(octaves-1,0,20);
  if (key=='1') {
    freq = .00014f;
    amp = 10.;
    circle = false;
  }
  if (key=='2') {
    freq = .00016f;
    amp = 20.;
    circle = true;
  }
}

void mousePressed(){
  mShader.set("extrude",true);
}

void mouseReleased(){
  mShader.set("extrude",false);
}