import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/ui/game/character.dart';

class MoveWidget extends StatefulWidget {
  final double height, width;
  const MoveWidget({Key? key, required this.height,required this.width}) : super(key: key);

  @override
  State<MoveWidget> createState() => _MoveWidgetState();
}

class _MoveWidgetState extends State<MoveWidget> {
  int moves = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBlock, GameState>(
      listenWhen: (p, c) => p.moves != c.moves,
      listener: (context, state) async {
        setState(() {
          moves = state.moves;
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
            width: widget.width,
            height: widget.height * 0.13,
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
                "Moves",
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
              alignment: Alignment.center,
              margin: const EdgeInsets.all(5.0),
              child: displayMove(),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayMove() {
    return Center(
      child: Text(
        moves.toString(),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: widget.width * 0.14,
        ),
      ),
    );
  }
}
