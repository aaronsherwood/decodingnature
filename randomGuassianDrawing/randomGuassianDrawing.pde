color c = color(250, 70, 10, 150);

void setup() {
  size(1280, 720);
  background(255);
}

void draw() {
  if (mousePressed) {
    float xGaussian = randomGaussian();
    float yGaussian = randomGaussian();
    float x = mouseX+xGaussian*10;
    float y = mouseY+yGaussian*10;
    noStroke();
    fill(c);
    float r = (1-(abs(mouseX-x)/10))*20+(1-(abs(mouseY-y)/10))*20;

    ellipse(x, y, r, r);
  }
}

void mouseReleased() {
  c=color(random(255), random(255), random(255), 150);
}

void keyPressed() {
  if (key==' ')
    background(255);
}