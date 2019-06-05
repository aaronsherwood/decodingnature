class Mover {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float angle;
  float freqX = 1;
  float freqY = 3;
  float phi = 90;
  int modFreqX = 2;
  int modFreqY = 1;
  int index;

  Mover(float m, float x, float y) {
    mass = m;
    position = new PVector(x, y);
    velocity = new PVector(1, 0);
    acceleration = new PVector(0, 0);
    angle=random(TWO_PI);
    //noise independence
    index = int(random(500));
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, .1);
    acceleration.add(f);
  }

  void update() {
    lissajousForce();
    centerForce();
    friction();
    noiseForce();
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
    checkBounds();
  }

  void lissajousForce() {
    phi += 2;
    float x = sin(angle * freqX + radians(phi)) * cos(angle * modFreqX);
    float y = sin(angle * freqY) * cos(angle * modFreqY);
    PVector force = new PVector(cos(angle), sin(angle));
    force.set(y*200, x*400);
    force.add(center);
    force.sub(position);
    force.setMag(.055);
    applyForce(force);
    angle+=inc;
  }

  void noiseForce() {
    float x = noise((index + position.x)*.001, position.y*.001, frameCount*.006)-.5;
    float y = noise(position.x*.001, (index+position.y)*.001, frameCount*.005)-.5;
    PVector noiseForce = new PVector(x, y);
    noiseForce.setMag(.065);
    applyForce(noiseForce);
  }

  void friction() {
    PVector force = velocity.copy();
    force.mult(-.005);
    applyForce(force);
  }

  void centerForce() {
    PVector force = center.copy();
    force.sub(position);
    float distanceToCenter = force.mag();
    float spread = 150;
    force.setMag(distanceToCenter / (spread * spread));
    applyForce(force);
  }

  void checkBounds() {
    //if (position.x<0 || position.x>width) velocity.x*=-1;
    //if (position.y<0 || position.y>height) velocity.y*=-1;
    
    if (position.x<0)position.x=width;
    if (position.x>width)position.x=0;
    if (position.y<0)position.y=height;
    if (position.y>height)position.y=0;
  }

  void display() {
    noStroke();
    fill(0, 50);
    image(img, position.x, position.y);
    //ellipse(position.x, position.y, mass*5, mass*5);
  }
}