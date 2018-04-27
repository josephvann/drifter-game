Car player = new Car(); //<>//
// gridmarkers are just there to show motion of vehicle when no obstacles are around
ArrayList<GridMarker> markers = new ArrayList<GridMarker>();
ArrayList<Block> blocks = new ArrayList<Block>();
char mouseBuffer = '0';
int frames = 0;
float distanceTraveled = 0.0;
float drawDistance;
int gearshiftFrames = 4;
int markerInterval = 25;

PVector compassEnd = new PVector(0, 0);

PShape carGraphic;

float currentRevs = 0.0;

PVector fieldSize = new PVector(32000, 32000);

float mapX = 0.0;
float mapY = 0.0;


void setup() {
  //size(480, 640);
  fullScreen();
  colorMode(RGB);
  background(128, 128, 128);
  frameRate(30);
  carGraphic = loadShape("smallcar.svg");
  trackBorder(2);
  populateTrackRandom();
  // pythagoras to work out diagonal screen dim.
  drawDistance = sqrt((width*width)+(height*height));

  for (int i = int(-fieldSize.x/2); i < int(fieldSize.x/2); i += 200) {
    for (int j = int(-fieldSize.y/2); j < int(fieldSize.y/2); j += 200) {
      markers.add(new GridMarker(j, i));
    }
  }
}

void draw() {
  if (frames % gearshiftFrames != 0) {
    if (keyPressed) {
      if (key == 'a' || key == 'A') {
        player.steer(-1);
      }
      if (key == 'd' || key == 'D') {
        player.steer(1);
      }
    }
  }

  if (frames % gearshiftFrames == 0) {
    if (keyPressed) {
      if (key == 'w' || key == 'W') {
        if (player.reversing) {
          player.reversing = false;
        } else {
          player.gearChange(1);
        }
      }
      if (key == 's' || key == 'S') {
        player.gearChange(-1);
      }
      if (key == 'r' || key == 'R') {
        player.reversing = !player.reversing;
        player.currentGear = 0;
        player.gearChange(-1);
      }
    }
  }

  if (mousePressed) {
    if (mouseButton == RIGHT) {
      player.accelerating = true;
      mouseBuffer = 'R';
    }
    if (mouseButton == LEFT) {
      player.braking = true;
      mouseBuffer = 'L';
    }
  } else {
    player.accelerating = false; 
    player.braking = false;
  }

  clear();
  background(85, 85, 85);

  player.checkCorners();
  player.display(carGraphic);

  // draw grid markers and blocks
  // everything that is stationary i.e. obstacles must be inside this push/pop matrix.
  pushMatrix();
  translate(width/2, height/2);
  rotate(-player.vehicleDirection);

  for (GridMarker marker : markers) {
    marker.update(player);
    if (dist(marker.pos.x, marker.pos.y, 0, 0) < drawDistance) { 
      marker.display(player);
    }
  }  

  for (Block block : blocks) {    
    block.update(player);
    if (dist(block.relativePos.x, block.relativePos.y, 0, 0) < drawDistance) { 
      player.checkCollision(block); 
      block.display();
    }
  }
  popMatrix();

  hud();
  player.score += player.wheelSpeed/10;
  frames ++;
}

void mouseReleased() {
  if (mouseBuffer == 'R') {
    player.accelerating = false;
  } else if (mouseBuffer == 'L') {
    player.braking = false;
  }
} 

void hud() {

  // "map"
  fill(255, 255, 255, 32);
  strokeWeight(1);
  
  // calculate location of dot on mini map.
  mapX = map(player.pos.x, -fieldSize.x/2, fieldSize.x/2, width-410, width-10);
  mapY = map(player.pos.y, -fieldSize.y/2, fieldSize.y/2, 0, 400);

  // draw map location
  noStroke();
  fill(255, 0, 0);
  ellipseMode(CENTER);
  ellipse(mapX, mapY, 4, 4);

  // draw blocks on the map.
  for (Block b : blocks) {
    mapX = map(b.pos.x, -fieldSize.x/2, fieldSize.x/2, width-410, width-10);
    mapY = map(b.pos.y, -fieldSize.y/2, fieldSize.y/2, 0, 400);
    fill(255, 255, 255);
    rectMode(CORNER);
    rect(mapX, mapY, 10, 10);
  }

  // revmeter
  // red line
  fill(128, 0, 0);
  rectMode(CORNER);
  rect(width/2-25, height-25, 20, 20);  

  // calculate rev meter location
  currentRevs = 0.95*player.wheelSpeed/player.currentMaxSpeed;
  if (currentRevs > 1) {
    currentRevs = 1;
  }

  // revmeter bar
  fill(255, 255, 255);
  rect(10, height-25, ((width/2)*currentRevs)+10, 20);

  // hud text colour
  fill(255, 255, 255);

  // speedometer
  textSize(32);
  text(int(player.wheelSpeed*2) + " mph", 10, height-42);

  // fps
  textSize(16);
  text(frameRate, 5, 25);

  // debug info
  text(player.repulsionDirection, 100, 25);

  // handy debugging info: coordinates of car + compass heading of car.
  //text(int(player.pos.x), 150, 25);
  //text(int(player.pos.y), 250, 25);
  //text("heading: " + int(degrees(player.vehicleDirection))%360, width*0.625, height-10);

  // gear indicator - overridden to R if player is reversing as reverse is based on first gear.
  if (!player.reversing) {
    text("gear: " + int(player.currentGear+1), width*0.75, height-10);
  } else {
    text("gear: R", width*0.75, height-10);
  }
  text("score: " + player.score, width*0.875, height-10);
}

void populateTrackRandom() {
  // this just scatters random blocks.
  for (int i = 0; i < 500; i++) {
    Block bl;
    bl = new Block(int(random(-20, 20)), 
      int(random(-20, 20)), 
      1, 1, 
      color(random(255), random(255), random(255))); 

    blocks.add(bl);
  }
}

void trackBorder(int weight) {
  for (int x = 0; x < weight; x++) {
    for (int j = -20+x; j < 21-x; j++) {
      blocks.add(new Block(j, -20+x, 1, 1, randomColour()));
      blocks.add(new Block(j, 20-x, 1, 1, randomColour()));
    }

    for (int i = -20+x; i < 20-x; i++) {
      blocks.add(new Block(-20+x, i, 1, 1, randomColour()));
      blocks.add(new Block(20-x, i, 1, 1, randomColour()));
    }
  }
}

color randomColour() {
  return(color(random(255), random(255), random(255)));
}