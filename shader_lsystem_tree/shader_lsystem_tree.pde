PShader mShader;
float weight = 3;

LSystem lsys;
Turtle turtle;

PVector transAmount = new PVector();
float rotateDegrees=0;
boolean shaderActive=true;
float freq = .0001f; //.000009f crazier
float amp = 10;// 50. crazier
boolean circle = false;

void setup() {
  size(800, 800, P3D);
  mShader = loadShader("frag.glsl", "vert.glsl");
  mShader.set("weight", weight);
  mShader.set("stroke", 1.f);
  mShader.set("alphaScale", .25f);
  strokeWeight(weight);

  //Tree
  Rule[] ruleset = new Rule[2];
  ruleset[0] = new Rule('F', "FF+[+G-F-F]-[-F+F+F]");
  ruleset[1] = new Rule('G', "F++FG-[F]-[-F+F+F]");
  lsys = new LSystem("F", ruleset);
  turtle = new Turtle(lsys.getSentence(), height/3, radians(25));
  transAmount.set(width/2, height, 0);
  rotateDegrees=-90;

  //Hexagonal Gosper
  //Rule[] ruleset = new Rule[2];
  //ruleset[0] = new Rule('X', "X+YF++YF-FX--FXFX-YF+");
  //ruleset[1] = new Rule('Y', "-FX+YFYF++YF+FX--FX-Y");
  //lsys = new LSystem("XF", ruleset);
  //turtle =  new Turtle(lsys.getSentence(), 120, radians(60));
  //transAmount.set((width/4)*3.1, 70, 0);
  //rotateDegrees=0;

  //Not Sure
  //Rule[] ruleset = new Rule[1];
  //ruleset[0] = new Rule('X', "X{F-F-F}+XF+F+X{F-F-F}+X");
  //lsys = new LSystem("F+XF+F+XF", ruleset);
  //turtle = new Turtle(lsys.getSentence(), height/1.2, radians(100));
  //transAmount.set(width/3-4, 4, 0);
  //rotateDegrees=30;

  for (int i=0; i<5; i++) {
    pushMatrix();
    lsys.generate();
    turtle.setToDo(lsys.getSentence());
    turtle.changeLen(0.5);
    popMatrix();
  }
}

void draw() {
  if (shaderActive) {
    mShader.set("time", (float)millis());
    mShader.set("scale", .01 );
    mShader.set("mouse", float(mouseX-width/2), float(mouseY-height/2));
    mShader.set("frequency", freq); //.000009f crazier
    mShader.set("amplitude", amp);
    mShader.set("circle", circle);
    shader(mShader);
  }
  background(0);
  translate(transAmount.x, transAmount.y, transAmount.z);
  rotate(radians(rotateDegrees));
  turtle.render();
}

void keyPressed() {
  if (keyCode==UP){ 
    freq+=.00001f;
  }
  if (keyCode==DOWN)
    freq-=.00001f;
  if (key=='1'){
     freq = .00014f;
     amp = 10.;
     circle = false;
  }
  if (key=='2'){
     freq = .00016f;
     amp = 20.;
     circle = true;
  }
}