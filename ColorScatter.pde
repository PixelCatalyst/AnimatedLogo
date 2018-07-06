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