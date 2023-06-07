public class ObstacleEl {
  PImage pic;
  float w;
  float h;
  float xpos = width;
  float ypos;


  public ObstacleEl(float wid, float hei, float y, String[] textArray) {
    w = wid;
    h = hei;
    ypos = y;
    pic = loadImage(textArray[textureType]);
  }

  boolean hit(PlayerEl p) {
    return ((p.pos.x > xpos) && ((p.pos.x) < (xpos + w))) &&  (p.pos.y < (ypos + h)) && ((p.pos.y + p.radius) > ypos);
  }

  void move() {
    xpos -= speed;
  }

  void display() {
    imageMode(CORNER);
    image(pic, xpos, ypos, w, h);
  }
  
  void display(int x, int y) {
    image(pic, x, y, w, h);
  }
}
