// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Mover {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;

  float angle = 0;
  float aVelocity = 0;
  float aAcceleration = 0;

  Mover(float m, float x, float y) {
    mass = m;
    position = new PVector(x,y);
    velocity = new PVector(random(-1,1),random(-1,1));
    acceleration = new PVector(0,0);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }

  void update() {
    borders();
    velocity.add(acceleration);
    position.add(velocity);

    aAcceleration = acceleration.x;// / 5.0;
    aVelocity += aAcceleration;
    aVelocity = constrain(aVelocity,-0.1,0.1);
    angle += aVelocity;

    acceleration.mult(0);
    velocity.mult(.9);
  }

  void display() {
    noStroke();
    fill(255,100);
    rectMode(CENTER);
    pushMatrix();
    translate(position.x,position.y);
    rotate(angle);
    rect(0,0,mass*16,mass*16,5,5,5,5);
    popMatrix();
  }
  
  void borders(){
    if (position.y<0 || position.y>height)
      velocity.y*=-1;
    if (position.x<0 || position.x>width)
      velocity.x*=-1;
  }

}