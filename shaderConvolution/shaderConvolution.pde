PShader mShader;  
PImage img;

float edge[][] = {
  {-1, -1, -1}, 
  {-1, 8, -1}, 
  {-1, -1, -1}
};

float sharpen[][] = {
  {-1, -1, -1}, 
  {-1, 9, -1}, 
  {-1, -1, -1}
};

float kernel[][]=edge;

void setup() {
  size(800, 600, P2D);
  img = loadImage("moon.jpg");      
  mShader = loadShader("frag.glsl");
}

void draw() {
  mShader.set("kernel_value_00", kernel[0][0]);
  mShader.set("kernel_value_01", kernel[0][1]);
  mShader.set("kernel_value_02", kernel[0][2]);
  mShader.set("kernel_value_10", kernel[1][0]);
  mShader.set("kernel_value_11", kernel[1][1]);
  mShader.set("kernel_value_12", kernel[1][2]);
  mShader.set("kernel_value_20", kernel[2][0]);
  mShader.set("kernel_value_21", kernel[2][1]);
  mShader.set("kernel_value_22", kernel[2][2]);
  //move between and edge and a sharpen filter
  kernel[1][1]=map(mouseX,0,width,8,9);
  shader(mShader);
  image(img, 0, 0);
}