import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';

class CardLayout extends StatelessWidget {
  final Widget? footer;
  final Widget? header;
  const CardLayout({Key? key, this.footer, this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(Assets.primaryPackageBackgroundColor),
        borderRadius: BorderRadius.all(
          Radius.circular(MediaQuery.of(context).size.width * 0.02),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.91,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            header ?? Container(),
            footer ?? Container(),
          ],
        ),
      ),
    );
  }
}
