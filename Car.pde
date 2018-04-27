
class Car {
  float power = 12.0;
  float currentPower = 3.5;
  int accelerationSteps = 8;
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

  // strangely, lower is better!
  float brakePower = 0.85;

  int currentGear = 0;
  float[] gearbox = new float[6];

  boolean accelerating = false;
  boolean braking = false;
  boolean reversing = false;

  float health = 100;

  float trackWidth = 80.0;
  float wheelBase = 140.0;


  // collision detection variables
  // fl, fr, rl, rr
  PVector[] corners = new PVector[4];
  // pythagoras to find distance from centre of car to corner
  float centreToCorner = sqrt(pow(trackWidth/2, 2)+pow(wheelBase/2, 2));
  // to work out the angle of the diagonals
  float cornerTheta = asin((wheelBase/2)/centreToCorner);
  PVector bTopLeft = new PVector(0, 0);
  PVector bBottomRight = new PVector(0, 0);
  boolean crashed = false;
  int crashedCorner = 0;
  float bumperBounceCoefficient = 0.5;
  float vehicleCrashAngleDifference = 0.0;
  int framesToCorrect = 30;
  float headOnCollisionThreshold = PI/2.5;
  float repulsionDirection;
  // end of collision detection variables


  color carFill = color(188, 65, 72);

  float wheelSpeed = 0.0;
  // need to put pos in the constructor so that track can move car without fucking up obstacles and grid markers.
  PVector pos = new PVector(width/2, height/2);

  Car() {
    gearbox[0] = 0.5;
    gearbox[1] = 0.8;
    gearbox[2] = 1.1;
    gearbox[3] = 1.5;
    gearbox[4] = 1.9;
    gearbox[5] = 2.2;
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

    this.currentGrip = (55-this.wheelSpeed)/25;

    this.vehicleDirection += this.steeringAngle*this.currentGrip;

    this.wheelSpeed -= abs(this.steeringAngle/1.2);
    this.pos.y -= cos(this.vehicleDirection)*this.wheelSpeed;
    this.pos.x += sin(this.vehicleDirection)*this.wheelSpeed;
    this.steeringAngle*= 0.9;

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
    if (abs(this.wheelSpeed) < this.currentMaxSpeed) {
      if (!this.reversing) {

        this.wheelSpeed += this.currentPower/this.currentAccelerationSteps;
      } else {
        if (this.wheelSpeed < 0) {
          this.brake();
        }
        this.wheelSpeed -= this.currentPower/this.currentAccelerationSteps;
      }
    }
  }

  void brake() {

    this.wheelSpeed *= this.brakePower;
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
    } else if (dir == 1 && this.currentGear < 5) {
      this.currentGear += 1;
    }
    this.currentPower = this.power/this.gearbox[this.currentGear];
    this.currentMaxSpeed = this.maxSpeed * this.gearbox[this.currentGear];
    this.currentAccelerationSteps = int(this.accelerationSteps * 4*(this.gearbox[this.currentGear]));
  }

  void checkCorners() {
    // finds where the corners are in relation to the centre of the car for collision detection.
    // fl, fr, rl, rr
    this.corners[0] = PVector.fromAngle(this.vehicleDirection + PI + this.cornerTheta);
    this.corners[1] = PVector.fromAngle(this.vehicleDirection - this.cornerTheta);
    this.corners[2] = PVector.fromAngle(this.vehicleDirection + PI - this.cornerTheta);
    this.corners[3] = PVector.fromAngle(this.vehicleDirection + this.cornerTheta);

    for (PVector c : corners) {
      c.mult(this.centreToCorner);
    }
  }

  void checkCollision(Block b) {

    this.bTopLeft.x = b.relativePos.x;
    this.bTopLeft.y = b.relativePos.y;
    this.bBottomRight.x = b.relativePos.x + (b.size.x);
    this.bBottomRight.y = b.relativePos.y + (b.size.y);

    for (int i = 0; i < 3; i++) {
      if (corners[i].x > this.bTopLeft.x && 
        corners[i].x < this.bBottomRight.x &&
        corners[i].y > this.bTopLeft.y &&
        corners[i].y < this.bBottomRight.y) {

        this.crashedCorner = i;
        this.repel(corners[i]);
        break;
      }
    }
  }

  void repel(PVector corner) {
    
    this.repulsionDirection = PVector.angleBetween(corner, this.pos);
    //this.applyForce(PVector.fromAngle(repulsionDirection).mult(this.wheelSpeed/2));

    this.vehicleCrashAngleDifference = ((repulsionDirection - PI) - this.vehicleDirection);
    println(abs(this.vehicleCrashAngleDifference));

    // this is a front corner striking.
    // this is a front corner striking.
    if (this.crashedCorner == 0 || this.crashedCorner == 1) {
      if (this.crashedCorner == 0) {
        this.vehicleDirection += this.cornerTheta / this.framesToCorrect;
      }
      if (this.crashedCorner == 1) {
        this.vehicleDirection -= this.cornerTheta / this.framesToCorrect;
      }
      this.wheelSpeed -= wheelSpeed / 3;
    } else {
      if (this.crashedCorner == 2) {
        // rear left corner
        this.vehicleDirection -= this.cornerTheta / (this.framesToCorrect * 3);
      } else if (this.crashedCorner == 3) {
        // rear right corner
        this.vehicleDirection += this.cornerTheta / (this.framesToCorrect * 3);
      }
      this.wheelSpeed -= this.wheelSpeed / 3;
    }
    //if (this.repulsionDirection > this.headOnCollisionThreshold) {
      //this.wheelSpeed = -(this.wheelSpeed * sin(repulsionDirection));  
    //}
    
  }

  void applyForce(PVector force) {
    this.pos.sub(force);
  }
}