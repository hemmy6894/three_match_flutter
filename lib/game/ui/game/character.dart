import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';

enum CharacterType {
  banana,
  apple,
  pear,
  orange,
  blueBerry,
  hole,
  space,
  bomb,
  plane,
  verticalBullet,
  horizontalBullet,
  superBomb,
  hand,
  hummer,
  boxOne,
  boxTwo,
  boxThree,
  diamondOne,
  diamondTwo,
  diamondThree,
  carpet,
  restart
}

class Character extends StatefulWidget {
  final CharacterType characterType;
  final int col;
  final int row;
  final double width;
  final double height;
  final bool active;
  final bool isObstacle;
  final bool isHelper;
  final bool asCarpet;
  final Function(double) verticalUpdate;

  const Character(
      {Key? key,
      required this.characterType,
      required this.row,
      required this.col,
      required this.width,
      required this.active,
      this.isHelper = false,
      this.isObstacle = false,
      this.asCarpet = false,
        required this.verticalUpdate,
      required this.height})
      : super(key: key);

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  bool spaceCharacter = false;
  bool left = false, right = false, up = false, down = false;
  late DragStartDetails startDrag;
  late DragUpdateDetails updateDrag;
  @override
  Widget build(BuildContext context) {
    spaceCharacter = BreakCharacter.spaceCharacter(widget.characterType);
    return Container(
      color:
          !spaceCharacter ? const Color(Assets.boardColor) : Colors.transparent,
      child: GestureDetector(
        onTap: () {

        },
        onDoubleTap: () {
          if (BreakCharacter.isBombCharacter(widget.characterType)) {
            context
                .read<GameBlock>()
                .add(GameClickCharacterEvent(row: widget.row, col: widget.col));
            context
                .read<GameBlock>()
                .add(GameClickCharacterEvent(row: widget.row, col: widget.col));
          }
        },
        onPanDown: (DragDownDetails details) {
          if (!widget.isObstacle && !widget.isHelper) {
            if (!BreakCharacter.noneBreakableCharacter(widget.characterType)) {
              context.read<GameBlock>().add(
                  GameClickCharacterEvent(row: widget.row, col: widget.col));
            }
          }
          if (widget.isObstacle) {}
          if (widget.isHelper) {
            context
                .read<GameBlock>()
                .add(GameCatchHelperEvent(helper: widget.characterType));
          }
        },
        onPanStart: (DragStartDetails start) {
          setState(() {
            startDrag = start;
          });
        },
        onPanUpdate: (DragUpdateDetails details){
          setState(() {
            updateDrag = details;
          });
        },
        onPanEnd: (DragEndDetails details) {
          int row = 0; int col = 0;
          if(updateDrag.delta.dy < -0.5 && updateDrag.delta.dy < updateDrag.delta.dx){
            if (!widget.isObstacle && !widget.isHelper) {
              row = widget.row - 1; col = widget.col;
            }
          }
          if(updateDrag.delta.dy > 0.5 && updateDrag.delta.dy > updateDrag.delta.dx){
            if (!widget.isObstacle && !widget.isHelper) {
              row = widget.row + 1; col = widget.col;
            }
          }
          if(updateDrag.delta.dx < -0.5 && updateDrag.delta.dx < updateDrag.delta.dy){
            if (!widget.isObstacle && !widget.isHelper) {
              row = widget.row; col = widget.col - 1;
            }
          }
          if(updateDrag.delta.dx > 0.5 && updateDrag.delta.dx > updateDrag.delta.dy){
            if (!widget.isObstacle && !widget.isHelper) {
              row = widget.row; col = widget.col + 1;
            }
          }
          if (!BreakCharacter.noneBreakableCharacter(getBoardCharacter(context.read<GameBlock>().state.gameBoards, row: row, col: col))) {
            context.read<GameBlock>().add(GameClickCharacterEvent(row: row, col: col));
          }
        },
        child: Container(
          decoration: !spaceCharacter
              ? BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                  image: widget.asCarpet
                      ? const DecorationImage(
                          image: AssetImage(Assets.carpet),
                        )
                      : null,
                )
              : null,
          child: Container(
            decoration: !spaceCharacter
                ? BoxDecoration(
                    color: widget.asCarpet
                        ? Colors.transparent
                        : const Color(Assets.characterColor),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6),
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                    border: widget.active
                        ? Border.all(color: Colors.red, width: 0.5)
                        : null,
                  )
                : null,
            child: Stack(
              children: [
                Image.asset(
                  Assets.getCharacter(characterType: widget.characterType),
                  width: widget.width,
                  height: widget.height,
                ),
                if (widget.isHelper)
                  if (context
                          .read<UiCubit>()
                          .state
                          .getRewardCount(widget.characterType) >
                      0)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          context
                              .read<UiCubit>()
                              .state
                              .getRewardCount(widget.characterType)
                              .toString(),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
