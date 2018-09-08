int scl = 20;
int cols = 1280/scl;
int rows = 720/scl;
float[][] terrain = new float[cols+1][rows+1];
float flying=0;

void setup() {
  size(1280, 720, P3D);
  for (int x = 0; x < cols+1; x++) {
    for (int y = 0; y < rows+1; y++) {
      terrain[x][y] = 0; //specify a default value for now
    }
  }
}

void draw() {
  background(50);
  pushMatrix();
  translate(10, height/3, -100);
  rotateX(PI/2.5);
  for (int y = 0; y < rows; y++) {
    beginShape(LINES);
    fill(75, 150, 255, 200);
    stroke(255);
    for (int x = 0; x < cols; x++) {
      //rows
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      if (x>0) {//since x-1
        //columns
        vertex(x*scl, y*scl, terrain[x][y]);
        vertex((x-1)*scl, y*scl, terrain[x-1][y]);
      }
    }
    endShape();
  }
  popMatrix();
}