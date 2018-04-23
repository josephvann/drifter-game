class GridMarker {
  float size = 10;
  PVector pos;
  color markerFill = color(255, 255, 255, 64);
  
  GridMarker (float x, float y) {
    this.pos = new PVector(x, y);
  }
  
  void display(Car player){
    pushMatrix();
    translate(width/2, height/2);
    rotate(-player.vehicleDirection);
    fill(this.markerFill);
    ellipse(this.pos.x, this.pos.y, this.size, this.size);
    popMatrix();
  }
  
  void update(Car player) {
    this.pos.y += cos(player.vehicleDirection) * player.wheelSpeed;
    this.pos.x -= sin(player.vehicleDirection) * player.wheelSpeed;
  }
  
}