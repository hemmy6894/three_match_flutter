import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/card.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/footer_card.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/header_card.dart';

class SimbaPackageWidget extends StatefulWidget {
  final Function(List<RewardModel> packages) buyStack;

  const SimbaPackageWidget({Key? key, required this.buyStack}) : super(key: key);

  @override
  State<SimbaPackageWidget> createState() => _SimbaPackageWidgetState();
}

class _SimbaPackageWidgetState extends State<SimbaPackageWidget> {
  @override
  Widget build(BuildContext context) {
    return CardLayout(
      header: const HeaderCard(
        coins: Assets.coinTwentySevenThousandPackage,
        topBoosters: [
          {
            Assets.superBomb: Assets.timeFourPackage,
          },
          {
            Assets.bomb: Assets.timeFourPackage,
          }
        ],
        bottomBoosters: [
          {
            Assets.plane: Assets.timeFourPackage,
          },
          {
            Assets.bulletHorizontal: Assets.timeFourPackage,
          }
        ],
        topHelpers: [
          {
            Assets.hand: Assets.timeFourPackage,
          },
        ],
        bottomHelpers: [
          {
            Assets.hummer: Assets.timeFourPackage,
          }
        ],
      ),
      footer: FooterCard(
        name: Assets.simbaPackage,
        price: "100,000.00 TZS",
        click: () {},
      ),
    );
  }
}
