import 'package:flutter/material.dart';
import 'package:physics/particle_systems/emitter.dart';

///The Particle System class should be the class responsible for managing [Emitter]
///Objects. This allows us to follow a proper heirarchy and keeps code readable.
///Particle system manages [Emitter]s, which manage [Particle]s
///
class ParticleSystem {
  List<Emitter> emitters = [];

  Rect dragSpots = Rect.fromLTWH(100, 100, 200, 150);

  createEmitter(Offset offset) {
    emitters.add(Emitter(
      emissionPoint: offset,
      particleCount: 10,
    ));
  }

  updateEmitters() {
    if (emitters.isNotEmpty) {
      for (int i = emitters.length - 1; i >= 0; i--) {
        if (emitters[i].hasRemainingParticles) {
          emitters[i].updateParticles(dragSpots);
        } else {
          emitters.remove(emitters[i]);
        }
      }
    }
  }

  drawEmitters(Canvas canvas, Size size) {
    canvas.drawRect(dragSpots, Paint()..color = Color(0xffadee33));
    for (Emitter emitter in emitters) {
      emitter.drawParticles(canvas, size);
    }
  }
}
