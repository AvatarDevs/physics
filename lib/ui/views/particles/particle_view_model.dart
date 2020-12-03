import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:physics/particle_systems/emitter.dart';
import 'package:physics/particle_systems/particle.dart';
import 'package:physics/particle_systems/particle_system.dart';
import 'package:stacked/stacked.dart';
import 'package:vector_math/vector_math.dart';

class ParticleViewModel extends BaseViewModel {
  Ticker ticker;

  ParticleSystem particleSystem = ParticleSystem();

  ParticleViewModel() {
    ticker = Ticker(onTickerTick);
    ticker.start();
  }
  update() {
    particleSystem.updateEmitters();
    notifyListeners();
  }

  onTapDown(TapDownDetails details) {
    particleSystem.createEmitter(details.localPosition);
    notifyListeners();
  }

  onTickerTick(Duration duration) {
    update();
  }

  onTickerControllerButtonPress() {
    if (!isTickerRunning) {
      ticker.start();
    } else {
      ticker.stop();
    }
    notifyListeners();
  }

  bool get isTickerRunning => ticker.isTicking;

  @override
  void dispose() {
    // TODO: implement dispose
    print("disposed");
    ticker.dispose();
    super.dispose();
  }

  void onPanDown(DragUpdateDetails details) {
    particleSystem.createEmitter(details.localPosition);
    notifyListeners();
  }
}
