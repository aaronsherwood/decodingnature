/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/27653*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
NavierStokesSolver fluidSolver;
double visc, diff, limitVelocity, vScale, velocityScale;
int oldMouseX = 1, oldMouseY = 1;
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
      float dx = (float) fluidSolver.getDx(cellX, cellY);
      float dy = (float) fluidSolver.getDy(cellX, cellY);

      float lX = p.x - cellX * cellWidth - cellWidth / 2;
      float lY = p.y - cellY * cellHeight - cellHeight / 2;

      int v, h, vf, hf;

      if (lX > 0) {
        v = Math.min(n, cellX + 1);
        vf = 1;
      } else {
        v = Math.min(n, cellX - 1);
        vf = -1;
      }

      if (lY > 0) {
        h = Math.min(n, cellY + 1);
        hf = 1;
      } else {
        h = Math.min(n, cellY - 1);
        hf = -1;
      }

      float dxv = (float) fluidSolver.getDx(v, cellY);
      float dxh = (float) fluidSolver.getDx(cellX, h);
      float dxvh = (float) fluidSolver.getDx(v, h);

      float dyv = (float) fluidSolver.getDy(v, cellY);
      float dyh = (float) fluidSolver.getDy(cellX, h);
      float dyvh = (float) fluidSolver.getDy(v, h);

      dx = lerp(lerp(dx, dxv, hf * lY / cellWidth), lerp(dxh, dxvh, hf * lY / cellWidth), vf * lX / cellHeight);

      dy = lerp(lerp(dy, dyv, hf * lY / cellWidth), lerp(dyh, dyvh, hf * lY / cellWidth), vf * lX / cellHeight);

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
  mouseX = max(1, mouseX);
  mouseY = max(1, mouseY);

  int n = NavierStokesSolver.N;
  float cellHeight = height / n;
  float cellWidth = width / n;

  double mouseDx = mouseX - oldMouseX;
  double mouseDy = mouseY - oldMouseY;
  int cellX = floor(mouseX / cellWidth);
  int cellY = floor(mouseY / cellHeight);

  //returns the signum function of the argument; 
  //zero if the argument is zero, 
  //1.0f if the argument is greater than zero, 
  //-1.0f if the argument is less than zero.
  //if above vel limit mult set to signum of mouse * vel limit, otherwise use mouse
  mouseDx = (abs((float) mouseDx) > limitVelocity) ? Math.signum(mouseDx) * limitVelocity : mouseDx;
  mouseDy = (abs((float) mouseDy) > limitVelocity) ? Math.signum(mouseDy) * limitVelocity : mouseDy;

  fluidSolver.applyForce(cellX, cellY, mouseDx, mouseDy);

  oldMouseX = mouseX;
  oldMouseY = mouseY;
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