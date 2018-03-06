class Square
{
  int x, y;
  
  Square(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
}

PGraphics stencil;
int pixelSize = 3;
ArrayList<Square> LogoSquares;

void setup() 
{
  size(750, 360);
  noSmooth();
  LogoSquares = new ArrayList<Square>();
  
  stencil = createGraphics(width / pixelSize, height / pixelSize);
  stencil.noSmooth();
  stencil.beginDraw();
  stencil.background(51);
  PFont lucidaConsole = createFont("Lucida Console", 86 / pixelSize);
  stencil.textFont(lucidaConsole);
  stencil.fill(255);
  stencil.textAlign(CENTER);
  stencil.text("Pixel Catalyst", width / 2.0 / pixelSize, height / 1.8 / pixelSize);
  stencil.endDraw();
}

void draw() 
{
  background(0);
  image(stencil, 0, 0);
}