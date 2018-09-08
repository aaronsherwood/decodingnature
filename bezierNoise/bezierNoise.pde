float t;

void setup() {
  size(1280, 720);
  stroke(0, 18);
  noFill();
  t = 0;
  background(255);
}

void draw() {
  float x1 = width * noise(t + 315);
  float x2 = width * noise(t + 325);
  float x3 = width * noise(t + 335);
  float x4 = width * noise(t + 345);
  float y1 = height * noise(t + 355);
  float y2 = height * noise(t + 365);
  float y3 = height * noise(t + 375);
  float y4 = height * noise(t + 385);

  bezier(x1, y1, x2, y2, x3, y3, x4, y4);

  t += 0.005;

  // clear the background every 500 frames using mod (%) operator
  if (frameCount % 500 == 0) {
  background(255);
  }
}