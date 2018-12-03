PShader mShader;

void setup() {
  size(640, 360, P2D);
  mShader = loadShader("frag.glsl");
}

void draw() {
  shader(mShader);
  fill(0,255,0);
  rect(0,0,width,height);
}