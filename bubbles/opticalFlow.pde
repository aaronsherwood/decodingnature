import gab.opencv.*;
import processing.video.*;

OpenCV opencv;
Capture video;

PVector smoothedFlow;

void ofSetup() {
  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
  video.start(); 
  smoothedFlow = new PVector(0, 0);
}

void flow(){
  if (video.available() == true) {
    video.read();
  }
  opencv.loadImage(video);
  opencv.flip(opencv.HORIZONTAL);
  opencv.calculateOpticalFlow();

  //pushStyle();
  //fill(255);
  //pushMatrix();
  //scale(-1.0, 1.0);
  //image(video, -video.width, 0);
  //popMatrix();
  //popStyle();

  //image(video, 0, 0);
  //stroke(255, 0, 0);
  //opencv.drawOpticalFlow();

  PVector aveFlow = opencv.getAverageFlow();
  PVector diff = PVector.sub(aveFlow, smoothedFlow);
  smoothedFlow.add( diff.mult(.1));

  //stroke(255);
  //strokeWeight(2);
  //translate(width/2, height/2);
  //line(0, 0, 50*smoothedFlow.x, 50*smoothedFlow.y);
}