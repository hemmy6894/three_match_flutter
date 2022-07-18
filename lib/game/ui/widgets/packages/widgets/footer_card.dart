import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';

class FooterCard extends StatelessWidget {
  final String name;
  final String price;
  final Function() click;
  const FooterCard({Key? key, this.name = Assets.swalaPackage, this.price = "", required this.click}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25 * 0.27,
      decoration: BoxDecoration(
        color: const Color(Assets.primaryGoldColor),
        borderRadius: BorderRadius.only(
          bottomLeft:
          Radius.circular(MediaQuery.of(context).size.width * 0.02),
          bottomRight:
          Radius.circular(MediaQuery.of(context).size.width * 0.02),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              name,
              width: MediaQuery.of(context).size.width * 0.5 * 0.83,
            ),
            ButtonComponent(
              title: price,
              onPressed: () {
                click();
              },
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
