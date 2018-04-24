class GridMarker {
  float size = 10;
  PVector pos;
  color markerFill = color(255, 255, 255, 127);
  
  GridMarker (float x, float y) {
    this.pos = new PVector(x, y);
  }
    void display(Car player){

    fill(this.markerFill);
    ellipse(this.pos.x, this.pos.y, this.size, this.size);
  }
  
  void update(Car player) {
    this.pos.y += cos(player.vehicleDirection) * player.wheelSpeed;
    this.pos.x -= sin(player.vehicleDirection) * player.wheelSpeed;
  }
  
}