// The Nature of Code
class Particle {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  PShader mShader;

  Particle(float m, float x, float y, PShader s) {
    mass = m;
    position = new PVector(x, y);
    velocity = new PVector(1, random(-10, 10));
    acceleration = new PVector(0, 0);
    mShader = s;
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
    velocity.mult(.98);
    checkBounds();
  }

  void display() {
    mShader.set("size", mass);
    mShader.set("mouse", position.x, height-position.y);
    mShader.set("color", .3f, .5f, .9f);
    shader(mShader);
    rect(0, 0, width, height);
  }

  void checkBounds() {
    if (position.x<0 ||  position.x>width)velocity.x*=-1;
    if (position.y<0 ||  position.y>height)velocity.y*=-1;
  }
}