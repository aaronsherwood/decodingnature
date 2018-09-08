//fromprocessing handbook, pg 132

float power = 2; //the amount the texture deforms from the lines
float d = 400; //density, the amount of granularity of the texture

void setup() {
  size (640, 640);
}

void draw() {
  d=map(mouseX, 0, width, 600, 0);
  power=map(mouseY, 0, height, 0, 5);
  loadPixels();
  for (int y = 0; y<height; y++) {
    for (int x=0; x<width; x++) {
      float total = 0.0;
      for (float i = d; i>=1; i=i/2.0) {
        total += noise(x/d, y/d)* d;
      }
      float turbulence = 128.0 * total/d;
      float base = (x *0.05) + (y*0.02);
      float offset = base + (power * turbulence /256.0);
      float gray = abs(sin(offset))*256.0;
      pixels[x+y*width]=color(gray);
    }
  }
  updatePixels();
}
