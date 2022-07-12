import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game/bottom_helper_character.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/game/widgets/circle_with_count.dart';

class BottomHelper extends StatefulWidget {
  final Function()? exit;
  const BottomHelper({Key? key, this.exit}) : super(key: key);
  @override
  State<BottomHelper> createState() => _BottomHelperState();
}

class _BottomHelperState extends State<BottomHelper> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.10,
            color: Colors.transparent,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.10 * 0.04,
                    color: const Color(Assets.primaryGoldColor),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.10 * 0.56,
                  color: const Color(Assets.primaryBlueColor),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 3,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const BottomHelperCharacter(characterType: CharacterType.hummer),
                const BottomHelperCharacter(characterType: CharacterType.hand),
                GestureDetector(
                  onTap: () {
                    if(widget.exit != null){
                      widget.exit!();
                    }
                  },
                  child: const CircleWithCount(characterType: CharacterType.hole,),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
