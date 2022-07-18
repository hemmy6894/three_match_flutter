import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/ui/game/character.dart';

class PackageCircleWithCount extends StatefulWidget {
  final String character;
  final String times;
  const PackageCircleWithCount({Key? key, required this.character, this.times = Assets.hole}) : super(key: key);

  @override
  State<PackageCircleWithCount> createState() => _PackageCircleWithCountState();
}

class _PackageCircleWithCountState extends State<PackageCircleWithCount> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: (MediaQuery.of(context).size.width / 16),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: (MediaQuery.of(context).size.width / 15),
            child: Image.asset(
              widget.character,
              width: (MediaQuery.of(context).size.width / 9.5),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: (MediaQuery.of(context).size.width / 30),
            child: Image.asset(
              widget.times,
              width: (MediaQuery.of(context).size.width / 22),
            ),
          ),
        )
      ],
    );
  }
}
