PImage img;

float sharpen[][] = {
  {-1, -1, -1}, 
  {-1, 9, -1}, 
  {-1, -1, -1}
};

float edge[][] = {
  {-1, -1, -1}, 
  {-1, 8, -1}, 
  {-1, -1, -1}
};

float v = 1.f / 9.f;
float blur[][] = {
  {v, v, v}, 
  {v, v, v}, 
  {v, v, v}
};

float sobelX[][] = {
  {1, 0, -1}, 
  {2, 0, -2}, 
  {1, 0, -1}
};

float sobelY[][] = {
  {1, 2, 1}, 
  {0, 0, 0}, 
  {-1, -2, -1}
};

float scharrX[][] = {
  {3, 0, -3}, 
  {10, 0, -10}, 
  {3, 0, -3}
};

float scharrY[][] = {
  {3, 10, 3}, 
  {0, 0, 0}, 
  {-3, -10, -3}
};

int w = 200;

float matrix[][] = sharpen;
boolean convolve = true;
boolean reprocess = true;



void setup() {
  size(800, 600);
  img = loadImage("data/moon.jpg");
}

void draw() {
  // so let's set the whole image as the background first
  if (reprocess) {//only process once
    image(img, 0, 0);
    if (convolve) {
      processImage(matrix);
    }
    // reprocess = false;
  }
}

void processImage(float matrix[][]) {
  // In this example we are only processing a section of the image
  int xstart = constrain(mouseX-w/2, 0, img.width);
  int ystart = constrain(mouseY-w/2, 0, img.height);
  int xend = constrain(mouseX + w/2, 0, img.width);
  int yend = constrain(mouseY + w/2, 0, img.height);
  int matrixsize = 3;

  loadPixels();
  img.loadPixels();

  for (int x = xstart; x < xend; x++) {
    for (int y = ystart; y < yend; y++) {
      // Each pixel location (x,y) gets passed into a function called convolution()
      // The convolution() function returns a new color to be displayed.
      color result = convolve(x, y, matrix, matrixsize, img);
      int loc = (x + y * img.width);
      pixels[loc] = result;
    }
  }
  updatePixels();
}

color convolve(int x, int y, float matrix[][], int matrixsize, PImage img) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = floor(matrixsize / 2);

  // Loop through convolution matrix
  for (int i = 0; i < matrixsize; i++) {
    for (int j = 0; j < matrixsize; j++) {
      // What pixel are we testing
      int xloc = x + i - offset;
      int yloc = y + j - offset;
      int loc = xloc + img.width * yloc;

      // Make sure we haven't walked off the edge of the pixel array
      // It is often good when looking at neighboring pixels to make sure we have not gone off the edge of the pixel array by accident.
      loc = constrain(loc, 0, img.pixels.length - 1);
      // Calculate the convolution
      // We sum all the neighboring pixels multiplied by the values in the convolution matrix.
      rtotal += red(img.pixels[loc]) * matrix[i][j];
      gtotal += green(img.pixels[loc]) * matrix[i][j];
      btotal += blue(img.pixels[loc]) * matrix[i][j];
    }
  }

  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);

  // Return an array with the three color values
  return color(rtotal, gtotal, btotal);
}

void keyTyped() {
  if (key == 's') {
    reprocess = true;
    matrix = sharpen;
    convolve = true;
  } else if (key == 'b') {
    reprocess = true;
    matrix = blur;
    convolve = true;
  } else if (key == 'n') {
    reprocess = true;
    convolve = false;
  } else if (key == 'e') {
    reprocess = true;
    matrix = edge;
    convolve = true;
  }
}