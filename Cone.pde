class Cone {
  float size = 20;
  PVector pos;
  color coneFill = color(75, 100, 100);
  
  Cone (float x, float y) {
    this.pos = new PVector(x, y);
  }
  
  void display(){
     fill(this.coneFill);
     ellipse(this.pos.x, this.pos.y, this.size, this.size);
  }
  
}