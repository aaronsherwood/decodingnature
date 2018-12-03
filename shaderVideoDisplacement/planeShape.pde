PShape plane;
int scl = 8;
int cols = 1280/scl;
int rows = 720/scl;
void createPlane() {
  plane = createShape();
  for (int y = 0; y < rows; y++) {
    plane.beginShape(LINES);
    plane.stroke(255);
    plane.strokeWeight(3);
    for (int x = 0; x < cols; x++) {
      //rows
      plane.vertex(x*scl, y*scl, 0);
      plane.vertex(x*scl, (y+1)*scl, 0);
      if (x>0) {//since x-1
        //columns
        plane.vertex(x*scl, y*scl, 0);
        plane.vertex((x-1)*scl, y*scl, 0);
      }
    }
    plane.endShape();
  }
  
}

void drawPlane(){
  //background(0);
  pushStyle();
  noFill();
  pushMatrix();
  translate(10,0, 200);
  //translate(5, height/3, -100);
  //rotateX(PI/2.8);
  shape(plane,0,0);
  popMatrix();
  popStyle();
}