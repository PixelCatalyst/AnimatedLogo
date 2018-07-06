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