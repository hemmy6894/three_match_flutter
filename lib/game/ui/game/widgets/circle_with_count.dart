import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/ui/game/character.dart';

class CircleWithCount extends StatefulWidget {
  final CharacterType? selectedHelper;
  final CharacterType characterType;
  final int count;
  final Widget? child;
  const CircleWithCount({Key? key, this.selectedHelper, required this.characterType, this.count = 0, this. child}) : super(key: key);

  @override
  State<CircleWithCount> createState() => _CircleWithCountState();
}

class _CircleWithCountState extends State<CircleWithCount> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: widget.selectedHelper == widget.characterType
              ? Colors.red
              : const Color(Assets.primaryGoldColor),
          radius: (MediaQuery.of(context).size.width / 13),
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius:
            (MediaQuery.of(context).size.width / 14.3),
            child: Image.asset(
              Assets.getCharacter(characterType: widget.characterType),
              width: (MediaQuery.of(context).size.width / 9),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: widget.count < 1 ? (widget.child??const Text("")) :  CircleAvatar(
            backgroundColor: Colors.red,
            radius: (MediaQuery.of(context).size.width / 38),
            child: Text(
              widget.count.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
