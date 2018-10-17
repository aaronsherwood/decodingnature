import processing.pdf.*;

int numMovers = 3;

Mover[] points = new Mover[numMovers];
Spring[] springs = new Spring[numMovers*2];

boolean middleAttached = false;
boolean dontComplete = false;
boolean record = false;
boolean useMouse = false;
String fileName = "circle_";

void setup() {
  size(1280, 720, P3D);
  float angle = -HALF_PI;
  float inc = TWO_PI/numMovers;
  float radius = 200;
  float len = 200;
  float noiseScale=2;
  if (record) {
    fileName+=("numMovers_");
    fileName+=str(numMovers);
    fileName+=("_radius_");
    fileName+=str(radius);
    fileName+=("_len_");
    fileName+=str(len);
    fileName+=("_noiseScale_");
    fileName+=str(noiseScale);
    fileName+=("_middleAttached_");
    fileName+=str(middleAttached);
    fileName+=("_");
    fileName+=day()+"_"+month()+"_"+year()+"_"+hour()+"_"+minute()+"_"+second();
    fileName+=".pdf";
  }
  for (int i = 0; i< numMovers; i++) {
    float x = ((noise(i*.1, i*.2)-.5)*noiseScale)+width/2+cos(angle)*radius;
    float y = ((noise(i*.1, i*.2)-.5)*noiseScale)+height/2+sin(angle)*radius;
    points[i] = new Mover(24, x, y);
    if (dontComplete) {
      if (i<numMovers-1)
        springs[i] = new Spring(points[i].position.x, points[i].position.y, len);
    } else {
      springs[i] = new Spring(points[i].position.x, points[i].position.y, len);
    }
    angle += inc;
  }
  if (!dontComplete) {
    for (int i = numMovers; i< numMovers*2; i++) {
      springs[i] = new Spring(width/2, height/2, len);
    }
  }
  if (record)
    beginRecord(PDF, fileName);
  background(255);
}

void draw() {
  //background(255);
  stroke(0, 10);

  for (int i=0; i<numMovers*2; i++) {
    if (i>numMovers) {
      if (middleAttached && !dontComplete) {
        if (useMouse)
          springs[i-1].anchor.set(mouseX, mouseY, 0);
        springs[i-1].update(points[i-numMovers]);
        //comment out these next two lines for normal usage
        springs[i-1].display(points[i-numMovers]);
        springs[i-1].restingLength = (sin(frameCount*.01+i)+10)*50;
      }
    } else if (i==numMovers) {
      if (middleAttached && !dontComplete) {
        if (useMouse)
          springs[numMovers*2-1].anchor.set(mouseX, mouseY, 0);
        springs[numMovers*2-1].update(points[0]);
        //springs[numMovers*2-1].display(points[0]);
      }
    } else if (i>0) {
      int index = i-1;
      if (dontComplete && i==1)
        index = numMovers-1;
      springs[i-1].anchor = points[index].position.copy();
      springs[i-1].update(points[i]);
      springs[i-1].display(points[i]);
      
    } else if (i==0 && !dontComplete) {
      springs[numMovers-1].anchor = points[numMovers-1].position.copy();
      springs[numMovers-1].update(points[i]);
      springs[numMovers-1].display(points[i]);
    }
    if (i<numMovers) {
      points[i].update();
      //points[i].display();
    }
  }
}

void keyPressed() {
  if (key == 'q') {
    if (record)
      endRecord();
    exit();
  }
}