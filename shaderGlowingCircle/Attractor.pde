// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A class for a draggable attractive body in our world

class Attractor {
  float mass;    // Mass, tied to size
  float G;       // Gravitational Constant
  PVector position;   // position
  boolean dragging = false; // Is the object being dragged?
  boolean rollover = false; // Is the mouse over the ellipse?
  PVector dragOffset;  // holds the offset for when object is clicked on

  Attractor() {
    position = new PVector(width/2, height/2);
    mass = 200;
    G = 1;
    dragOffset = new PVector(0.0, 0.0);
  }

  PVector attract(Particle m) {
    PVector force = PVector.sub(position, m.position);   // Calculate direction of force
    float d = force.mag();
    if (d<200) {
      // Distance between objects
      d = constrain(d, 5.0, map(sin(frameCount*.005), -1, 1, 10, 30));                        // Limiting the distance to eliminate "extreme" results for very close or very far objects
      force.normalize();                                  // Normalize vector (distance doesn't matter here, we just want this vector for direction)
      float strength = (G * mass * m.mass) / (d * d);      // Calculate gravitional force magnitude
      force.mult(strength);                                  // Get force vector --> magnitude * direction
      return force;
    } else return new PVector(0,0);
  }
}