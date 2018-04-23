Car player = new Car();
PVector[] trail = new PVector[0];

// gridmarkers are just there to show motion of vehicle when no obstacles are around
ArrayList<GridMarker> markers = new ArrayList<GridMarker>();

char mouseBuffer = '0';
int frames = 0;
float distanceTraveled = 0.0;
int gearshiftFrames = 3;
int markerInterval = 25;
PShape carGraphic;
float currentRevs = 0.0;

PVector fieldSize = new PVector(8000, 8000);

float mapX = 0.0;
float mapY = 0.0;

void setup() {
  //size(480, 640);
  fullScreen();
  colorMode(RGB);
  background(128, 128, 128);
  frameRate(30);
  carGraphic = loadShape("smallcar.svg");

  for (int i = int(-fieldSize.x/2); i < int(fieldSize.x/2); i += 200) {
    for (int j = int(-fieldSize.y/2); j < int(fieldSize.y/2); j += 200) {
      markers.add(new GridMarker(j, i));
    }
  }
}

void draw() {
  if (frames % gearshiftFrames != 0){
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
        player.gearChange(1);
      }
      if (key == 's' || key == 'S') {
        player.gearChange(-1);
      }
    }
  }

  clear();
  background(128, 100, 40);
  
  for (GridMarker marker : markers) {
    marker.update(player);
    marker.display(player);
  }


  // "map"
  fill(255, 255, 255, 32);
  stroke(255, 0, 0);
  strokeWeight(1);
  rectMode(CORNER);
  rect(width/2-100, 0, 200, 200);

  mapX = map(player.pos.x, -fieldSize.x/2, fieldSize.x/2, width/2-100, width/2+100);
  mapY = map(player.pos.y, -fieldSize.y/2, fieldSize.y/2, 0, 200);

  noStroke();
  fill(255, 0, 0);
  ellipseMode(CENTER);
  ellipse(mapX, mapY, 4, 4);

  // revmeter
  fill(128, 0, 0);
  rectMode(CORNER);
  rect(width/2-25, height-25, 20, 20);  
  currentRevs = 0.95*player.wheelSpeed/player.currentMaxSpeed;
  if(currentRevs > 1) {
    currentRevs = 1;  
  }
  fill(255, 255, 255);
  rect(10, height-25, ((width/2)*currentRevs)+10, 20);

  // hud text
  fill(255, 255, 255);
  textSize(16);
  text(int(player.wheelSpeed*3) + " mph", width/2, height-10);
  text("gear: " + int(player.currentGear+1), width-470, height-10);
  text("score: " + player.score, width-100, height-10);
  player.display(carGraphic);

  //if (int(distanceTraveled) % markerInterval == 0 && distanceTraveled > 1) {
  //  markers.add(new GridMarker(random(width), -100));
  //}


  println(player.steeringAngle);
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