//based on: http://neilwallis.com/projects/java/water/index.php
//and http://jsfiddle.net/esteewhy/5Ht3b/6/

PImage img;
int centerX;
int centerY;
int mSize;
int oldind;
int newind;
int riprad = 3; 
int ripplemap[]; 
PGraphics ripple ;
PGraphics tex;

void setup() {
  size(800, 600);
  img = loadImage("moon.jpg");

  //left shift by 1 divides by half
  centerX = width >> 1;
  centerY = height >> 1;

  //flip flop data each frame
  //one array holds both old and new information
  //with different indices to reach the two different arrays in one
  mSize = width * (height + 2) * 2;
  oldind = width;
  newind = width * (height + 3);

  //get the canvas pixel data
  tex = createGraphics(width,height);
  tex.beginDraw();
  tex.image(img, 0, 0);
  tex.endDraw();
  ripple = createGraphics(width,height);
  ripple.beginDraw();
  ripple.image(img, 0, 0);
  ripple.endDraw();
  
  //set everything to start out at 0
  //ripplemap hold the heights of the waves at each pixel location
  ripplemap = new int[mSize]; 
  for (int i = 0; i < mSize; i++) {
    ripplemap[i] = 0;
  }
}

void draw() {
  newframe();
  image(ripple,0,0);
}

void mouseMoved() {
  disturb(mouseX, mouseY);
}

/**
 * Disturb water at specified point
 */
void disturb(int dx, int dy) {
  //within the ripple radius, adjust wave height += 128
  for (int j = dy - riprad; j < dy + riprad; j++) {
    for (int k = dx - riprad; k < dx + riprad; k++) {
      ripplemap[oldind + (j * width) + k] += 128;
    }
  }
}

/**
 * Generates new ripples
 */
void newframe() {
  int a, b, data, old_data, cur_pixel, new_pixel;
  ripple.loadPixels();
  tex.loadPixels();
  //flipflop
  int t = oldind;//oldind into temporary variable
  oldind = newind;//newind into oldind
  newind = t;//temporary into newind
  // we will write into newind
  // but will still base our calculations on the two prvious frames
  // newind holds two frames ago
  // oldind holds prev frame

  int i = 0;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      //start from our newind, but don't change that actual index
      int _newind = newind + i, //two frames ago
        mapind = oldind + i;//prev frame
      // 1 2 3 mapind - width gets spot above
      // 4 5 6
      // 7 8 9
      data = ( //get the 4 directions, add together, and divide by 2
        ripplemap[mapind - width] +
        ripplemap[mapind + width] +
        ripplemap[mapind - 1] +
        ripplemap[mapind + 1]) >> 1;
      //get the velocity of the wave using verlet integration: vel = pos - prevPos
      //says newind, but remember, we flip floped above so data is prevframe and _newind is 2 frames ago
      data -= ripplemap[_newind];
      //damping, similar as saying *=.97 (100>>5=3, 100-3=97)
      data -= data >> 5;
      //now set the new ripplemap information
      ripplemap[_newind] = data;
      //1024 is 256*4, looking at 4 different directions
      //invert for no movement - where data=0 then still, where data>0 then wave
      data = 1024 - data;
      //offsets
      //will refract the original image, move pixels scaled by
      //distance from center scaled, then add distance from center
      //do it this way with the two center because data/1024 can equal zero, thus removing the center:
      //i.e. (50-width/2) * 0 + width/2 = width/2 VS 50*0 = 0
      a = (x - centerX) * data / 1024  + centerX;
      b = (y - centerY) * data / 1024  + centerY;

      //bounds check
      if (a >= width) a = width - 1;
      if (a < 0) a = 0;
      if (b >= height) b = height - 1;
      if (b < 0) b = 0;

      //x+y*width get the location of the pixel we want to move in order to refract
      new_pixel = a + b * width;
      cur_pixel = i;
      //get the newpixel  in our original texture
      //set the the current pixel of what we'll draw to that pixel
      ripple.pixels[cur_pixel] = tex.pixels[new_pixel];
      ++i;
    }
  }
  ripple.updatePixels();
}





/*
  if (frameCount % 10==0)
    disturb((int)random(250, 550), (int)random(100, 500));
*/