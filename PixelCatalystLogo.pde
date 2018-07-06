class Square
{
  PVector target;
  PVector position;
  PVector presentation;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  float minRadius;
  int side;
  color col;
  boolean visible;
  boolean inMotion;

  void draw()
  {
    noStroke();
    fill(col);
    rect(presentation.x, presentation.y, side, side);
  }

  void pixelatePresentation()
  {
    presentation.x = round(position.x);
    presentation.y = round(position.y);
    int subPixelX = int(presentation.x) % side;
    int subPixelY = int(presentation.y) % side;
    presentation.x -= subPixelX;
    presentation.y -= subPixelY;
  }

  void update()
  {
    position.add(velocity);
    velocity.add(acceleration);
    acceleration.mult(0);
    pixelatePresentation();
    if ((presentation.x == target.x) && (presentation.y == target.y))
      inMotion = false;
  }

  void applyForce(PVector force)
  {
    acceleration.add(force);
  }

  PVector arrive()
  {
    PVector desired = PVector.sub(target, position);
    float mag = desired.mag();
    float speed = maxSpeed;
    if (mag < minRadius)
      speed = map(mag, 0, minRadius, 0, maxSpeed);
    desired.setMag(speed);
    PVector steer = PVector.sub(desired, velocity);
    return steer;
  }

  void behaviors()
  {
    PVector arriveForce = arrive();
    applyForce(arriveForce);
  }

  Square(int x, int y, int side, int shatterRadius, float maxSpeed, color col)
  {
    target = new PVector(x, y);
    float dX = random(x - shatterRadius, x + shatterRadius);
    float dY = random(y - shatterRadius, y + shatterRadius);
    position = new PVector(dX, dY);
    minRadius = 15 * (shatterRadius / 100.0) + 15;

    presentation = new PVector();
    velocity = new PVector();
    acceleration = new PVector();

    this.maxSpeed = maxSpeed;
    this.side = side;
    this.col = col;
    visible = false;
    inMotion = false;
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
    stencil.fill(0, 0, 255);
    stencil.text('P', horizontal, vertical + correction);
    horizontal += firstCapitalWidth;
    stencil.textFont(lowerCase);
    stencil.fill(255);
    stencil.text("ixel ", horizontal, vertical);
    horizontal += firstWordWidth;
    stencil.textFont(upperCase);
    stencil.fill(255, 0, 0);
    stencil.text('C', horizontal, vertical + correction);
    horizontal += secondCapitalWidth;
    stencil.textFont(lowerCase);
    stencil.fill(255);
    stencil.text("atalyst", horizontal, vertical);
  }

  Logo(float baseFontSize, float capitalization)
  {
    lowerCase = createFont("Square.ttf", baseFontSize / pixelSize);
    upperCase = createFont("Square.ttf", (baseFontSize + capitalization) / pixelSize);
  }
}

class ColorScatter
{
  color value;

  color toPredefinedVariation(color input)
  {
    color variation = color(0);
    float r = red(input);
    float g = green(input);
    float b = blue(input);
    if ((r == 0.0) && (g == 0.0) && (b == 255.0))
      variation = color(0, random(100, 186), 255);
    else if ((r == 255.0) && (g == 0.0) && (b == 0.0))
      variation = color(255, 9, random(8, 70));
    return variation;
  }

  ColorScatter(color input)
  {
    value = toPredefinedVariation(input);
    float probability = random(10);
    if (value == color(0))
    {
      if (probability < 6.5)
        value = color(random(190, 255));
      else
        value = color(random(90, 195));
    } else 
    {
      float h = hue(value);
      float s = 0.0;
      float b = brightness(value);
      if (probability < 6.0)
      {
        s = random(16, 220);
        b -= random(10);
      } else
      {
        s = random(210, 250);
        b -= random(128);
      }
      colorMode(HSB, 255);
      value = color(h, s, b);
      colorMode(RGB, 255);
    }
  }
}

PGraphics stencil;
int pixelSize = 3;
ArrayList<Square> logoSquares;  

void setup() 
{
  size(800, 400);
  noSmooth();
  stencil = createGraphics(width / pixelSize, height / pixelSize);
  stencil.noSmooth();
  stencil.beginDraw();
  stencil.background(0);

  Logo logo = new Logo(96, 12);
  logo.drawToStencil(stencil);

  stencil.endDraw();

  stencil.loadPixels();
  logoSquares = new ArrayList<Square>();
  for (int x = 0; x < stencil.width; ++x)
  {
    for (int y = 0; y < stencil.height; ++y)
    {
      int i = (y * stencil.width) + x;
      if (stencil.pixels[i] != color(0))
      {
        int scaledX = x * pixelSize;
        int scaledY = y * pixelSize;
        int shatterRadius = int(random(100, 500));
        float maxSpeed = random(4, 6);
        ColorScatter scatter = new ColorScatter(stencil.pixels[i]);
        Square sq = new Square(scaledX, scaledY, pixelSize, shatterRadius, maxSpeed, scatter.value);
        logoSquares.add(sq);
      }
    }
  }
  stencil.updatePixels();
}

boolean isLooping = true;

void mousePressed()
{
  if (mouseButton == LEFT)
  {
    if (isLooping)
    {
      noLoop();
      isLooping = false;
    } else
      redraw();
  } else if (mouseButton == RIGHT)
  {
    loop();
    isLooping = true;
  }
}

void draw() 
{
  background(0);

  int pixelsToActivate = 60 / pixelSize;
  for (Square sq : logoSquares)
  {
    if (sq.inMotion)
    {
      sq.behaviors();
      sq.update();
    }

    if (sq.visible)
      sq.draw();
    else if (pixelsToActivate > 0)
    {
      sq.visible = true;
      sq.inMotion = true;
      --pixelsToActivate;
    }
  }
}