class Square
{
  int x, y;
  int side;
  color hue;
  
  void draw()
  {
    noStroke();
    fill(hue);
    rect(x, y, side, side);
  }
  
  Square(int x, int y, int side)
  {
    this.x = x;
    this.y = y;
    this.side = side;
    hue = color(random(70, 250));
  }
}

PGraphics stencil;
int pixelSize = 3;
ArrayList<Square> logoSquares;

void setup() 
{
  size(750, 360);
  noSmooth();
  logoSquares = new ArrayList<Square>();
  
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
  
  stencil.loadPixels();
  for (int x = 0; x < stencil.width; ++x)
  {
    for (int y = 0; y < stencil.height; ++y)
    {
      int i = (y * stencil.width) + x;
      if (stencil.pixels[i] == color(255))
        logoSquares.add(new Square(x * pixelSize, y * pixelSize, pixelSize));
    }
  }
  stencil.updatePixels();
}

void draw() 
{
  background(0);
  
  for (Square sq : logoSquares)
    sq.draw();
}