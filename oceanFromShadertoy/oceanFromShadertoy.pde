/*
from https://www.shadertoy.com/view/Ms2SD1
*/
 
PShader ocean;

void setup() {
  size(640, 360, P2D);
  noStroke();
  ocean = loadShader("ocean.glsl");
  ocean.set("resolution", float(width), float(height));
}

void draw() {
  ocean.set("time", millis() / 500.0); 
  shader(ocean); 
  rect(0, 0, width, height);
}