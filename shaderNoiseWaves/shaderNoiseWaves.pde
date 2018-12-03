PShader noise;
PShader extrude;
PGraphics pg;
boolean showMesh=false;
boolean showTex=true;

void setup() {
  size(800, 800, P3D);
  noise = loadShader("frag.glsl");
  extrude = loadShader("extrudeFrag.glsl", "extrudeVert.glsl");
  pg = createGraphics(800, 800, P3D);
  createPlane();
  extrude.set("resolution", float(pg.width), float(pg.height));
}

void draw() {
  background(255);
  float d=map(mouseX, 0, width, 600, 1);
  float power=map(mouseY, 0, height, 0, 5);
  noise.set("d", d);
  noise.set("power", power);
  noise.set("time", float(millis())*0);//.5f);
  pg.beginDraw();
  pg.shader(noise);
  pg.rect(0, 0, width, height);
  pg.endDraw();
  if (showTex)
    image(pg,0,0);
  if (showMesh) {
    extrude.set("tex0", pg);
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