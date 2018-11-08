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
ArrayList<ChainLink> particles;
ArrayList<Joint> joints;
Car car;
boolean started = false;
float time=0;
boolean finished = false;
float seconds=0;

/*RULES
- give me a complete car class, i will provide template
- must set all velocities in car class to zero at start
- must follow laws of physics, i.e., cannot fly etc.
- adjust torque and other physical properties of car (within realistic limits, no extreme bounciness for example) to finish
- must finish under a minute
- car will drop in at screen location (100, 140)
*/

void setup() {
  size(1280, 480); 
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  noiseSeed(0);
  surface1 = new Surface(0, firstEnd, .01, 10, 100, height/2);
  //increase here for new levels
  float difficulty = 200;
  surface2 = new Surface(secondStart, width, .01, 2, difficulty, height/2-100);
  particles = new ArrayList<ChainLink>();
  joints = new ArrayList<Joint>();

  int bridgeDiv = 10;
  int howMany = (secondStart-firstEnd)/bridgeDiv;
  int index=0;
  for (int i = firstEnd+4; i<secondStart+4; i+=bridgeDiv) {
    if (index==0)
      particles.add(new ChainLink(i, surface1.endHeight, true, 4)); 
    else if (index==howMany-1)
      particles.add(new ChainLink(i, surface2.startHeight, true, 4));
    else
      particles.add(new ChainLink(i, height/2, false, 4)); 
    index++;
  }
  for (int i = 1; i<particles.size(); i++) {
    joints.add(new Joint(particles.get(i-1), particles.get(i)));
  }
  car = new Car(100, 140);
  box2d.listenForCollisions();
  textSize(20);
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

  if (started && !finished) {

    stroke(0);
    seconds = (millis() - time) / 1000;
    int minutes = int(seconds / 60);
    if (minutes>0) {
      text("Disqualified - over a minute", 10, 30);
      noLoop();
    } else {
      String rate = "Min: ";
      rate+=str(minutes);
      rate+="   Sec: ";
      rate+=str(seconds);
      text(rate, 10, 30);
    }
  } else if (finished) {
    int minutes = int(seconds / 60);
    String rate = "FINAL TIME- Min: ";
    rate+=str(minutes);
    rate+="   Sec: ";
    rate+=str(seconds);
    text(rate, 10, 30);
  } else {
    text("On your mark, get set...", 10, 30);
  }
  if (car.box.pos().x>width+car.box.w/2) finished=true;
}

void beginContact(Contact cp) {
  if (!started)
    time = millis();
  started=true;
}

void endContact(Contact cp) {
}