PGraphics stencil;
int pixelSize = 3;
ArrayList<Square> logoSquares;  
boolean recordFrames = false;

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
  noLoop();
}

boolean started = false;
boolean isLooping = true;

void mousePressed()
{
  if (started)
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
}

void keyPressed()
{
  if (started == false)
  {
    if ((key == 'r') || (key == 'R'))
      recordFrames = true;
    started = true;
    loop();
  }
  else if ((key == 's') || (key == 'S'))
  {
    String date = new String();
    date += nf(year());
    date += nf(month(), 2);
    date += nf(day(), 2);
    date += nf(hour(), 2);
    date += nf(minute(), 2);
    date += nf(second(), 2);
    save("snapshots/snap_" + date + "_" + nf(millis()) + ".png");
  }
}

void draw() 
{
  background(0);

  int pixelsToActivate = 60 / pixelSize;
  boolean animationFinished = true;
  for (Square sq : logoSquares)
  {
    if (sq.inMotion)
    {
      sq.behaviors();
      sq.update();
      animationFinished = false;
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
  if (animationFinished)
    noLoop();
  
  if (recordFrames)
  {
    saveFrame("frames/frame_####.png");
    if (animationFinished)
      recordFrames = false;
  }
}