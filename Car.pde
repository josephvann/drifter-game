class Car {
  float power = 3.0;
  int accelerationSteps = 7;
  float coastCoefficient = 0.99;
  float maxSpeed = 12.0;
  float maxRearGrip = 0.7;
  float rearGrip = 0.7;
  float maxFrontGrip = 0.7;
  float frontGrip = 0.7;
  // strangely, lower is better!
  float brakePower = 0.9;
  
  boolean accelerating = false;
  boolean braking = false;

  float rearTyreThresholdSpeed = 4.0;
  float frontTyreThresholdSpeed = 4.0;

  int health = 5;

  float trackWidth = 15.0;
  float wheelBase = 35.0;

  color carFill = color(15);

  float wheelSpeed = 0.0;
  float fullLock = 45.0;
  float steeringAngle = 0.0;
  PVector vehicleDirection = new PVector(0, 0);


  PVector pos = new PVector(width/2, height-50);

  Car() {
  }
  void update() {
    if(!this.accelerating){
      this.wheelSpeed *= this.coastCoefficient;
    } else {
      this.accelerate();
    }
    if(this.braking) {
      this.brake(); 
    }
    this.vehicleDirection.rotate(steeringAngle);
    this.pos.add(-wheelSpeed*sin(radians(steeringAngle)), -wheelSpeed*cos(radians(steeringAngle)));
    
    if(this.pos.y < 0) {
      this.pos.y = height; 
    }
    if(this.pos.y > height) {
      this.pos.y = 0; 
    }
    if(this.pos.x < 0) {
      this.pos.x = width; 
    }
    if(this.pos.x > width) {
      this.pos.x = 0; 
    }
  }


  void display() {
    this.update();
    noStroke();
    fill(carFill);
    
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    rotate(-radians(steeringAngle));
    rect(0-(trackWidth/2), 0-wheelBase, trackWidth, wheelBase, vehicleDirection.heading());
    popMatrix();
    
  }

  void accelerate() {
    if (this.wheelSpeed < this.maxSpeed) {
      this.wheelSpeed += power/accelerationSteps;
    }
  }
  
  void brake() {
    if (this.wheelSpeed > 0) {
      this.wheelSpeed *= this.brakePower;  
    }
  }
  void steer(int dir) {
     if(dir > 0) {
       this.steeringAngle += 3*(wheelSpeed/(maxSpeed*0.5)); 
     } else if(dir < 0) {
       this.steeringAngle -= 3*(wheelSpeed/(maxSpeed*0.5)); 
     }
  }
}