import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/card.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/footer_card.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/header_card.dart';

class ChuiPackageWidget extends StatefulWidget {
  final Function(List<RewardModel> packages) buyStack;

  const ChuiPackageWidget({Key? key, required this.buyStack}) : super(key: key);

  @override
  State<ChuiPackageWidget> createState() => _ChuiPackageWidgetState();
}

class _ChuiPackageWidgetState extends State<ChuiPackageWidget> {
  @override
  Widget build(BuildContext context) {
    return CardLayout(
      header: const HeaderCard(
        coins: Assets.coinTenThousandPackage,
        topBoosters: [
          {
            Assets.superBomb: Assets.timeThreePackage,
          },
          {
            Assets.bomb: Assets.timeThreePackage,
          }
        ],
        bottomBoosters: [
          {
            Assets.plane: Assets.timeThreePackage,
          },
          {
            Assets.bulletHorizontal: Assets.timeThreePackage,
          }
        ],
        topHelpers: [
          {
            Assets.hand: Assets.timeThreePackage,
          },
        ],
        bottomHelpers: [
          {
            Assets.hummer: Assets.timeThreePackage,
          }
        ],
      ),
      footer: FooterCard(
        name: Assets.chuiPackage,
        price: "75,000.00 TZS",
        click: () {},
      ),
    );
  }
}
