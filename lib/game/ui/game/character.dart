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
  carpet
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
      required this.height})
      : super(key: key);

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  bool spaceCharacter = false;

  @override
  Widget build(BuildContext context) {
    spaceCharacter = BreakCharacter.spaceCharacter(widget.characterType);
    return Container(
      color:
          !spaceCharacter ? const Color(Assets.boardColor) : Colors.transparent,
      child: GestureDetector(
        onTap: () {
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
