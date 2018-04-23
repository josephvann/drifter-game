class Car {
  float power = 5.5;
  float currentPower = 3.5;
  int accelerationSteps = 12;
  int score = 0;
  int currentAccelerationSteps = 12;
  float coastCoefficient = 0.995;
  float maxSpeed = 24.0;
  float currentMaxSpeed = 24.0;
  float steeringRadius = 12.0;
  float vehicleDirection = 0.0;
  float steeringAngle = 0.0;

  float fullLock = 2.5;
  float currentGrip = 1.0;

  PVector[] corners = new PVector[4];

  // strangely, lower is better!
  float brakePower = 0.9;

  int currentGear = 0;
  float[] gearbox = new float[5];

  boolean accelerating = false;
  boolean braking = false;

  int health = 5;

  float trackWidth = 80.0;
  float wheelBase = 140.0;

  color carFill = color(188, 65, 72);

  float wheelSpeed = 0.0;

  PVector pos = new PVector(width/2, height/2);

  Car() {
    gearbox[0] = 0.25;
    gearbox[1] = 0.4;
    gearbox[2] = 0.8;
    gearbox[3] = 1.1;
    gearbox[4] = 1.5;
    this.gearChange(-1);
  }
  void update() {
    if (!this.accelerating) {
      this.wheelSpeed *= this.coastCoefficient;
    } else {
      this.accelerate();
    }
    if (this.braking) {
      this.brake();
    }

    

    this.currentGrip = (36-this.wheelSpeed)/12;

    this.vehicleDirection += this.steeringAngle*this.currentGrip;
    
    this.wheelSpeed -= abs(this.steeringAngle/0.6);
    this.pos.y -= cos(this.vehicleDirection)*this.wheelSpeed;
    this.pos.x += sin(this.vehicleDirection)*this.wheelSpeed;
    this.steeringAngle*= 0.85;
    //if (this.vehicleDirection > this.fullLock) {
    //  this.vehicleDirection = this.fullLock; 
    //}
    //if (this.vehicleDirection < -this.fullLock) {
    //  this.vehicleDirection = -this.fullLock;  
    //}
    //this.vehicleDirection *= 0.8;


    if (this.wheelSpeed > this.currentMaxSpeed) {
      this.wheelSpeed *= coastCoefficient;
    }
  }


  void display(PShape graphic) {
    this.update();
    noStroke();
    fill(carFill);
    rectMode(CENTER);
    //pushMatrix();
    //translate(width/2, height/2);
    //rotate(this.vehicleDirection);
    shapeMode(CENTER);
    shape(graphic, width/2, height/2, trackWidth, wheelBase);
    //popMatrix();
  }

  void accelerate() {
    if (this.wheelSpeed < this.currentMaxSpeed) {
      this.wheelSpeed += power/currentAccelerationSteps;
    }
  }

  void brake() {
    if (this.wheelSpeed > 0) {
      this.wheelSpeed *= this.brakePower;
    }
  }
  void steer(int dir) {
    if (dir > 0) {
      if (this.steeringAngle < this.currentGrip) {
        this.steeringAngle += 0.01 * this.wheelSpeed/this.maxSpeed;
      }
    }
    if (dir < 0) {
      if (this.steeringAngle > -this.currentGrip) {
        this.steeringAngle -= 0.01 * this.wheelSpeed/this.maxSpeed;
      }
    }
  }


  void gearChange(int dir) {
    if (dir == -1 && this.currentGear > 0) {
      this.currentGear -= 1;
    } else if (dir == 1 && this.currentGear < 4) {
      this.currentGear += 1;
    }
    this.currentPower = this.power/this.gearbox[this.currentGear];
    this.currentAccelerationSteps = int(this.accelerationSteps * 4*(this.gearbox[this.currentGear]));
    this.currentMaxSpeed = this.maxSpeed * this.gearbox[this.currentGear];
  }
}