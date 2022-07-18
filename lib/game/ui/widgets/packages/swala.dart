import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/card.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/footer_card.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/header_card.dart';

class SwalaPackageWidget extends StatefulWidget {
  final Function(List<RewardModel> packages) buyStack;
  final int credit;
  const SwalaPackageWidget({Key? key, required this.buyStack, this.credit = 3000})
      : super(key: key);

  @override
  State<SwalaPackageWidget> createState() => _SwalaPackageWidgetState();
}

class _SwalaPackageWidgetState extends State<SwalaPackageWidget> {
  List<RewardModel> rewards = [];

  @override
  void initState() {
    rewards.add(const RewardModel(character: CharacterType.superBomb, amount: 1));
    rewards.add(const RewardModel(character: CharacterType.bomb, amount: 1));
    rewards.add(const RewardModel(character: CharacterType.plane, amount: 1));
    rewards.add(const RewardModel(character: CharacterType.horizontalBullet, amount: 1));
    rewards.add(const RewardModel(character: CharacterType.hand, amount: 1));
    rewards.add(const RewardModel(character: CharacterType.hummer, amount: 1));
    rewards.add(RewardModel(character: CharacterType.coin, amount: (2000 - widget.credit)));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CardLayout(
      header: const HeaderCard(
        coins: Assets.coinTwoThousandPackage,
        topBoosters: [
          {
            Assets.superBomb: Assets.timeOnePackage,
          },
          {
            Assets.bomb: Assets.timeOnePackage,
          }
        ],
        bottomBoosters: [
          {
            Assets.plane: Assets.timeOnePackage,
          },
          {
            Assets.bulletHorizontal: Assets.timeOnePackage,
          }
        ],
        topHelpers: [
          {
            Assets.hand: Assets.timeOnePackage,
          },
        ],
        bottomHelpers: [
          {
            Assets.hummer: Assets.timeOnePackage,
          }
        ],
      ),
      footer: FooterCard(
        name: Assets.swalaPackage,
        price: "26,000.00 TZS",
        click: () {
          int count = context.read<UiCubit>().state.getRewardCount(CharacterType.coin);
          if(widget.credit > count){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Out of coin : Balance $count"),
              ),
            );
            return;
          }
          widget.buyStack(rewards);
        },
      ),
    );
  }
}
