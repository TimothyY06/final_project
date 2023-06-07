class PlayerEl {
  String[] textures = {"Images/Kawaii/player.png", "Images/Pokemon/player.png", "Images/Minecraft/player.png"};
  PImage dinoPic = loadImage(textures[textureType]);
  PVector pos;
  PVector acc; 
  PVector vel;  
  
  float radius = 80;
  int jumpHeight;
  
  PlayerEl() {
    pos = new PVector(50,(height / 1.25 - radius));
    vel = new PVector(0, 20);
    acc = new PVector();
  }
  
  void addForce(PVector force) {
    acc.add(force); 
  }
  
  void gravity() {
    addForce(gravity);
    pos.add(vel); 
    if(pos.y >= height / 1.25 - radius) {
          pos.y = height / 1.25 - radius;
          vel.mult(0);
    }
   
    vel.add(acc);
    vel.limit(jumpHeight);
   
    acc.mult(0);
  }
 
  
  void display() {
    imageMode(CORNER);
    if(shrinkShroom)
      radius = 40;
    else
      radius = 80;
    image(dinoPic, pos.x, pos.y, radius, radius);
    
    if(invulnerable) {
      noStroke();
      fill(160, 32, 240, 50);
      ellipse(pos.x + radius / 2, pos.y + radius / 2, radius + 25, radius + 25);
    }
  }
  
  void display(int x, int y) { // for controls screen
    imageMode(CORNER);
    image(dinoPic, x, y, radius, radius);
  }
}
