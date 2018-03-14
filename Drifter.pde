Car player = new Car();

void setup() {
  //size(640, 480);
  fullScreen();
  background(128);
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
  background(128);
  text(int(player.wheelSpeed*7) + " mph", width/2, height-50); 
  player.display();
}


void keyReleased() {
  player.accelerating = false;
  player.braking = false;
}