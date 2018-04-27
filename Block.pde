class Block {
  
  PVector pos = new PVector();
  PVector size = new PVector();
  
  float unitSize = 800;
  PVector fieldSizeU = new PVector (40, 40);
  
  color blockFill = color(128, 128, 128);
  
  Block(int x, int y, int w, int h, color c){
    this.pos.x = x*unitSize - (unitSize);
    this.pos.y = y*unitSize - (unitSize);
    this.size.x = w*unitSize;
    this.size.y = h*unitSize;
    this.blockFill = c;
  }
  
  void display() {
    fill(this.blockFill);
    rectMode(CORNER);
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
  }

   void update(Car player) {
    this.pos.y += cos(player.vehicleDirection) * player.wheelSpeed;
    this.pos.x -= sin(player.vehicleDirection) * player.wheelSpeed;
  }
 
}