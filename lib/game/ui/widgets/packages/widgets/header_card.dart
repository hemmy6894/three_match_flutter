import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/ui/widgets/packages/widgets/circle_with_count.dart';

class HeaderCard extends StatelessWidget {
  final String coins;
  final String banner;
  final List<Map<String,String>> topBoosters;
  final List<Map<String,String>> bottomBoosters;
  final List<Map<String,String>> topHelpers;
  final List<Map<String,String>> bottomHelpers;

  const HeaderCard({
    Key? key,
    this.coins = Assets.coinTwoThousandPackage,
    this.banner = Assets.coinBagPackage,
    this.topBoosters = const [],
    this.bottomBoosters = const [],
    this.topHelpers = const [],
    this.bottomHelpers = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.02),
          topRight: Radius.circular(MediaQuery.of(context).size.width * 0.02),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25 * 0.63,
        decoration: BoxDecoration(
          color: const Color(Assets.primaryGoldColor).withOpacity(0.7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.02),
            topRight: Radius.circular(MediaQuery.of(context).size.width * 0.02),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    banner,
                    height:
                        MediaQuery.of(context).size.height * 0.25 * 0.63 * 0.73,
                  ),
                  Image.asset(
                    coins,
                    height:
                        MediaQuery.of(context).size.height * 0.25 * 0.63 * 0.22,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(MediaQuery.of(context).size.width * 0.03),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         for(Map<dynamic,dynamic> top in topBoosters)
                           PackageCircleWithCount(
                             character: top.entries.first.key,
                             times: top.entries.first.value,
                           ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for(Map<dynamic,dynamic> bottom in bottomBoosters)
                            PackageCircleWithCount(
                              character: bottom.entries.first.key,
                              times: bottom.entries.first.value,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(MediaQuery.of(context).size.width * 0.03),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for(Map<dynamic,dynamic> top in topHelpers)
                            PackageCircleWithCount(
                              character: top.entries.first.key,
                              times: top.entries.first.value,
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for(Map<dynamic,dynamic> bottom in bottomHelpers)
                            PackageCircleWithCount(
                              character: bottom.entries.first.key,
                              times: bottom.entries.first.value,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
