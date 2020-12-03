import 'package:flutter/material.dart';
import 'package:physics/ui/components/custom_painters/particle_paint.dart';
import 'package:physics/ui/components/custom_painters/particle_painter.dart';
import 'package:physics/ui/components/particle_view/particle_ticker_controller_button.dart';
import 'package:physics/ui/views/particles/particle_view_model.dart';
import 'package:stacked/stacked.dart';

class ParticleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ParticleViewModel>.nonReactive(
      viewModelBuilder: () => ParticleViewModel(),
      builder: (context, model, child) => Stack(children: [
        ParticlePaint(),
        ParticleTickerControllerButton(),
      ]),
    );
  }
}
