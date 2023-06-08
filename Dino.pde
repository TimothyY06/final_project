// Kinematics
PVector gravity;
PVector jumpForce; // Used to establish jump strength
boolean isGround; // Player Only Jumps when on Ground
float speed;

// Game Configs
boolean start; // Starts Game when true
boolean hit; // Player runs into obstacle
boolean startFrame; // Restarts frame count
boolean controlSrc; // Directs you to the control screen
boolean startScreen;
boolean selectPower = false;
PImage controls;
PImage enter;
PImage r;

// Objects
PlayerEl player;
ArrayList<BackgroundEl> bgarr; // ArrayList of all the background elements
ArrayList<ObstacleEl> obsarr; 
ArrayList<PowerUpsEl> powerUparr;

// Stats
int attempts;
int score;
int highScore;

// Powerups
boolean invulnerable;
boolean drunk;
boolean jumpHigh;
boolean shrinkShroom;
String effect;
int secondsCount;
int powerType; // Selects whether in power mode or not

// Texture
int textureType; // Selects the texture
int textNum = 3; // # of texture packs

void setup() {
  // Initial setup
  size(1500,600);
  background(200,200, 200);
  imageMode(CORNER);
  
  // Font and Start Screen
  PFont font = createFont("Papyrus", 50);
  fill(0, 0, 0);
  textFont(font);
  textAlign(CENTER, CENTER);
  text("PRESS ENTER TO START", width/2, height/2 - 100);
  fill(120);
  textSize(23);
  text("Press spacebar to view controls", width/2, height/2 - 25);
  fill(0,0,0);
  
  textSize(25);
  text("Kawaii", width/ (textNum + 1), height/2 + 150);
  text("Pokemon", width * 2 / (textNum + 1), height/2 + 150);
  text("Minecraft", width * 3 / (textNum + 1), height/2 + 150);
  
  text("PowerUps", width / 3, height/2 + 220);
  text("No PowerUps", width * 2 / 3, height/2 + 220);
  
  strokeWeight(5);
  rectMode(CENTER);
  fill(255, 0, 255, 50);
  rect(width * (textureType + 1) / (textNum + 1), height/2 + 150, 150, 50);
  
  fill(0, 255, 255, 50);
  rect(width * (powerType + 1) / 3, height/2 + 220, 175, 50);
  
  if(selectPower) {
    line(width * (powerType + 1) / 3 - 88, height/2 + 220, width * (powerType + 1) / 3 - 97, height/2 + 230);
    line(width * (powerType + 1) / 3 - 88, height/2 + 220, width * (powerType + 1) / 3 - 97, height/2 + 210);
  }
  
  else {
    line(width * (textureType + 1) / (textNum + 1) - 75, height/2 + 150, width * (textureType + 1) / (textNum + 1) - 85, height/2 + 160);
    line(width * (textureType + 1) / (textNum + 1) - 75, height/2 + 150, width * (textureType + 1) / (textNum + 1) - 85, height/2 + 140);
  }
  
  PlayerEl pp = new PlayerEl();
  pp.display(width * (textureType + 1) / (textNum + 1) - 30, height / 2 + 40);
  
  // Kinematics
  gravity = new PVector(0, .5);
  jumpForce = new PVector(0, -100);
  isGround = true;
  speed = 8;
  
  // Game Configs
  start = false;
  hit = false;
  startFrame = true;
  controlSrc = false;
  startScreen = true;
  
  // Create objects
  player = new PlayerEl();
  bgarr = new ArrayList<BackgroundEl>();
  obsarr = new ArrayList<ObstacleEl>();
  powerUparr = new ArrayList<PowerUpsEl>();
  
  // Stats
  score = 0;
  highScore = 0;
  attempts = 1;
  
  // Powerups
  invulnerable = false;
  drunk = false;
  jumpHigh = false;
  shrinkShroom = false;
  effect = "";
  secondsCount = 0;
  
  //Images for Control Screen
  controls = loadImage("Images/Controls/arrows.png");
  enter = loadImage("Images/Controls/enter.png");
  r = loadImage("Images/Controls/reset.png");
}

