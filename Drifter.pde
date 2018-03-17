Car player = new Car();
Track randTrack = new Track();

char mouseBuffer = '0';

void setup() {
  //size(640, 480);
  fullScreen();
  colorMode(HSB, 100);
  background(0, 0, 50);
  randTrack.populateRandom();
}

void draw() {
  frameRate(30);
  if (keyPressed) {
    if (key == 'w' || key == 'W') {
      player.accelerating = true;
    }
    if (key == 's' || key == 'S') {
      player.braking = true;
    }
    if (key == 'a' || key == 'A') {
      player.steer(1);
    }
    if (key == 'd' || key == 'D') {
      player.steer(-1);
    }
  }
  clear();
  background(0, 0, 50);
  textSize(100);
  text(int(player.wheelSpeed*7) + " mph", width/2, height-10); 
  player.display();
  randTrack.display();

  if (mousePressed) {
    if (mouseButton == RIGHT) {
      player.accelerating = true;
      mouseBuffer = 'L';
    }
    if (mouseButton == LEFT) {
      player.braking = true;
      mouseBuffer = 'R';
    }
  } else {
    player.accelerating = false; 
    player.braking = false;
  }
}

void mouseReleased() {
}