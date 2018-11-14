//predator class extends boid class
class Predator extends Boid {
  
  //how strong the predator repels the prey
  float predatorStrength = 100;
  //how far away the prey is before being affected
  float desiredseparation = 70;
  
  Predator(float x, float y) {
    super(x, y); 
    //make it a little larger
    r = 5;
  }

  //new run function, we don't need to pass in all the boids here
  void run() {
    update();
    borders();
    render();
  }

  //new render function just to draw it red
  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(90);
    fill(255, 0, 0);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  //here we will affect all the other boids
  void predate(ArrayList<Boid> boids) {
    //also call run here
    run();
    //loop through all boids
    for (Boid b : boids) {
      float d = PVector.dist(position, b.position);
      // If the distance is greater than an arbitrary amount 
      if (d < desiredseparation) {
        // Calculate vector pointing away from us, toward prey
        PVector diff = PVector.sub(b.position, position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        //set how strong the predator's repel force is
        diff.mult(predatorStrength);
        // Implement Reynolds: Steering = Desired - Velocity
        diff.sub(velocity);
        //don't limit force and apply to the boid
        b.applyForce(diff);
      }
    }
  }
}