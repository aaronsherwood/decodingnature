class Spring{
  PVector anchor;
  float restingLength;
  float k;
  
  Spring(float x, float y, float len){
    anchor = new PVector(x,y);
    restingLength = len;
    k = .005;
  }
  
  void update(Mover m){
    PVector force = PVector.sub(m.position,anchor);
    float stretch = force.mag()-restingLength;
    
    force.normalize();
    force.mult(k*stretch*-1);
    m.applyForce(force);
    
  }
  
  void display(Mover m){
    line(anchor.x, anchor.y, m.position.x, m.position.y);
  }
}