import 'dart:math';

import 'package:flutter/material.dart';
import 'package:physics/particle_systems/particle.dart';
import 'package:vector_math/vector_math.dart';

/// Typical particle systems involve something called an emitter.
/// The emitter is the source of the particles and controls the initial settings for the particles, location, velocity, etc.
/// An emitter might emit a single burst of particles, or a continuous stream of particles, or both.
/// The point is that for a typical implementation such as this, a particle is born at the emitter but does not live forever.
/// If it were to live forever, our program would eventually grind to a halt as the number of particles increased to an unwieldy number over time.
/// As new particles are born, we need old particles to die.
/// This creates the illusion of an infinite stream of particles, and the performance of our program does not suffer.
///
class Emitter {
  Offset emissionPoint;

  int particleCount;

  List<Particle> particles = [];

  Vector2 environmentGravity = Vector2(0, 1);
  double attractionPointMass = 50;
  Random ran = Random();

  Emitter({this.emissionPoint, this.particleCount}) {
    emissionPoint = emissionPoint;
    for (int i = 0; i < particleCount; i++) {
      particles.add(
        Particle(
          Vector2(
            emissionPoint.dx+100,
            emissionPoint.dy+100,
          ),
          getRandomVelocity(),
        )
          ..mass = numInRange(5, 20).toDouble()
          ..color =
              ran.nextDouble() < .1 ? Color(0xffD4A1FF) : Color(0xffffffff),
      );
    }
  }

  updateParticles(Rect rect) {
    
    for (Particle particle in particles) {
      double g = particle.mass * .4;

      particle.applyFriction(.1, 1);
      // particle.applyForce(environmentGravity..y = g);
      if (particle.isInside(rect)) {
        particle.applyDrag(.8);
      }
      particle.applyGravitationalAttraction(
          Vector2(emissionPoint.dx, emissionPoint.dy), attractionPointMass);
      
      particle.update();
    }
  }

  drawParticles(Canvas canvas, Size size) {
    drawAttractionPoint(canvas);
    if (particles.isNotEmpty) {
      for (int i = particles.length - 1; i >= 0; i--) {
        if (particles[i].isDead) {
          particles.remove(particles[i]);
        } else {
          particles[i].draw(canvas, size);
        }
      }
    }
  }

  drawAttractionPoint(Canvas canvas) {
    canvas.drawCircle(
        emissionPoint, attractionPointMass, Paint()..color = Color(0xff3f34f4));
  }

  getRandomVelocity() {
    return Vector2(numInRange(-2, 3).toDouble(), numInRange(-2, 3).toDouble());
  }

  /// Generates a positive random integer uniformly distributed on the range
  /// from [min], inclusive, to [max], exclusive. keep in mind the EXCLUSIVE part. for a number in range of -2,2 -
  /// you should call this function with 1 number higher than your desired max. -2,3

  int numInRange(int min, int max) => min + (Random().nextInt(max - min));

  bool get hasRemainingParticles => particles.length > 0;
}
