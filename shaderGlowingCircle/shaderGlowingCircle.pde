PShader mShader;
Particle[] particles = new Particle[20];
Attractor a;

void setup() {
  size(1280, 720, P2D);
  mShader = loadShader("frag.glsl");
  blendMode(ADD);
  noStroke();
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle(random(2, 10), random(width), random(height), loadShader("frag.glsl"));
  }
  a = new Attractor();
}

void draw() {

  background(0);
  
  mShader.set("mouse",float(mouseX),float(height-mouseY));
  mShader.set("size", 50f);
  mShader.set("color", .6, .3, .5);
  shader(mShader);
  rect(0,0,width,height);
  
  a.position.set(mouseX, mouseY,0);
  
  for (int i = 0; i < particles.length; i++) {
    PVector force = a.attract(particles[i]);
    particles[i].applyForce(force);
    particles[i].update();
    particles[i].display();
  }
}