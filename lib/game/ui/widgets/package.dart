import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/layouts/app.dart';

class PackageWidget extends StatefulWidget {
  const PackageWidget({Key? key}) : super(key: key);

  @override
  State<PackageWidget> createState() => _PackageWidgetState();
}

class _PackageWidgetState extends State<PackageWidget> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width * 0.02))),
                width: MediaQuery.of(context).size.width * 0.91,
                height: MediaQuery.of(context).size.height * 0.07,
                child: Center(
                  child: Text(
                    "Shop",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.04),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width * 0.02))),
                width: MediaQuery.of(context).size.width * 0.91,
                height: MediaQuery.of(context).size.height * 0.08,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            showCharacterLarge(
                                picture: Assets.orange, times: "5"),
                            ElevatedButton(
                              onPressed: () {
                                int count = context
                                    .read<UiCubit>()
                                    .state
                                    .getRewardCount(CharacterType.coin);
                                if (count < 70) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Out of coin : Balance $count"),
                                    ),
                                  );
                                  return;
                                }
                                context
                                    .read<UiCubit>()
                                    .incrementLife(number: 5);
                                buyStack([
                                  const RewardModel(
                                      character: CharacterType.coin,
                                      amount: 0 - 70),
                                ]);
                              },
                              child: const Text("70 coin"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(
                    Radius.circular(MediaQuery.of(context).size.width * 0.02),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.91,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Giant Bundle",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.91 * 0.91,
                      height: MediaQuery.of(context).size.height * 0.25 * 0.83,
                      color: Colors.yellow,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: Image.asset(
                              Assets.orange,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 6,
                            top: 10,
                            child: Column(
                              children: [
                                showCharacterLarge(
                                    picture: Assets.coin, times: "200"),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.bomb, times: "x 18"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.hummer, times: "x 5"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.hand, times: "x 12"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.bulletVertical,
                                        times: "x 12"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    showCharacterView(
                                      picture: Assets.bulletHorizontal,
                                      times: "x 12",
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                      picture: Assets.superBomb,
                                      times: "x 12",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: ElevatedButton(
                              onPressed: () {
                                int count = context
                                    .read<UiCubit>()
                                    .state
                                    .getRewardCount(CharacterType.coin);
                                if (count < 1000) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Out of coin : Balance $count"),
                                    ),
                                  );
                                  return;
                                }
                                buyStack([
                                  const RewardModel(
                                      character: CharacterType.coin,
                                      amount: 200 - 1000),
                                  const RewardModel(
                                      character: CharacterType.bomb,
                                      amount: 18),
                                  const RewardModel(
                                      character: CharacterType.hummer,
                                      amount: 5),
                                  const RewardModel(
                                      character: CharacterType.hand,
                                      amount: 12),
                                  const RewardModel(
                                      character: CharacterType.verticalBullet,
                                      amount: 12),
                                  const RewardModel(
                                      character: CharacterType.horizontalBullet,
                                      amount: 12),
                                  const RewardModel(
                                      character: CharacterType.superBomb,
                                      amount: 12),
                                ]);
                              },
                              child: const Text("1,000 coin"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width * 0.02))),
                width: MediaQuery.of(context).size.width * 0.91,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Champion's Bundle",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.91 * 0.91,
                      height: MediaQuery.of(context).size.height * 0.25 * 0.83,
                      color: Colors.yellow,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: Image.asset(
                              Assets.banana,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 6,
                            top: 10,
                            child: Column(
                              children: [
                                showCharacterLarge(
                                    picture: Assets.coin, times: "350"),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.bomb, times: "x 18"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.hummer, times: "x 10"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.hand, times: "x 12"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.bulletVertical,
                                        times: "x 12"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.bulletHorizontal,
                                        times: "x 12"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.superBomb,
                                        times: "x 12"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("3,000 coin"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width * 0.02))),
                width: MediaQuery.of(context).size.width * 0.91,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Giant Bundle",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.91 * 0.91,
                      height: MediaQuery.of(context).size.height * 0.25 * 0.83,
                      color: Colors.yellow,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: Image.asset(
                              Assets.orange,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 6,
                            top: 10,
                            child: Column(
                              children: [
                                showCharacterLarge(
                                    picture: Assets.coin, times: "200"),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.bomb, times: "x 18"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.hummer, times: "x 5"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.hand, times: "x 12"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.bulletVertical,
                                        times: "x 12"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.bulletHorizontal,
                                        times: "x 12"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.superBomb,
                                        times: "x 12"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("1,000 coin"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width * 0.02))),
                width: MediaQuery.of(context).size.width * 0.91,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Champion's Bundle",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.91 * 0.91,
                      height: MediaQuery.of(context).size.height * 0.25 * 0.83,
                      color: Colors.yellow,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: Image.asset(
                              Assets.banana,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 6,
                            top: 10,
                            child: Column(
                              children: [
                                showCharacterLarge(
                                    picture: Assets.coin, times: "350"),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.bomb, times: "x 18"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.hummer, times: "x 10"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.hand, times: "x 12"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.bulletVertical,
                                        times: "x 12"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    showCharacterView(
                                        picture: Assets.bulletHorizontal,
                                        times: "x 12"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    showCharacterView(
                                        picture: Assets.superBomb,
                                        times: "x 12"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("3,000 coin"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width * 0.02))),
                width: MediaQuery.of(context).size.width * 0.91,
                height: MediaQuery.of(context).size.height * 0.08,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            showCharacterLarge(
                                picture: Assets.coin, times: "350"),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("3,000 coin"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width * 0.02))),
                width: MediaQuery.of(context).size.width * 0.91,
                height: MediaQuery.of(context).size.height * 0.08,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            showCharacterLarge(
                                picture: Assets.coin, times: "350"),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("3,000 coin"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width * 0.02))),
                width: MediaQuery.of(context).size.width * 0.91,
                height: MediaQuery.of(context).size.height * 0.08,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            showCharacterLarge(
                                picture: Assets.coin, times: "350"),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("3,000 coin"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showCharacterView(
      {String picture = Assets.superBomb, String times = "x 19"}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 23,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.91 * 0.15,
          alignment: Alignment.centerRight,
          child: Text(
            "$times ",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
        ),
        Positioned(
          top: -1.3,
          left: -2,
          child: Image.asset(
            picture,
            width: 23,
            height: 23,
          ),
        )
      ],
    );
  }

  showCharacterLarge(
      {String picture = Assets.superBomb, String times = "5000"}) {
    return Stack(
      children: [
        Container(height: 35),
        Container(
          width: MediaQuery.of(context).size.width * 0.91 * 0.32,
          alignment: Alignment.centerRight,
          child: Text(
            "$times  ",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Colors.grey, width: 2),
          ),
        ),
        Positioned(
          top: -5,
          left: -5,
          child: Image.asset(
            picture,
            width: 38,
            height: 38,
          ),
        )
      ],
    );
  }

  buyStack(List<RewardModel> rewards) {
    context.read<UiCubit>().receiveRewards(rewards: rewards);
    Navigator.pop(context);
  }
}
