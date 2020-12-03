import 'package:flutter/material.dart';
import 'package:physics/particle_systems/emitter.dart';

///The Particle System class should be the class responsible for managing [Emitter]
///Objects. This allows us to follow a proper heirarchy and keeps code readable.
///Particle system manages [Emitter]s, which manage [Particle]s
///
class ParticleSystem {
  List<Emitter> emitters = [];

  createEmitter(Offset offset) {
    emitters.add(Emitter(
      emissionPoint: offset,
      particleCount: 10,
    ));
  }

  updateEmitters() {
    if(emitters.isNotEmpty){
      for (int i = emitters.length-1; i >= 0;i--) {
      if (emitters[i].hasRemainingParticles) {
        print("Emitters Remaining: ${emitters.length}");
        emitters[i].updateParticles();
      } else {
        emitters.remove(emitters[i]);
      }
    }
    }
  }

  drawEmitters(Canvas canvas, Size size) {
    for (Emitter emitter in emitters) {
      emitter.drawParticles(canvas, size);
    }
  }
}
