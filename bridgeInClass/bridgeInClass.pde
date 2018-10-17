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

ArrayList<Particle> particles;
ArrayList<Joint> joints;

void setup(){
  size(640, 480);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  particles = new ArrayList<Particle>();
  joints = new ArrayList<Joint>();
  
  int index=0;
  for (int i =4; i<width; i+=10){
    boolean locked = false;
    if (index==0 || index>=63)
      locked=true;
    particles.add(new Particle(i,height/2,locked));
    index++;
  }
  
  for (int i=1;i<particles.size();i++){
     joints.add(new Joint(particles.get(i), particles.get(i-1)));
  }
}


void draw(){
  background(255);
  box2d.step();
  for (int i=0;i<particles.size();i++){
   particles.get(i).display(); 
  }
}