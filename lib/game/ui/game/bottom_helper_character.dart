import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/game/widgets/circle_with_count.dart';

class BottomHelperCharacter extends StatefulWidget {
  final CharacterType characterType;

  const BottomHelperCharacter({Key? key, required this.characterType})
      : super(key: key);

  @override
  State<BottomHelperCharacter> createState() => _BottomHelperCharacterState();
}

class _BottomHelperCharacterState extends State<BottomHelperCharacter> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<GameBlock>().add(
              GameCatchHelperEvent(
                helper: widget.characterType,
                amount: context
                    .read<UiCubit>()
                    .state
                    .getRewardCount(widget.characterType),
              ),
            );
      },
      child: BlocBuilder<GameBlock, GameState>(
        builder: (context, state) {
          CharacterType? selectedHelper = state.selectedHelper;
          return CircleWithCount(
            characterType: widget.characterType,
            selectedHelper: selectedHelper,
            count: context.read<UiCubit>().state.getRewardCount(widget.characterType),
          );
        },
      ),
    );
  }
}
