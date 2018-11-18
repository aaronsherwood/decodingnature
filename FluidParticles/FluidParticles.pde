/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/27653*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
NavierStokesSolver fluidSolver;
double visc, diff, limitVelocity, vScale, velocityScale;
int numParticles;

Particle[] particles;

float agePer, change;
int eR;
boolean showGrid = false;
boolean showParticles = true;

public void setup() {

  randomSeed(20);
  fluidSolver = new NavierStokesSolver();
  frameRate(60);

  size(800, 800);
  change =0.01;
  numParticles = 100000;
  particles = new Particle[numParticles];
  visc = 0.01f;
  diff = 0.25f;
  velocityScale = 16;

  limitVelocity = 200;
  colorMode(RGB, 1.);
  stroke(1);
  fill(1);
  smooth();

  initParticles();
}

private void initParticles() {
  for (int i = 0; i < numParticles - 1; i++) {
    particles[i] = new Particle();
    particles[i].x = random(1) * width;
    particles[i].y = random(1) * height;
    particles[i].partCol = 0;
  }
}

public void draw() {

  background(1);

  handleMouseMotion();
  
  //set the speed to adjust according to fluctations in the frame rate
  double dt = 1 / frameRate;
  fluidSolver.tick(dt, visc, diff);

  stroke(color(0));
  if (showGrid) {
    drawGrid();
    drawMotionVector((float) vScale * 2);
  }
  vScale = velocityScale * 60/ frameRate;
  if (showParticles)
    drawParticles();
}

private void drawParticles() {

  int n = NavierStokesSolver.N;
  float cellHeight = height / n;
  float cellWidth = width / n;

  for (Particle p : particles) {
    if (p != null) {
      int cellX = floor(p.x / cellWidth);
      int cellY = floor(p.y / cellHeight);
      // get the fluid velocity
      float dx = (float) fluidSolver.getDx(cellX, cellY);
      float dy = (float) fluidSolver.getDy(cellX, cellY);

      //distance from particle in cell to center of cell
      float lX = p.x - cellX * cellWidth - cellWidth / 2;
      float lY = p.y - cellY * cellHeight - cellHeight / 2;

      int v, h, vf, hf;

      //if distance is greater than 0 take whatever is smaller, the total number
      //horizontal/vertical cells or the current cell + 1
      if (lX > 0) {
        v = Math.min(n, cellX + 1);
        vf = 1;
      } 
      //otherwise go in the opposite direction (cell - 1)
      else {
        v = Math.min(n, cellX - 1);
        vf = -1;
      }
      
      //same for y
      if (lY > 0) {
        h = Math.min(n, cellY + 1);
        hf = 1;
      } else {
        h = Math.min(n, cellY - 1);
        hf = -1;
      }

      //lerp the velocity applied to each particle based on its distance from the center of the cell
      float dxv = (float) fluidSolver.getDx(v, cellY); //one cell ahead or behind in X dim, current Y cell
      float dxh = (float) fluidSolver.getDx(cellX, h); //current X cell, one cell ahead or behind in Y dim
      float dxvh = (float) fluidSolver.getDx(v, h); //one cell ahead or behind in both X & Y dims
      
      //take the x distance times the x direction and divide by cell width
      float xLerpAmount = vf * lX / cellWidth;
      
      //first lerp between the actual cell velocity and the velocity of the closest cell in X dim
      float lerpX0 = lerp(dx, dxv, xLerpAmount); 
      //next lerp between the velocity of the closest cell in Y dim and the velocity of the closest cell in X & Y dims
      float lerpX1 = lerp(dxh, dxvh, xLerpAmount);
      //finally lerp between both of those
      dx = lerp(lerpX0, lerpX1, xLerpAmount);
      
      //same for y
      float yLerpAmount = hf * lY / cellHeight;
      float dyv = (float) fluidSolver.getDy(v, cellY);
      float dyh = (float) fluidSolver.getDy(cellX, h);
      float dyvh = (float) fluidSolver.getDy(v, h);
      dy = lerp(lerp(dy, dyv, yLerpAmount), lerp(dyh, dyvh, yLerpAmount), yLerpAmount);
      
      //change the particle location 
      p.x += dx * vScale;
      p.y += dy * vScale;

      if (p.x < 0 || p.x >= width) {
        p.x = random(width);
      }
      if (p.y < 0 || p.y >= height) {
        p.y = random(height);
      }
      //set the pixel to a color
      int c = color(p.partCol);
      set((int) p.x, (int) p.y, c);
    }
  }
}

private void handleMouseMotion() {
  //don't let the mouse equal 0
  mouseX = max(1, mouseX);
  mouseY = max(1, mouseY);

  //get the cell dims
  int n = NavierStokesSolver.N;
  float cellHeight = height / n;
  float cellWidth = width / n;

  //whic way is our mouse going, this is our force
  double mouseDx = mouseX - pmouseX;
  double mouseDy = mouseY - pmouseY;
  
  //cell location
  int cellX = floor(mouseX / cellWidth);
  int cellY = floor(mouseY / cellHeight);

  //returns the signum function of the argument; 
  //zero if the argument is zero, 
  //1.0f if the argument is greater than zero, 
  //-1.0f if the argument is less than zero.
  //if above vel limit mult set to signum of mouse * vel limit, otherwise use mouse (i.e. -1*200 or 1*200 for direction)
  mouseDx = (abs((float) mouseDx) > limitVelocity) ? Math.signum(mouseDx) * limitVelocity : mouseDx;
  mouseDy = (abs((float) mouseDy) > limitVelocity) ? Math.signum(mouseDy) * limitVelocity : mouseDy;

  //apply force
  fluidSolver.applyForce(cellX, cellY, mouseDx, mouseDy);
}

private void drawMotionVector(float scale) {
  int n = NavierStokesSolver.N;
  float cellHeight = height / n;
  float cellWidth = width / n;
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      float dx = (float) fluidSolver.getDx(i, j);
      float dy = (float) fluidSolver.getDy(i, j);

      float x = cellWidth / 2 + cellWidth * i;
      float y = cellHeight / 2 + cellHeight * j;
      dx *= scale;
      dy *= scale;

      line(x, y, x + dx, y + dy);
    }
  }
}

private void drawGrid() {
  int n = NavierStokesSolver.N;
  float cellHeight = height / n;
  float cellWidth = width / n;
  for (int i = 1; i < n; i++) {
    line(0, cellHeight * i, width, cellHeight * i);
    line(cellWidth * i, 0, cellWidth * i, height);
  }
}

public class Particle {
  public float x;
  public float y;
  public color partCol;
}

void keyPressed() {
  if (key=='g') {
    showGrid=!showGrid;
  }
  if (key=='p') {
    showParticles=!showParticles;
  }
}