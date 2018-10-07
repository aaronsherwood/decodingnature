ParticleSystem ps;
PImage tex0;

void setup() {
  fullScreen(P3D);
  tex0 = loadImage("cloud.png");
  ps = new NoDeathSystem(new PVector(width/2, 50));
  for (int i = 50; i >= 0; i--) {
    ps.origin= new PVector(random(width),random(height));
    ps.addParticle();
  }
}

void draw() {
  background(135, 206, 250);
  ps.run();
  // blendMode(BLEND);
  // fill(0,1);
  // rect(0,0,width,height);
  println(frameRate);
}