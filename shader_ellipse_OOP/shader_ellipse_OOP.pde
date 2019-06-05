ShadedCircle circles[];
float g = 1;

void setup() {
  fullScreen(P3D);
  circles = new ShadedCircle[50];

  for (int i=0; i<circles.length; i++) {
    float x = random(width);
    float y = random(height);
    circles[i] = new ShadedCircle(x, y, random(10, 100),i);
  }

}

void draw() {
  background(0);
  for (int i=0; i<circles.length; i++) {
    
    //separate the circles from each other
    for (int j = 0; j < circles.length; j++) {
      if (i != j) {
        PVector force = circles[j].separate(circles[i]);
        circles[i].applyForce(force);
      }
    }
    
    //run everything
    circles[i].run();
  }
}