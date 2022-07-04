import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/position.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';

class BlastPopUp extends StatefulWidget {
  final double width;

  const BlastPopUp({Key? key, required this.width}) : super(key: key);

  @override
  State<BlastPopUp> createState() => _BlastPopUpState();
}

class _BlastPopUpState extends State<BlastPopUp> {
  int row = 9;
  int col = 0;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GameBlock, GameState>(
          listenWhen: (previous, current) =>
              previous.superBombBlast != current.superBombBlast &&
              current.superBombBlast != PositionModel.empty(),
          listener: (context, state) async {
            if (state.superBombBlast != const PositionModel(row: -5, col: -5)) {
              setState(() {
                PositionModel position = state.superBombBlast;
                row = state.row; // state.row;
                col = position.col - 1; // state.col - 1;
                show = true;
              });
              await Future.delayed(
                const Duration(
                  seconds: 2,
                ),
              );
              context.read<GameBlock>().add(ClearBlastEvent(
                  superBombBlast: const PositionModel(row: -5, col: -5)));
            } else {
              setState(() {
                show = false;
              });
            }
          },
        ),
      ],
      child: !show
          ? Container()
          : Positioned(
              left: widget.width / (row / col),
              top: widget.width / (row / (col + 2)),
              child: Image.asset(
                Assets.superBombBlast,
                width: (widget.width / row) * 3,
              ),
            ),
    );
  }
}
