class Block {
  
  PVector pos = new PVector();
  PVector size = new PVector();
  
  float unitSize = 200;
  PVector fieldSizeU = new PVector (40, 40);
  
  color blockFill = color(128, 128, 128);
  
  Block(float x, float y, float w, float h){
    this.pos.x = x*unitSize;
    this.pos.y = y*unitSize;
    this.size.x = w*unitSize;
    this.size.y = h*unitSize;
  }
  
  void display() {
    fill(this.blockFill);
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
  }

   void update(Car player) {
    this.pos.y += cos(player.vehicleDirection) * player.wheelSpeed;
    this.pos.x -= sin(player.vehicleDirection) * player.wheelSpeed;
  }
 
}