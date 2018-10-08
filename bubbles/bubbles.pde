ParticleSystem ps;
Particle mover;

boolean useMouse = true;

void setup() {
  fullScreen(P3D);
  PImage img = loadImage("bubble.png");
  ps = new ParticleSystem(0, new PVector(width/2, height-75), img);
  if (!useMouse) {
    ofSetup();
    mover = new Mover(new PVector(width/2, height/2), img);
    noCursor();
  }
}

void draw() {
  background(0);
  float windX = 0;
  
  //MOUSE
  if (useMouse) {
    ps.origin.set(mouseX, mouseY, 0);
    windX = map(mouseX, 0, width, -0.05, 0.05);
    if (mouseX!=pmouseX && mouseY!=pmouseY) {
      for (int i = 0; i < 1; i++) {
        ps.addParticle();
      }
    }
    
  //OPTICAL FLOW
  } else {
    flow();
    ps.origin = mover.pos.copy();
    mover.run();
    if (mover.vel.mag()>2 || smoothedFlow.mag()>.1) {
      mover.applyForce(smoothedFlow);
      ps.addParticle();
    }
    windX = smoothedFlow.x*.25;
  }

  //RUN IT
  PVector wind = new PVector(windX, 0);
  ps.applyForce(wind);
  ps.run();
}