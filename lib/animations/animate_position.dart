import 'package:flutter/material.dart';

class Position {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? height;
  final double? width;

  const Position({this.top,this.left,this.right,this.bottom,this.height,this.width});

  // Position operator *(double operand) => Position(top: (top??0) * operand, bottom: (bottom??0) * operand, left: (left??0) * operand, right: (right??0) * operand, width: (width??0) * operand, height: (height??0) * operand);
  //
  // static Position? lerp(Position? a, Position? b, double t) {
  //   assert(t != null);
  //   if (b == null) {
  //     if (a == null) {
  //       return null;
  //     } else {
  //       return a * (1.0 - t);
  //     }
  //   } else {
  //     if (a == null) {
  //       return b * t;
  //     } else {
  //       return Position(top: _lerpDouble(a.top??0, b.top??0, t),bottom: _lerpDouble(a.bottom??0, b.bottom??0, t), left: _lerpDouble(a.left??0, b.left??0, t), right: _lerpDouble(a.right??0, b.right??0, t), width: _lerpDouble(a.width??0, b.width??0, t), height: _lerpDouble(a.height??0, b.height??0, t));
  //     }
  //   }
  // }
  //
  // static double _lerpDouble(double a, double b, double t) {
  //   return a * (1.0 - t) + b * t;
  // }
}
class MojaPositionAnimation extends StatefulWidget {
  final double beginPosition;
  final double endPosition;
  final Position position;
  final int duration;
  final Widget child;

  const MojaPositionAnimation(
      {Key? key,
      required this.beginPosition,
      required this.endPosition,
      required this.position,
      required this.child,
      this.duration = 750})
      : super(key: key);

  @override
  State<MojaPositionAnimation> createState() => _MojaPositionAnimationState();
}

class _MojaPositionAnimationState extends State<MojaPositionAnimation> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      child: widget.child,
      tween: Tween<double>(
          begin: widget.beginPosition, end: widget.endPosition),
      duration: Duration(seconds: widget.duration),
      builder: (_, double? position, Widget? childWidget) {
        return Positioned(
          child: childWidget ?? Container(),
          top: widget.position.top ?? (widget.position.top??1) * (position??1),
          left: widget.position.left,
          right: widget.position.right,
          bottom: widget.position.bottom,
        );
      },
    );
  }
}