void draw() {
  if(start) { // Start Game on Key Press
    
    // Restart Frame Count
    if(startFrame) {
      frameCount = 0;
      startFrame = false;
    }
    
    background(30,170, 240); // Change background color
    fill(100, 50, 0);
    rectMode(CORNER);
    rect(0, height/1.25, width, height);
    displayStats(); // Display score and high score
    countDownAndDisplay();
    
    stroke(0, 200, 0);
    line(0, height/1.25, width, height/1.25); // Draw Line
  
    // Adds a new background object every 100 frames
    if(frameCount % 100 == 0) 
      bgarr.add(new BackgroundEl());
    
    // Cycles through array of backgrounds --> displays and moves all of them
    for(int x = 0; x < bgarr.size(); x++){
       BackgroundEl temp = bgarr.get(x);
       temp.display();
       temp.move();
       
       // If background is out of frame --> remove background from array
       if(temp.dotList.get(0).x < -(250 * speed)) {
         bgarr.remove(x);
         x--;
       }
    }
    
    // Grounds the player
    if(player.pos.y == height / 1.25 - player.radius) {
      isGround = true;
      gravity = new PVector(0, 0.5);
    }
    player.gravity(); // Apply gravity
    
    player.display(); // Display Player
    
    if(random(1) < 0.75 && frameCount % 60 == 0) {
      int num = int(random(4));
      if(num == 0)
        obsarr.add(new CactusEl());
      else if(num == 1)
        obsarr.add(new LongCactusEl());
      else if(num == 2)
        obsarr.add(new TreeEl());
      else if(num == 3)
        obsarr.add(new CloudEl());
    }
        
    for(int i = obsarr.size() - 1; i >= 0; i--) {
        ObstacleEl obs = obsarr.get(i);
        obs.move();
        
        obs.display();
        
        if (obs.hit(player))
            hit = true;
        
        //Remove the barriers that went out of frame
        if(obs.xpos < -obs.w) {
            obsarr.remove(i);
          }
    }
    
    if(powerType == 0) {
    if(random(1) < 0.25 && frameCount % 200 == 0) {
      powerUparr.add(new PowerUpsEl());
    }
    
    for(int i = powerUparr.size() - 1; i >= 0; i--) {
      PowerUpsEl power = powerUparr.get(i);
      
       if(power.hit(player)){
         int randNum = int(random(4));
         secondsCount = 5;
         power.specialEffects(randNum);
         powerUparr.remove(i);
       }
       else{
         power.display();
         power.move();
       }
    //Remove the barriers that went out of frame
    if(power.xpos < -power.w) {
        powerUparr.remove(i);
      }
    }
    
   if((drunk == true || invulnerable == true || jumpHigh == true || shrinkShroom == true) && secondsCount == 0){
     drunk = false;
     invulnerable = false;
     jumpHigh = false;
     shrinkShroom = false;
   }
   
   if(drunk){
     noStroke();
     fill(0, 255, 0, 50);
     rect(0, 0, width, height);
     strokeWeight(5);
     stroke(5);
   }
   }
   
   if(score % 50 == 0)
      speed += 0.1;
    
   if(hit && !invulnerable){
     attempts++;
     reset(); // Increment attempts
   }
   else
     hit = false;
  }
  
  if (controlSrc == true) 
    controlScreen();
}

void jump() {
  if(jumpHigh)
    player.jumpHeight = 15;
  else
    player.jumpHeight = 10;
    
  player.addForce(jumpForce);
}

void fall() {
  gravity.add(0,1);
}

void controlScreen() { //displays controls
    background(255,255,255);
    fill(0,0,0);
    CactusEl c = new CactusEl();
    CloudEl C = new CloudEl();
    LongCactusEl l = new LongCactusEl();
    TreeEl t = new TreeEl();
    textSize(100);
    fill(25, 25, 112);
    textAlign(CENTER, CENTER);
    text("Controls", width/2, 50); 
    image(controls, width/8 - 50, height/8 ,350,300);
    textSize(30);
    text("Use the up and down keys for movement!", width * 3/16 + 50, height/3 + 120);
    text("Avoid oncoming obstacles:", width * 3/16 + 50, height/3 + 170);
    player.display(width/8 + 85, 50);
    c.display(75, 3 * height/4);
    C.display(175, 3 * height/4);
    l.display(300, 3 * height/4);
    t.display(455, 3 * height/4 - 20);
    image(enter, width * 2/3 - 50, height/8 + 90 ,150,150);
    image(r, width * 2/3 + 150, height/8 + 90 ,150,150);
    text("Use enter to resume the game and R to reset!", width * 12/16, height/3 + 120); 
    text("Hitting a mystery box will grant you a random powerup:", width * 12/16, height/3 + 170);
    textSize(25);
    fill(120, 150, 80);
    text("Drunk, Invulnerability, High Jump, and Shrink", width * 12/16, height/3 + 220);
    textSize(30);
    fill(25, 25, 112);
    text("The duration and powerup type will appear in the top left", width * 12/16, height/3 + 270);
}

void countDownAndDisplay() {
  if(secondsCount > 0) {
    if(frameCount % 60 == 0) {
      secondsCount--;
    }
    textAlign(LEFT);
    text(secondsCount, 10, 30);
    text(effect, 10, 60);
  }
}

void displayStats() { 
  score = frameCount / 10; // Score is framecount divided by 10
  
  textAlign(RIGHT);
  fill(0, 0, 0);
  textSize(30);
  text("Score: " + score, width - 10, 30);
  
  textSize(20);
  fill(255,255,255);
  text("Highscore: " + highScore, width - 10, 30 + 40);
}

