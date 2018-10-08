int numMovers = 11;

Mover[] points = new Mover[numMovers];
Spring[] springs = new Spring[numMovers];

void setup() {
  size(640, 480);
  float angle = -HALF_PI;
  float inc = TWO_PI/numMovers;
  float radius = 5;
  float len = 100;
  for (int i = 0; i< numMovers; i++) {
    float x = width/2+cos(angle)*radius;
    float y = height/2+sin(angle)*radius;
    points[i] = new Mover(24, x, y);
    springs[i] = new Spring(points[i].position.x, points[i].position.y, len);
    angle += inc;
  }

  background(255);
}

void draw() {
  //background(255);
  stroke(0,10);

  for (int i=0; i<numMovers; i++) {
    if (i>0) {
      springs[i-1].anchor = points[i-1].position.copy();
      springs[i-1].update(points[i]);
      springs[i-1].display(points[i]);
    } else if (i==0) {
      springs[numMovers-1].anchor = points[numMovers-1].position.copy();
      springs[numMovers-1].update(points[i]);
      springs[numMovers-1].display(points[i]);

    }
    points[i].update();
    //points[i].display();
  }
}