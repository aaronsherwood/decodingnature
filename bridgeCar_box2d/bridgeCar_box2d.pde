import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
Box2DProcessing box2d;

Surface surface1, surface2;
int firstEnd = 300;
int secondStart = 900;
ArrayList<Particle> particles;
ArrayList<Joint> joints;
Car car;


void setup() {
  size(1280, 480); 
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  surface1 = new Surface(0, firstEnd, .01, 10, 100);
  surface2 = new Surface(secondStart, width, .01, 5, 200);
  particles = new ArrayList<Particle>();
  joints = new ArrayList<Joint>();
  noiseSeed(0);
  int bridgeDiv = 10;
  int howMany = (secondStart-firstEnd)/bridgeDiv;
  int index=0;
  for (int i = firstEnd+4; i<secondStart+4; i+=bridgeDiv) {
    if (index==0)
      particles.add(new Particle(i, surface1.endHeight, true, 4)); 
    else if (index==howMany-1)
      particles.add(new Particle(i, surface2.startHeight, true, 4));
    else
      particles.add(new Particle(i, height/2, false, 4)); 
    index++;
  }
  for (int i = 1; i<particles.size(); i++) {
    joints.add(new Joint(particles.get(i-1), particles.get(i)));
  }
  car = new Car(100, 100);
}

void draw() {
  background(255);
  box2d.step();
  surface1.display();
  surface2.display();

  for (int i = 0; i<particles.size(); i++) {
    particles.get(i).display();
  }
  car.display();
}