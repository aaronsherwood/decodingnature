Mover[] movers = new Mover[10000];
PVector center;
float inc;
PImage img;

void setup() {
  fullScreen(P2D);
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(.3, width/2+random(-10,10), random(height));
  }
  center = new PVector(width/2, height/2);
  inc = TWO_PI/float(movers.length);
  img = loadImage("particle.png");
  imageMode(CENTER);
  //blendMode(ADD);
}

void draw() {
  background(255);
  center.set(mouseX,mouseY,0);
  for (int i = 0; i < movers.length; i++) {
    movers[i].update();
    movers[i].display();
  }
}

void keyPressed() {

  for (Mover m : movers) {
    if (key == '1') m.freqX--;
    if (key == '2') m.freqX++;
    m.freqX = max(m.freqX, 1);

    if (key == '3') m.freqY--;
    if (key == '4') m.freqY++;
    m.freqY = max(m.freqY, 1);

    if (keyCode == LEFT) m.phi -= 15;
    if (keyCode == RIGHT) m.phi += 15;

    if (key == '7') m.modFreqX--;
    if (key == '8') m.modFreqX++;
    m.modFreqX = max(m.modFreqX, 1);

    if (key == '9') m.modFreqY--;
    if (key == '0') m.modFreqY++;
    m.modFreqY = max(m.modFreqY, 1);
  }
  println("freqX: " + movers[0].freqX + ", freqY: " + movers[0].freqY + ", phi: " + movers[0].phi + ", modFreqX: " + movers[0].modFreqX + ", modFreqY: " + movers[0].modFreqY);
}