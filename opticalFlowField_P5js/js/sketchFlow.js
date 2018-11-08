var capture;
var previousPixels;
var flow;
var w = 640,
  h = 480;
var step = 8;
var avgFlow;
var movers = [];
var numBoxes = 250;



var mover;

function setup() {
  createCanvas(window.innerWidth, window.innerHeight);
  capture = createCapture(VIDEO);

  capture.hide();
  flow = new FlowCalculator(step);
  avgFlow = createVector(0, 0);


  for (var i = 0; i < numBoxes; i++) {
    var r = floor(random(7));
    var c;
    var alpha = 127;
    switch (r) {
      case 0:
        c = color(255, 0, 0, alpha); //red
        break;
      case 1:
        c = color(255, 127, 0, alpha); //orange
        break;
      case 2:
        c = color(255, 255, 0, alpha); //yellow
        break;
      case 3:
        c = color(0, 255, 0, alpha); //green
        break;
      case 4:
        c = color(0, 0, 255, alpha); //blue
        break;
      case 5:
        c = color(75, 0, 130, alpha); //purple
        break;
      case 6:
        c = color(143, 0, 255, alpha); //violet
        break;
    }
    c = color(255, 100);
    var s = random(1, 4);
    var x = random(width);
    var y = random(height);
    movers[i] = new Mover(s, x, y, c);

  }


}

function draw() {
  scale(-1, 1);
  translate(-width, 0);
  capture.loadPixels();
  if (capture.pixels.length > 0) {
   if (previousPixels) {
     // cheap way to ignore duplicate frames
     if (same(previousPixels, capture.pixels, 4, w)) {
       return;
     }
     flow.calculate(previousPixels, capture.pixels, capture.width, capture.height);
   }

   previousPixels = copyImage(capture.pixels, previousPixels);
   capture.updatePixels();
   blendMode(BLEND);
   image(capture, 0, 0, width, height);



   if (flow.flow && flow.flow.u != 0 && flow.flow.v != 0) {

     strokeWeight(2);


     for (var i = 0; i < movers.length; i++) {
       var m = movers[i];
       var x = map(m.position.x, 0, width, 0, w);
       var y = map(m.position.y, 0, height, 0, h);
       var arrayLoc = flow.getArrayLoc(x, y, w);
       var zone = flow.flow.zones[arrayLoc];

       var force = createVector(zone.u, zone.v);

       m.applyForces(force);
       m.update();

       m.display();

     }
   }
 }

}

function copyImage(src, dst) {
  var n = src.length;
  if (!dst || dst.length != n) {
    dst = new src.constructor(n);
  }
  while (n--) {
    dst[n] = src[n];
  }
  return dst;
}

function same(a1, a2, stride, n) {
  for (var i = 0; i < n; i += stride) {
    if (a1[i] != a2[i]) {
      return false;
    }
  }
  return true;
}
