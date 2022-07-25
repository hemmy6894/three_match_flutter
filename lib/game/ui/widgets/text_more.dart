import 'package:flutter/material.dart';
import 'package:test_game/common/helpers/three.dart';

class TextWithMore extends StatefulWidget {
  final int displayTextCount;
  final String text;
  final TextStyle? style;
  final TextStyle? moreStyle;
  final String moreText;
  const TextWithMore({Key? key,required this.text, this.displayTextCount = 100, this.style, this.moreStyle, this.moreText =" more"}) : super(key: key);

  @override
  State<TextWithMore> createState() => _TextWithMoreState();
}

class _TextWithMoreState extends State<TextWithMore> {
  int displayCount = 0;

  @override
  void initState() {
    displayCount = widget.displayTextCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          if(widget.text.length > displayCount) {
            displayCount = widget.text.length;
          }else{
            displayCount = widget.displayTextCount;
          }
        });
      },
      child: RichText(
        text: TextSpan(
          text: ThreeMatchHelper.textCut(
              text: widget.text, from: 0, to: displayCount),
          style: widget.style,
          children: [
            widget.text.length > displayCount
                ? TextSpan(
              text: widget.moreText,
              style: widget.moreStyle,
            ) : const TextSpan()
          ],
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
