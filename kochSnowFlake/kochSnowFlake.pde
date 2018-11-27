// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Koch Curve
// Renders a simple fractal, the Koch snowflake
// Each recursive level drawn in sequence

ArrayList<ArrayList<KochLine>> lines;   // A list to keep track of all the lines

void setup() {
  size(600, 600);
  background(255);

  lines = new ArrayList<ArrayList<KochLine>>();
  int w = 400;
  PVector start = new PVector(width/2-w/2, 175);
  PVector end   = new PVector(width/2+w/2, 175);
  float angle = 0;
  int resolution = 5;
  for (int i = 0; i<3; i++) {
    ArrayList<KochLine> line = new ArrayList<KochLine>();
    line.add(new KochLine(start, end));
    for (int j = 0; j < resolution; j++) {
      line = generate(line);
    }
    lines.add(line);
    angle+=TWO_PI/3;

    start = end.copy();
    end = new PVector(start.x+cos(angle)*w, start.y+sin(angle)*w);
  }
}

void draw() {
  background(255);
  for (ArrayList<KochLine> k : lines) {
    for (KochLine l : k) {
      l.display();
    }
  }
}

ArrayList<KochLine> generate(ArrayList<KochLine> ls) {
  ArrayList next = new ArrayList<KochLine>();    // Create emtpy list
  for (KochLine l : ls) {
    // Calculate 5 koch PVectors (done for us by the line object)
    PVector a = l.kochA();                 
    PVector b = l.kochB();
    PVector c = l.kochC();
    PVector d = l.kochD();
    PVector e = l.kochE();
    // Make line segments between all the PVectors and add them
    next.add(new KochLine(a, b));
    next.add(new KochLine(b, c));
    next.add(new KochLine(c, d));
    next.add(new KochLine(d, e));
  }
  return next;
}