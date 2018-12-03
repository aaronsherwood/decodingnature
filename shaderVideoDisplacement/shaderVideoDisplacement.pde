import processing.video.*;
Capture cam;
PShader extrude;
boolean showMesh=true;
boolean showTex=false;

void setup() {
  size(1280, 720, P3D);
  cam = new Capture(this, 1280, 720);
  extrude = loadShader("extrudeFrag.glsl", "extrudeVert.glsl");
  createPlane();
  extrude.set("resolution", float(width), float(height));
  blendMode(ADD);
  cam.start();
}

void draw() {
  background(0);
  if (cam.available() == true) {
    cam.read();
  }
  if (showTex)
    image(cam,0,0);
  if (showMesh) {
    extrude.set("tex0", cam);
    extrude.set("time", float(millis())*.001f);
    shader(extrude);
    drawPlane();
  }
}

void keyPressed() {
  if (key==' '){
    showMesh=!showMesh;
    showTex=!showTex;
  }
}