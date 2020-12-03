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

  Vector2 gravity = Vector2(0, 1);
  Random ran = Random();

  Emitter({this.emissionPoint, this.particleCount}) {
    for (int i = 0; i < particleCount; i++) {
      particles.add(
        Particle(
          Vector2(
            emissionPoint.dx,
            emissionPoint.dy,
          ),
          getRandomVelocity(),
        )..color =
            ran.nextDouble() < .1 ? Color(0xffD4A1FF) : Color(0xffffffff),
      );
    }
  }

  updateParticles() {
    for (Particle particle in particles) {
      //particle.applyForce(gravity);
      particle.update();
    }
  }

  drawParticles(Canvas canvas, Size size) {
    if (particles.isNotEmpty) {
      for (int i = particles.length-1; i >= 0; i--) {
        if (particles[i].isDead) {
          particles.remove(particles[i]);
        } else {
          particles[i].draw(canvas, size);
        }
      }
    }
  }

  getRandomVelocity() {
    double max = 5;
    double min = -5;
    return Vector2(min + ran.nextDouble() * (max - min),
        min + ran.nextDouble() * (max - min));
  }

  bool get hasRemainingParticles => particles.length > 0;
}
