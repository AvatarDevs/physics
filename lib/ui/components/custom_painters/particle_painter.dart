import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:physics/particle_systems/emitter.dart';
import 'package:physics/particle_systems/particle.dart';
import 'package:physics/particle_systems/particle_system.dart';

class ParticlePainter extends CustomPainter {
  ParticleSystem particleSystem;
  ParticlePainter(this.particleSystem, Listenable listenable)
      : super(repaint: listenable) {
    print("painter initialized");
  }
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    particleSystem.drawEmitters(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
