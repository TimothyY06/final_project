public class BackgroundEl {
  ArrayList<PVector> dotList = new ArrayList<PVector>();
  
  public BackgroundEl() {
    for(int x = 0; x < 10; x++) {
      dotList.add(new PVector(random(int(250 * speed)) + width, random(height/1.25 + 10, height - 10)));
    }
  }

  void move() {
    // Move dots
    for(int x = 0; x < dotList.size(); x++) {
      dotList.set(x, dotList.get(x).sub(speed, 0));
    }
  }

  void display() { 
    strokeWeight(4);
    stroke(0);
    for(int x = 0; x < dotList.size(); x++) {
      line(dotList.get(x).x, dotList.get(x).y, dotList.get(x).x, dotList.get(x).y);
    }
  }
  
}
