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

class Logo
{
  PFont lowerCase;
  PFont upperCase;

  void drawToStencil(PGraphics stencil)
  {
    stencil.textAlign(LEFT, BOTTOM);
    stencil.textFont(upperCase);
    float textHeight = stencil.textAscent() - stencil.textDescent();
    float upperDescent = stencil.textDescent();
    float firstCapitalWidth = stencil.textWidth('P');
    float secondCapitalWidth = stencil.textWidth('C');
    stencil.textFont(lowerCase);
    float correction = upperDescent - stencil.textDescent();
    float firstWordWidth = stencil.textWidth("ixel ");
    float secondWordWidth = stencil.textWidth("atalyst");
    float totalWidth = firstCapitalWidth + firstWordWidth + secondCapitalWidth + secondWordWidth;
    float vertical = (stencil.height + textHeight) / 2.0;
    float horizontal = (stencil.width - totalWidth) / 2.0;
    
    stencil.textFont(upperCase);
    stencil.text('P', horizontal, vertical + correction);
    horizontal += firstCapitalWidth;
    stencil.textFont(lowerCase);
    stencil.text("ixel ", horizontal, vertical);
    horizontal += firstWordWidth;
    stencil.textFont(upperCase);
    stencil.text('C', horizontal, vertical + correction);
    horizontal += secondCapitalWidth;
    stencil.textFont(lowerCase);
    stencil.text("atalyst", horizontal, vertical);
  }

  Logo(float baseFontSize, float capitalization)
  {
    lowerCase = createFont("Square.ttf", baseFontSize / pixelSize);
    upperCase = createFont("Square.ttf", (baseFontSize + capitalization) / pixelSize);
  }
}

PGraphics stencil;
int pixelSize = 2;
ArrayList<Square> logoSquares;  

void setup() 
{
  size(800, 400);
  noSmooth();
  logoSquares = new ArrayList<Square>();

  stencil = createGraphics(width / pixelSize, height / pixelSize);
  stencil.noSmooth();
  stencil.beginDraw();
  stencil.background(0);

  Logo logo = new Logo(96 * 2, 12 * 2);
  logo.drawToStencil(stencil);

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