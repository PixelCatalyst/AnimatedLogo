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