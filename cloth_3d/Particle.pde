class Particle extends VerletParticle3D {

  Particle(Vec3D loc) {
    super(loc);
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display() {
    fill(175);
    stroke(0);
    ellipse(x,y,16,16);
  }
}