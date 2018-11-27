//based on dan shiffman's example && code found here: https://forum.processing.org/two/discussion/23712/fractal-zoom

double x, y, zr, zi, zr2, zi2, cr, ci, n;
double zmx1, zmx2, zmy1, zmy2, f;
double di, dj, fn1, fn2, fn3;
double re, gr, bl;
double xt, yt;
boolean zoomIn = true;
boolean autoZoom = false;

void setup() {
  size(500, 500);
  prepare();
}

void draw() {
  //trying to adjust the zooming to framerate for smoothness
  //f controls zoom, less than 1 zooms out, more than one zooms in
  //making relative to inverse of framerate, sort of works
  if (!zoomIn)
    f=1-(1./(float)frameRate); 
  else if (zoomIn)
    f=1+(1./(float)frameRate);

  if (autoZoom) {
    zoom();
  }
  
  for (int i =0; i<= width; i++) {
    //start x & y based on zoom points
    x =  (i +  di)/ zmx1 - zmx2;
    for ( int j = 0; j <= height; j++) {
      y = zmy2 - (j + dj) / zmy1;
      double a = x;
      double b = y;
      int n = 0;
      while (n < 200) {
        double aa = a * a;
        double bb = b * b;
        double twoab = 2.0 * a * b;
        a = aa - bb + x;
        b = twoab + y;
        // Infinty in our finite world is simple, let's just consider it 16
        if(aa + bb > 16.0f) {
          break;  // Bail
        }
        n++;
      }
      re = (n * fn1) % 255;
      gr = (n * fn2) % 255;
      bl = (n * fn3) % 255;
      int c = color((float)re, (float)gr, (float)bl);
      set(i, j, c);
    }
  }
}

void prepare() {
  di = 0;
  dj = 0;
  f = 1.05;
  fn1 = random(20); 
  fn2 = random(20); 
  fn3 = random(20);
  zmx1 = int(width / 4);
  zmx2 = 2;
  zmy1 = int(height / 4);
  zmy2 = 2;
} 

void zoom() {
  xt = mouseX;
  yt = mouseY;
  //set these to distance of mouse from screen center
  di = di + xt - float(width / 2); 
  dj = dj + yt - float(height / 2); 
  //f scales the zoom points
  zmx1 = zmx1 * f;
  zmx2 = zmx2 * (1 / f);
  zmy1 = zmy1 * f;
  zmy2 = zmy2 * (1 / f);
  di = di * f;
  dj = dj * f;
}

void mousePressed() {
  zoom();
}

void keyPressed() {
  if (key=='z') {
    zoomIn=!zoomIn;
  }
  if (key==' ')
    autoZoom=!autoZoom;
  println(f);
}