void reset() {
  // Reset start screen
  size(1500, 600);
  background(200, 200, 200);
  imageMode(CORNER);
  
  // Start screen text
  PFont font = createFont("Papyrus", 50);
  fill(0, 0, 0);
  textFont(font);
  textAlign(CENTER, CENTER);
  fill(220,20,60);
  textSize(80);
  text("LMAO what a loser", width/2, height/2 - 210);
  textSize(40);
  fill(120);
  text("PRESS ENTER TO START", width/2, height/2 - 115);
  textSize(35);
  fill(25, 25, 112);
  text("Attempts: " + attempts + "        Score: " + score + "        High Score: " + highScore, width/2, height/2 - 50);
  if (score > highScore) {
    fill(0, 163, 108);
    text("New High Score!", width/2, height/2);
  }
  
  fill(0,0,0);
  textSize(25);
  text("Kawaii", width/ (textNum + 1), height/2 + 150);
  text("Pokemon", width * 2 / (textNum + 1), height/2 + 150);
  text("Minecraft", width * 3 / (textNum + 1), height/2 + 150);
  text("PowerUps", width / 3, height/2 + 220);
  text("No PowerUps", width * 2 / 3, height/2 + 220);
  
  
  strokeWeight(5);
  rectMode(CENTER);
  fill(255, 0, 255, 50);
  rect(width * (textureType + 1) / (textNum + 1), height/2 + 150, 150, 50);
  
  fill(0, 255, 255, 50);
  rect(width * (powerType + 1) / 3, height/2 + 220, 175, 50);
  
  if(selectPower) {
    line(width * (powerType + 1) / 3 - 88, height/2 + 220, width * (powerType + 1) / 3 - 97, height/2 + 230);
    line(width * (powerType + 1) / 3 - 88, height/2 + 220, width * (powerType + 1) / 3 - 97, height/2 + 210);
  }
  
  else {
    line(width * (textureType + 1) / (textNum + 1) - 75, height/2 + 150, width * (textureType + 1) / (textNum + 1) - 85, height/2 + 160);
    line(width * (textureType + 1) / (textNum + 1) - 75, height/2 + 150, width * (textureType + 1) / (textNum + 1) - 85, height/2 + 140);
  }
  
  PlayerEl pp = new PlayerEl();
  pp.display(width * (textureType + 1) / (textNum + 1) - 30, height / 2 + 40);
  
  // Re-create objects
  player = new PlayerEl();
  bgarr = new ArrayList<BackgroundEl>();
  obsarr = new ArrayList<ObstacleEl>();
  powerUparr = new ArrayList<PowerUpsEl>();
  
  // Kinematics
  gravity = new PVector(0, .5);
  isGround = true;
  speed = 8;
  jumpForce = new PVector(0, -100);
  
  // Game Configs
  startFrame = true;
  start = false;
  hit = false;
  controlSrc = false;
  startScreen = false;
  
  // Powerups
  invulnerable = false;
  drunk = false;
  jumpHigh = false;
  shrinkShroom = false;
  secondsCount = 0;
  effect = "";
}

void keyPressed() {
  if(key == CODED) {
    if (keyCode == UP) { 
      if(!start) {
        if(selectPower) {
          selectPower = false;
        }
        else {
          selectPower = true;
        }
        if(startScreen)
          setup();
        else {
          reset();
        }
      }
      else if(drunk) {
       fall();
       System.out.println("You're drunk! Going down!");
      }
      else {
        if(isGround) { // jumps
          jump();
          isGround = false;
        }
      }
      System.out.println("Going up!");
    }
    
    else if (keyCode == DOWN) {
      if(!start) {
        if(selectPower) {
          selectPower = false;
        }
        else {
          selectPower = true;
        }
       if(startScreen)
          setup();
        else {
          reset();
        }
      }   
      else if (drunk) { // gives you unlimited up jumps oops
        if(isGround){
          jump();
          isGround = false;
          System.out.println("You're drunk! Going up!");
        }
      }
      else {
        fall();
        System.out.println("Landing!");
      }
    }
    else if(keyCode == RIGHT) {
      if(!start) {
        if(selectPower) {
         if(powerType < 1)
          powerType++;
         else
          powerType = 0; 
        }

        else{
          if(textureType < textNum - 1)
            textureType++;
          else
            textureType = 0;
        }
          
        if(startScreen)
          setup();
        else 
          reset();
        
      System.out.println("change");
        
      }
    }
    
    else if(keyCode == LEFT) {
      if(!start) {          
        if(selectPower) {
         if(powerType > 0)
          powerType--;
         else
          powerType = 1; 
        }

        else{
          if(textureType > 0)
            textureType--;
          else
            textureType = textNum - 1;
        }
          
          
        if(startScreen)
          setup();
        else {
          reset();
        }
      }
    }
  }
    if (key == 'r' || key == 'R') {
      reset();
      System.out.println("reset");
    }
    else if (key == ENTER) {
      start = true;
      controlSrc = false;
      if(score > highScore)
        highScore = score;
      score = 0;
    }
    else if (key == ' ') {
      start = false;
      controlSrc = true;
    }
    
    else if (key == 'e') {
      System.out.println(powerType);
    }
  }
