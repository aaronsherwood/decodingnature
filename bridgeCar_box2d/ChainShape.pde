// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// An uneven surface boundary

class Surface {
  // We'll keep track of all of the surface points
  ArrayList<Vec2> surface;
  int xStart, xEnd;
  float startHeight, endHeight;
  


  Surface(int _xStart, int _xEnd, float scale, int div, float depth) {
    surface = new ArrayList<Vec2>();
    // Here we keep track of the screen coordinates of the chain
    xStart=_xStart;
    xEnd = _xEnd;
    for (int i = xStart; i<=xEnd; i+=div){
      float y = height/2 + (noise(i*scale)-.5)*depth;
      surface.add(new Vec2(i, y));
      if (i==xStart)
      startHeight=y;
      endHeight = y;
    }

    // This is what box2d uses to put the surface in its world
    ChainShape chain = new ChainShape();

    // We can add 3 vertices by making an array of 3 Vec2 objects
    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = box2d.coordPixelsToWorld(surface.get(i));
    }

    chain.createChain(vertices, vertices.length);

    // The edge chain is now a body!
    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);
    FixtureDef fd = new FixtureDef();
    fd.shape = chain;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 100;
    fd.restitution = 0.0;
    body.createFixture(fd);
  }

  // A simple function to just draw the edge chain as a series of vertex points
  void display() {
    strokeWeight(1);
    stroke(0);
    fill(255);
    beginShape();
    for (Vec2 v: surface) {
      vertex(v.x, v.y);
    }
    vertex(xEnd, height);
    vertex(xStart, height);
    endShape(CLOSE);
  }
}