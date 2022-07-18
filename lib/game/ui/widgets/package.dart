import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/layouts/app.dart';
import 'package:test_game/game/ui/levels/widget/life_count.dart';
import 'package:test_game/game/ui/widgets/packages/chui.dart';
import 'package:test_game/game/ui/widgets/packages/simba.dart';
import 'package:test_game/game/ui/widgets/packages/swala.dart';
import 'package:test_game/game/ui/widgets/packages/tembo.dart';
import 'package:test_game/game/ui/widgets/packages/twiga.dart';

class PackageWidget extends StatefulWidget {
  const PackageWidget({Key? key}) : super(key: key);

  @override
  State<PackageWidget> createState() => _PackageWidgetState();
}

class _PackageWidgetState extends State<PackageWidget> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: const Color(Assets.primaryBlueColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BlocBuilder<UiCubit, UiState>(
                      buildWhen: (previous, current) =>
                      previous.rewards != current.rewards,
                      builder: (context, state) {
                        return Character(
                          characterType: CharacterType.coin,
                          row: 100,
                          active: false,
                          col: 100,
                          verticalUpdate: (d) {},
                          isHelper: true,
                          isObstacle: true,
                          isCoin: true,
                          hasBackGround: false,
                          height: 30,
                          width: 30,
                        );
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 90,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            Assets.shopWhiteWord,
                            width: MediaQuery.of(context).size.width * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    const CloseButton(
                      color: Colors.red,
                    )
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 5,
                  color: const Color(Assets.primaryGoldColor),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.01,
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: Colors.amber[200],
                    //       borderRadius: BorderRadius.all(Radius.circular(
                    //           MediaQuery.of(context).size.width * 0.02))),
                    //   width: MediaQuery.of(context).size.width * 0.91,
                    //   height: MediaQuery.of(context).size.height * 0.08,
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 8),
                    //     child: Center(
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               showCharacterLarge(
                    //                   picture: Assets.orange, times: "5"),
                    //               ElevatedButton(
                    //                 onPressed: () {
                    //                   int count = context
                    //                       .read<UiCubit>()
                    //                       .state
                    //                       .getRewardCount(CharacterType.coin);
                    //                   if (count < 70) {
                    //                     ScaffoldMessenger.of(context)
                    //                         .showSnackBar(
                    //                       SnackBar(
                    //                         content: Text(
                    //                             "Out of coin : Balance $count"),
                    //                       ),
                    //                     );
                    //                     return;
                    //                   }
                    //                   context
                    //                       .read<UiCubit>()
                    //                       .incrementLife(number: 5);
                    //                   buyStack([
                    //                     const RewardModel(
                    //                         character: CharacterType.coin,
                    //                         amount: 0 - 70),
                    //                   ]);
                    //                 },
                    //                 child: const Text("70 coin"),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    SwalaPackageWidget(buyStack: buyStack,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    TwigPackageWidget(buyStack: buyStack),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    ChuiPackageWidget(buyStack: buyStack),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    SimbaPackageWidget(buyStack: buyStack),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    TemboPackageWidget(buyStack: buyStack),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buyStack(List<RewardModel> rewards) {
    context.read<UiCubit>().receiveRewards(rewards: rewards);
    Navigator.pop(context);
  }
}
