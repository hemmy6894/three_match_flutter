import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/card.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/footer_card.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/header_card.dart';

class TwigPackageWidget extends StatefulWidget {
  final Function(List<RewardModel> packages) buyStack;

  const TwigPackageWidget({Key? key, required this.buyStack}) : super(key: key);

  @override
  State<TwigPackageWidget> createState() => _TwigPackageWidgetState();
}

class _TwigPackageWidgetState extends State<TwigPackageWidget> {
  @override
  Widget build(BuildContext context) {
    return CardLayout(
      header: const HeaderCard(
        coins: Assets.coinFiveThousandPackage,
        topBoosters: [
          {
            Assets.superBomb: Assets.timeTwoPackage,
          },
          {
            Assets.bomb: Assets.timeTwoPackage,
          }
        ],
        bottomBoosters: [
          {
            Assets.plane: Assets.timeTwoPackage,
          },
          {
            Assets.bulletHorizontal: Assets.timeTwoPackage,
          }
        ],
        topHelpers: [
          {
            Assets.hand: Assets.timeTwoPackage,
          },
        ],
        bottomHelpers: [
          {
            Assets.hummer: Assets.timeTwoPackage,
          }
        ],
      ),
      footer: FooterCard(
        name: Assets.twigaPackage,
        price: "50,000.00 TZS",
        click: () {},
      ),
    );
  }
}
