import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isObstacle && !widget.isHelper) {
          if(!BreakCharacter.noneBreakableCharacter(widget.characterType)) {
            context
                .read<GameBlock>()
                .add(GameClickCharacterEvent(row: widget.row, col: widget.col));
          }
        }
        if (widget.isObstacle) {}
        if (widget.isHelper) {
          context
              .read<GameBlock>()
              .add(GameCatchHelperEvent(helper: widget.characterType));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          image: widget.asCarpet ? const DecorationImage(
            image: AssetImage(Assets.carpet),
          ) : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.asCarpet ? Colors.transparent : const Color(Assets.characterColor),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: widget.active
                ? Border.all(color: Colors.red, width: 0.5)
                : null,
          ),
          child: Image.asset(
            getCharacter(characterType: widget.characterType),
            width: widget.width,
            height: widget.height,
          ),
        ),
      ),
    );
  }

  String getCharacter({required CharacterType characterType}) {
    if (characterType == CharacterType.banana) {
      return Assets.banana;
    }
    if (characterType == CharacterType.apple) {
      return Assets.apple;
    }
    if (characterType == CharacterType.pear) {
      return Assets.pear;
    }
    if (characterType == CharacterType.blueBerry) {
      return Assets.blueBerry;
    }
    if (characterType == CharacterType.orange) {
      return Assets.orange;
    }
    if (characterType == CharacterType.hole) {
      return Assets.hole;
    }
    if (characterType == CharacterType.bomb) {
      return Assets.bomb;
    }
    if (characterType == CharacterType.plane) {
      return Assets.plane;
    }
    if (characterType == CharacterType.verticalBullet) {
      return Assets.bulletVertical;
    }
    if (characterType == CharacterType.horizontalBullet) {
      return Assets.bulletHorizontal;
    }
    if (characterType == CharacterType.superBomb) {
      return Assets.superBomb;
    }
    if (characterType == CharacterType.hand) {
      return Assets.hand;
    }
    if (characterType == CharacterType.hummer) {
      return Assets.hummer;
    }
    if (characterType == CharacterType.boxOne) {
      return Assets.boxOne;
    }
    if (characterType == CharacterType.boxTwo) {
      return Assets.boxTwo;
    }
    if (characterType == CharacterType.boxThree) {
      return Assets.boxThree;
    }
    if (characterType == CharacterType.diamondOne) {
      return Assets.diamondOne;
    }
    if (characterType == CharacterType.diamondTwo) {
      return Assets.diamondTwo;
    }
    if (characterType == CharacterType.diamondThree) {
      return Assets.diamondThree;
    }
    return Assets.hole;
  }
}
