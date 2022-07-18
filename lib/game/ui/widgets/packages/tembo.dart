import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/card.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/footer_card.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/header_card.dart';

class TemboPackageWidget extends StatefulWidget {
  final Function(List<RewardModel> packages) buyStack;

  const TemboPackageWidget({Key? key, required this.buyStack}) : super(key: key);

  @override
  State<TemboPackageWidget> createState() => _TemboPackageWidgetState();
}

class _TemboPackageWidgetState extends State<TemboPackageWidget> {
  @override
  Widget build(BuildContext context) {
    return CardLayout(
      header: const HeaderCard(
        coins: Assets.coinFiftyThousandPackage,
        topBoosters: [
          {
            Assets.superBomb: Assets.timeTenPackage,
          },
          {
            Assets.bomb: Assets.timeTenPackage,
          }
        ],
        bottomBoosters: [
          {
            Assets.plane: Assets.timeTenPackage,
          },
          {
            Assets.bulletHorizontal: Assets.timeTenPackage,
          }
        ],
        topHelpers: [
          {
            Assets.hand: Assets.timeTenPackage,
          },
        ],
        bottomHelpers: [
          {
            Assets.hummer: Assets.timeTenPackage,
          }
        ],
      ),
      footer: FooterCard(
        name: Assets.temboPackage,
        price: "150,000.00 TZS",
        click: () {},
      ),
    );
  }
}
