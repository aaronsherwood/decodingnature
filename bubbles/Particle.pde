// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  float lifespan;
  PImage img;
  float size;
  float mass;

  Particle(PVector l,PImage img_) {
    acc = new PVector(0,0);
    float vx = randomGaussian()*0.3;
    float vy = randomGaussian() - 1.0;
    vel = new PVector(vx,vy);
    pos = l.get();
    lifespan = 255.0;
    img = img_;
    size = random(10,70);
    mass = 1;
  }

  void run() {
    update();
    render();
  }
  
  // Method to apply a force vector to the Particle object
  // Note we are ignoring "mass" here
  void applyForce(PVector f) {
    PVector force = f.copy();
    acc.add(f.div(mass));
  }  

  // Method to update position
  void update() {
    vel.add(acc);
    pos.add(vel);
    lifespan -= 2;
    acc.mult(0); // clear Acceleration
  }

  // Method to display
  void render() {
    imageMode(CENTER);
    tint(255,lifespan);
    image(img,pos.x,pos.y, size, size);
    // Drawing a circle instead
    // fill(255,lifespan);
    // noStroke();
    // ellipse(pos.x,pos.y,img.width,img.height);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}