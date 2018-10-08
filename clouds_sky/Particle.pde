class Particle {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float damping, mass;
  float nOffx, nOffy;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);

    position = l.copy();
    lifespan = 255.0;

    float vx = randomGaussian() ;
    float vy = randomGaussian()  ;
    velocity = new PVector(vx, vy);
    position = position.copy();
    lifespan = 255.0;
    mass = 1;//random(1, 10); // Let's do something better here!

    damping = .99;
    nOffx = random(0, 10000);
    nOffy = random(0, 10000);
  }

  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);   
    acceleration.add(f);
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    velocity.mult(damping);
    acceleration.mult(0);
    lifespan -= 2.0;
  }

  // Method to display
  void display() {
    pushMatrix();
    translate(position.x, position.y);
    image(tex0, 0, 0);
    //ellipse(0, 0, 20, 20);
    popMatrix();
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }

  void applyWind() {
    
    //noise to make them move and -.5 to move both left and right
    float xNoise = noise(nOffx, nOffy) - .5;
    //scale the noise by sine
    //make it oscillate slowly close to zero
    float xScale = sin(nOffx*.05)*.035;
    //set x value
    float x =  xNoise * xScale;
    
    //same as x
    float yNoise = noise(nOffx, nOffy)-.5;
    float yScale = sin(nOffy*.05)*.035;
    float y = yNoise * yScale;
    
    PVector wind = new PVector( x, y);
    applyForce(wind);
    nOffx+=.001;
    nOffy+=.001;
  }

  void checkEdges() {
    if (position.x>width+tex0.width)
      position.x=-tex0.width;
    if (position.x<-tex0.width)
      position.x=width;
    if (position.y>height+tex0.height)
      position.y=-tex0.height;
    if (position.y<-tex0.height)
      position.y=height+tex0.height;
  }
}