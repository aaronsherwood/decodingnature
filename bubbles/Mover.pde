class Mover extends Particle {
  float damping;
  Mover(PVector l, PImage _img) {
    super(l, _img);
    vel = new PVector(0, 0);
    damping = .98;
    mass = 1.2;
  }
  
  void run(){
   update();
   checkEdges();
  }

  void update() {
    vel.add(acc);
    pos.add(vel);
    vel.mult(damping);
    acc.mult(0); // clear Acceleration
  }

  void checkEdges() {
    if ((pos.x > width) || (pos.x < 0)) {
      vel.x = vel.x * -1;
    }
    if ((pos.y > height) || (pos.y < 0)) {
      vel.y = vel.y * -1;
    }
  }
}