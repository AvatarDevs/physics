import 'package:flutter/material.dart';
import 'package:physics/ui/components/custom_painters/particle_painter.dart';
import 'package:physics/ui/views/particles/particle_view_model.dart';
import 'package:stacked/stacked.dart';

class ParticlePaint extends ViewModelWidget<ParticleViewModel> {
  @override
  // TODO: implement reactive
  bool get reactive => false;
  @override
  Widget build(BuildContext context, model) {
    return Center(
      child: GestureDetector(
        onTapDown: model.onTapDown,
       // onPanUpdate: model.onPanDown,
        child: CustomPaint(
          child: Container(
            color: Colors.white10,
          ),
          foregroundPainter: ParticlePainter(model.particleSystem, model),
        ),
      ),
    );
  }
}
