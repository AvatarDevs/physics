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

  ///a location is simply a single point. It doesn't define movement across a plane
  ///you need some other (Vector "velocity")force ADDED to [location](over time) to simulate motion
  Vector2 location;

  ///Velocity is ADDED to current coordinates to create the new position. Add over time to simulate motion
  ///[velocity] is the rate of change of location
  Vector2 velocity;

  ///acceleration does not merely refer to the speeding up or slowing down of a moving object,
  ///but rather any change in velocity in either magnitude or direction.
  ///Acceleration is used to steer an object and should? be added to velocity.
  ///[acceleration] is the rate of change of velocity.
  /// you can be more accurate by saying acceleration is equal to the sum of all forces divided by mass
  Vector2 acceleration = Vector2.zero();

  ///lifespan is used to determine the remaining time a particle has left to "live".
  ///Lifespan will eventually reach 0, where it should be removed from the system so the program doesn't slow down due to
  ///an obsurd amount of particles
  int lifespan = 255;

  double mass = 10;
  Color color;

  ///applies friction to [acceleration]
  ///friction is an opposite force to velocity -described as a "Dissipative force"
  ///F = -1*u*N*v^
  ///
  ///*u(coefficient of friction,i.e ice has a lower value than sandpaper )
  ///
  ///*N(the normal force - newtons 3rd law - vehicle pushes against road with Gravity, road pushes back with N)
  /// the object is moving along a surface at an angle, computing the normal force
  /// is a bit more complicated because it doesn’t point in the same direction as gravity.
  /// We’ll need to know something about angles and trigonometry later.
  ///
  ///*velocity(normalized velocity ie- the unit vector for the velocity)
  ///
  ///this should be used for friction that is NOT air or fluid resistance
  ///
  void applyFriction(double coefficientOfFriction, double normalForce) {
    double frictionMag = coefficientOfFriction * normalForce;
    Vector2 friction = velocity.clone();
    friction *= -1;
    friction.normalize();
    friction *= frictionMag;
    applyForce(friction);
  }

  /// applies drag to [acceleration]
  /// air and fluid resistance Friction also occurs when a body passes through a liquid or gas(air).
  /// viscous force, drag force, fluid resistance. While the result is ultimately the same as our previous
  /// friction example (the object slows down),
  /// the way in which we calculate a drag force will be slightly different. Let’s look at the formula:
  /// Fd=−(1/2)p(v²) (ACᵈ) v^
  ///
  /// - Fd : Force of drag -the vector we ultimately want to compute and pass into our applyForce() function.
  ///
  /// - (-1/2) is a constant: -0.5. This is fairly irrelevant in terms of our world,
  /// as we will be making up values for other constants anyway. However, the fact that it is negative is important,
  /// as it tells us that the force is in the opposite direction of velocity (just as with friction).
  ///
  /// - ρ  is the Greek letter rho, and refers to the density of the liquid, something we don’t need to worry about.
  /// We can simplify the problem and consider this to have a constant value of 1.
  ///
  /// - v²  refers to the speed of the object moving.
  /// The object’s speed is the magnitude of the velocity vector: velocity.magnitude(). And v2 just means v squared or v * v.
  ///
  /// - A refers to the frontal area of the object that is pushing through the liquid (or gas). An aerodynamic Lamborghini, for example,
  /// will experience less air resistance than a boxy Volvo. Nevertheless, for a basic simulation, we can consider our object to be spherical and ignore this element.
  ///
  /// - Cd  is the coefficient of drag, exactly the same as the coefficient of friction (u). This is a constant we’ll determine based on whether we want the drag force to be strong or weak.
  ///
  /// - v^ This refers to the velocity unit vector, i.e. velocity.normalize(). Just like with friction, drag is a force that points in the opposite direction of velocity.
  ///
  /// now after removing the elements we don't want we have:
  /// Force of drag = v²*Cd*v^*-1
  ///

  ///apply drag of [substance] to [this]
  void applyDrag(double substance) {
    var coefficient =
        substance; //coefficient should come from the substance, but no substance class exists yet so its a static value

    var dragMagnitude = coefficient * velocity.length2;

    Vector2 drag = velocity.clone();
    drag *= -1;

    drag.normalize();
    drag *= dragMagnitude;
    applyForce(drag);
  }

  /// force of gravitational attraction
  /// F = (Gm₁m₂)/r²*r^
  ///
  /// F refers to the gravitational force, the vector we ultimately want to compute and pass into our applyForce() function.
  ///
  /// G is the universal gravitational constant, which in our world equals 6.67428 x 10-11 meters cubed per kilogram per second squared.
  /// This is a pretty important number if your name is Isaac Newton or Albert Einstein.
  /// It’s not an important number if you are a Processing programmer.
  /// Again, it’s a constant that we can use to make the forces in our world weaker or stronger.
  /// Just making it equal to one and ignoring it isn’t such a terrible choice either.
  ///
  /// m1 and m2 are the masses of objects 1 and 2. As we saw with Newton’s second law (F→=M×A→), mass is also something we could choose to ignore.
  /// After all, shapes drawn on the screen don’t actually have a physical mass.
  /// However, if we keep these values, we can create more interesting simulations in which “bigger” objects exert a stronger gravitational force than smaller ones.
  ///
  /// r^ refers to the unit vector pointing from object 1 to object 2.
  /// As we’ll see in a moment, we can compute this direction vector by subtracting the location of one object from the other.
  ///
  /// r2 refers to the distance between the two objects squared. Let’s take a moment to think about this a bit more.
  /// With everything on the top of the formula—G, m1, m2—the bigger its value, the stronger the force. Big mass, big force.
  /// Big G, big force. Now, when we divide by something, we have the opposite.
  /// The strength of the force is inversely proportional to the distance squared.
  /// The farther away an object is, the weaker the force; the closer, the stronger.
  ///
  void applyGravitationalAttraction(Vector2 offset, double mass2) {
    if (!offset.isNaN) {
      double g = .4;
      Vector2 directionToMove = offset - location;

      double distance = directionToMove.length;
      double min = 5;
      double max = 25;
      if (distance < min) {
        distance = min;
      } else if (distance > max) {
        distance = max;
      }
      directionToMove.normalize();

      //compute the magnitude at which to move
      double m = (g*mass * mass2) / (distance * distance);

      directionToMove *= m;

      applyForce(directionToMove);
    }
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);

    lifespan -= 1;
    //clear so extra forces dont accumulate
    acceleration.multiply(Vector2.zero());
  }

  void applyForce(Vector2 force) {
    //create a new variable as to not effect the original forces value
    var f = force.clone() / mass;

    acceleration.add(f);
  }

  bool get isDead => lifespan <= 0;

  Paint paint = Paint();

  @override
  void draw(Canvas canvas, Size size) {
    // TODO: implement draw
    checkEdges(size);
    canvas.drawCircle(offset, mass, paint..color = color.withAlpha(lifespan));
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

  bool isInside(Rect rect) {
    if (rect.contains(offset)) {
      return true;
    } else {
      return false;
    }
  }

  ///get the x&y as an offset to make it easier to work with in painter
  Offset get offset => Offset(this.location.x, this.location.y);
}
