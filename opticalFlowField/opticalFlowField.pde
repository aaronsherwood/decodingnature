import processing.video.*;
import gab.opencv.*;
Capture cam;
OpenCV opencv;
PImage video;
Mover[] movers = new Mover[100];

void setup() {
  size(640, 480, P2D);
  cam = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  cam.start();
  video = new PImage(640, 480);
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(.1, 3), random(width), random(height));
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    video=cam.copy();
  }
  opencv.loadImage(video);
  opencv.calculateOpticalFlow();
  image(video, 0, 0);
  for (int i = 0; i < movers.length; i++) {
    PVector force = new PVector(0.1, .1);
    if (frameCount>2) {
      //force= opencv.getAverageFlowInRegion(constrain((int)movers[i].position.x,0,640-21),constrain((int)movers[i].position.y,0,480-21),20,20);
      force= opencv.getFlowAt((int)constrain(movers[i].position.x, 0, opencv.flow.width()-1), (int)constrain(movers[i].position.y, 0, opencv.flow.height()-1));
      movers[i].applyForce(force);
    }

    movers[i].update();
    movers[i].display();
  }
}