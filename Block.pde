class Block {
  
  PVector pos = new PVector();
  PVector relativePos = new PVector();
  PVector size = new PVector();
  
  float unitSize = 800;
  
  color blockFill = color(128, 128, 128);
  
  Block(int x, int y, int w, int h, color c){
    this.pos.x = x*unitSize;
    this.pos.y = y*unitSize;
    this.size.x = w*unitSize;
    this.size.y = h*unitSize;
    this.blockFill = c;
    relativePos = pos.copy();
  }
  
  void display() {
    fill(this.blockFill);
    rectMode(CORNER);
    rect(this.relativePos.x, this.relativePos.y, this.size.x, this.size.y);
  }

   void update(Car player) {
    this.relativePos.y += cos(player.vehicleDirection) * player.wheelSpeed;
    this.relativePos.x -= sin(player.vehicleDirection) * player.wheelSpeed;
  }
 
}