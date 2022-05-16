import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/ui/game/character.dart';

class TargetWidget extends StatefulWidget {
  const TargetWidget({Key? key}) : super(key: key);

  @override
  State<TargetWidget> createState() => _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {
  List<Map<CharacterType, int>> targets = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBlock, GameState>(
      listenWhen: (p, c) => p.targets != c.targets,
      listener: (context, state) async {
        setState(() {
          targets = state.targets;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.13,
          ),
          Positioned(
            top: 5,
            left: 5,
            right: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Targets",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 23,
            bottom: 0,
            child: Container(
              margin: const EdgeInsets.all(5.0),
              child: displayTarget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayTarget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (Map<CharacterType, int> target in targets)
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    Assets.getCharacter(
                        characterType: target.entries.first.key),
                    height: 33,
                    width: 33,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: Text(
                        target.entries.first.value.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
          ],
        )
      ],
    );
  }
}
