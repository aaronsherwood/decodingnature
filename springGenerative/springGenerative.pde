int numMovers = 60;

Mover[] points = new Mover[numMovers];
Spring[] springs = new Spring[numMovers];

void setup() {
  size(640, 480);
  float angle = 0;
  float inc = TWO_PI/numMovers;
  float radius = 200;
  float len = 50;
  for (int i = 0; i< numMovers; i++) {
    float x = width/2+cos(angle)*radius;
    float y = height/2+sin(angle)*radius;
    points[i] = new Mover(24, x, y);
    if (i>0) {
      springs[i-1] = new Spring(points[i-1].position.x, points[i-1].position.y, len);
    }
    angle += inc;
  }


  background(255);
}

void draw() {

  //spring.anchor.set(mouseX, mouseY,0);
  //spring.update(bob);
  //spring.display(bob);

  PVector gravity = new PVector(0, 4);
 
  for (int i=0;i<numMovers;i++) {
    //springs[i];
    if (i>1)
      springs[i].display(points[i-1]);
    points[i].display();
    i++;
  }
}