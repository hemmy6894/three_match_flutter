import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';

class ButtonComponent extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool transparent;
  final double buttonSize;
  final int backgroundColor;
  final bool isLoading;
  final bool disabled;
  final double buttonSizeHeight;
  final IconData? buttonIcon;
  final MainAxisAlignment mainAxisAlignment;
  final TextStyle? style;

  const ButtonComponent(
      {Key? key,
      required this.title,
      this.disabled = false,
      required this.onPressed,
      this.transparent = false,
      this.isLoading = false,
      this.buttonSize = 10.0,
      this.buttonSizeHeight = 30,
      this.style,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.backgroundColor = Assets.primaryGreenColor,
      this.buttonIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasButton = false;
    if (buttonIcon != null) {
      hasButton = true;
    }
    return Container(
      margin: const EdgeInsets.all(2),
      child: ElevatedButton(
        onPressed: () => !disabled
            ? onPressed()
            : ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Button Disabled"),
                ),
              ),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            hasButton
                ? isLoading
                    ? Container(
                        padding: const EdgeInsets.all(3),
                        height: 25,
                        width: 25,
                        child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Assets.circularProgressColor),
                      )
                    : Container(
                        padding: const EdgeInsets.all(6),
                        child: Icon(buttonIcon))
                : isLoading
                    ? Container(
                        padding: const EdgeInsets.all(3),
                        height: 25,
                        width: 25,
                        child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Assets.circularProgressColor),
                      )
                    : Container(),
            !isLoading
                ? Text(
                    title,
                    style: style,
                  )
                : Container()
          ],
        ),
        style: ElevatedButton.styleFrom(
          onPrimary: transparent ? Color(backgroundColor) : Colors.white,
          primary: transparent ? Colors.white : Color(backgroundColor),
          minimumSize: Size(buttonSize, buttonSizeHeight),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          side: !transparent
              ? const BorderSide(
                  width: 0.0,
                  color: Color(Assets.primaryColor),
                )
              : BorderSide(
                  width: 2.0,
                  color: Color(backgroundColor),
                ),
        ),
      ),
    );
  }
}
