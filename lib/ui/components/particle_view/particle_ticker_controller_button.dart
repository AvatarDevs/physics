import 'package:flutter/material.dart';
import 'package:physics/ui/components/particle_view/ticker_controller_container.dart';
import 'package:physics/ui/views/particles/particle_view_model.dart';
import 'package:stacked/stacked.dart';

class ParticleTickerControllerButton
    extends ViewModelWidget<ParticleViewModel> {
  @override
  Widget build(BuildContext context, model) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(100.0),
        child: TickerControllerContainer(
                  child: IconButton(
            icon: Icon(model.isTickerRunning ? Icons.pause : Icons.play_arrow,color: Colors.white,),
            onPressed: model.onTickerControllerButtonPress,
          ),
        ),
      ),
    );
  }
}
