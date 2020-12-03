import 'package:flutter/material.dart';

class TickerControllerContainer extends StatelessWidget {
  final Widget child;

  const TickerControllerContainer({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white30,borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }
}
