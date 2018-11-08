import toxi.physics3d.behaviors.*;
import toxi.physics3d.*;

import toxi.geom.*;
import toxi.math.*;

VerletPhysics3D physics;

ArrayList<Particle> particles;
ArrayList<Connection> springs;
boolean breeze = false;
GravityBehavior3D wind;

void setup() {
  size(640, 480,P3D);
  particles = new ArrayList<Particle>();
  springs = new ArrayList<Connection>();
  physics=new VerletPhysics3D();
  physics.addBehavior(new GravityBehavior3D(new Vec3D(.01, 0.1,-0.01)));
  float len = 15;
  float strength = 0.125;
  float h = 20;
  float w = 20;
  for (int y=0; y<h; y++) {
    for (int x=0; x<w; x++) {
      Particle p = new Particle(new Vec3D(x*len-w*len/2, 50+y*len,random(-len,len))); 
      physics.addParticle(p);
      particles.add(p);
      if (x > 0) {
        Particle previous = particles.get(particles.size()-2);
        Connection c = new Connection(p, previous, len, strength);
        physics.addSpring(c);
        springs.add(c);
      }

      if (y > 0) {
        Particle above = particles.get(particles.size()-(int)w-1);
        Connection c=new Connection(p, above, len, strength);
        physics.addSpring(c);
        springs.add(c);
      }
    }
  }
  Particle topleft= particles.get(0);
  topleft.lock();

  Particle topright = particles.get((int)w-1);
  topright.lock();
}

void draw() {
  background(255);
  translate(width/2,0);
  rotateY(mouseX*.01);
  //randomly add and remove wind
  if (breeze==true){
    breeze=false;
    physics.removeBehavior(wind);
  }
  if (frameCount%((int)random(10,70))==0){
    wind = new GravityBehavior3D(new Vec3D(random(.01,1),random(-.005,.005),random(-.01,.01)));
    physics.addBehavior(wind);
    breeze=true;
  }
  
  physics.update();
  for (Connection c : springs) {
    c.display();
  }
}