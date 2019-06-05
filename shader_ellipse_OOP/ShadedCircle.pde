class ShadedCircle {
  PShader mShader;
  float weight;
  float freq;
  float amp;
  float scale;
  boolean circle;
  PVector position, acceleration, velocity;
  float diam;
  float index;

  ShadedCircle(float x, float y, float diameter, float i) {
    weight = 7;
    freq = map(diameter, 10, 100, .0001, .0007);
    amp = (50-diameter)/2;
    scale = .005;
    circle = false;
    mShader = loadShader("frag.glsl", "vert.glsl");
    mShader.set("weight", weight);
    mShader.set("stroke", 1., .64, .3);
    mShader.set("alphaScale", 1.f);
    position = new PVector(x, y);
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    diam = diameter;
    index = i;
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force.div(diam));
  }

  void update() {
    // move around on screen with some perlin noise
    PVector force = new PVector();
    force.x = (noise(position.x*freq*index*.01+TWO_PI, position.y*.01*sin(frameCount*.001), (frameCount*.001))-.5)*5;
    force.y = (noise(position.y*freq*index*.01-TWO_PI, position.x*.01*cos(frameCount*.001), (frameCount*.001))-.5)*5;
    applyForce(force);

    // Update velocity
    velocity.add(acceleration);
    position.add(velocity);
    velocity.mult(.98);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    //push-pop style for the additive blending
    pushStyle();
    strokeWeight(weight); 
    stroke(255);
    blendMode(ADD);
    mShader.set("time", (float)millis());
    mShader.set("scale", scale );
    mShader.set("mouse", mouseX-position.x, mouseY-position.y);
    mShader.set("frequency", freq);
    mShader.set("deformAmount", 50.f);
    mShader.set("amplitude", amp);
    mShader.set("circle", circle);
    shader(mShader);
    noFill();
    ellipse(position.x, position.y, diam, diam);
    ellipse(position.x, position.y, diam-5, diam-5);
    popStyle();
  }

  PVector separate(ShadedCircle m) {
    PVector force = PVector.sub(position, m.position);             // Calculate direction of force
    float distance = force.mag();  // Distance between objects
    if (distance<100) {
      distance = constrain(distance, 5.0, 25.0);                             // Limiting the distance to eliminate "extreme" results for very close or very far objects
      force.normalize();                                            // Normalize vector (distance doesn't matter here, we just want this vector for direction

      float strength = (g * diam * m.diam) / (distance * distance); // Calculate gravitional force magnitude
      force.mult(-strength);       // Get force vector --> magnitude * direction
    } else
      force.set(0,0,0);
    return force;
  }

  void borders() {
    //adjust the position when it goes offscreen by 70% of the diameter to account for the distortion in the shape
    if (position.x < -diam*.7) position.x = width+diam*.7;
    if (position.y < -diam*.7) position.y = height+diam*.7;
    if (position.x > width+diam*.7) position.x = -diam*.7;
    if (position.y > height+diam*.7) position.y = -diam*.7;
  }

  void run() {
    update();
    borders();
    display();
  }
}