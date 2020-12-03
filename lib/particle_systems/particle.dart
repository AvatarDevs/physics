import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:physics/mixins/drawable.dart';
import 'package:vector_math/vector_math.dart';

///This class represents a single particle

class Particle with Drawable {
  ///a particle needs to know a few things about itself. Location, speed, etc.
  ///This could be represented as seperate x and y values, but its much simpler to use a Vector
  ///so that we can get common vector math functions from the vector math package
  ///
  Particle(this.location, this.velocity);

  ///current location
  Vector2 location;

  ///new location = velocity applied to current location. Velocity can be thought of as speed - rate of change of location
  Vector2 velocity;

  ///rate of change of velocity
  ///used in our case to "steer" and change velocity
  /// you can be more accurate by saying acceleration is equal to the sum of all forces divided by mass
  Vector2 acceleration = Vector2.zero();

  ///lifespan is used to determine the remaining time a particle has left to "live".
  ///Lifespan will eventually reach 0, where it should be removed from the system so the program doesn't slow down due to
  ///an obsurd amount of particles
  int lifespan = 255;

  double mass = 10;
  Color color ;

  void update() {
    velocity.add(acceleration);
    location.add(velocity);

    lifespan -= 3;
    //clear so extra forces dont accumulate
    acceleration.multiply(Vector2.zero());
  }

  void applyForce(Vector2 force) {
    //create a new variable as to not effect the original forces value
    var f = force.clone() / mass;

    acceleration.add(f);
  }

  bool get isDead => lifespan < 0;

  @override
  void draw(Canvas canvas, Size size) {
    // TODO: implement draw
    checkEdges(size);
    canvas.drawCircle(Offset(location.x, location.y), mass,
        Paint()..color = color.withAlpha(lifespan));
  }

  checkEdges(Size size) {
    //check the edges, using mass(particle radius) to give the effect of it actually bouncing off the walls
    if (location.x > size.width - mass) {
      location.x = size.width - mass;
      velocity.x *= -1;
    } else if (location.x < 0 + mass) {
      location.x = 0 + mass;
      velocity.x *= -1;
    }

    if (location.y > size.height - mass) {
      location.y = size.height - mass;
      velocity.y *= -1;
    } else if (location.y < 0 + mass) {
      location.y = 0 + mass;
      velocity.y *= -1;
    }
  }
}
