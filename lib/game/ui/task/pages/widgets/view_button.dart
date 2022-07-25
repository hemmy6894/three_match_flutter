import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';

class UploadingButtonWidget extends StatefulWidget {
  final double size;
  final String title;
  final IconData icon;
  final Function()? clicked;

  const UploadingButtonWidget(
      {Key? key,
      this.size = 0,
      this.title = "",
      this.icon = Icons.music_note,
      this.clicked})
      : super(key: key);

  @override
  State<UploadingButtonWidget> createState() => _UploadingButtonWidgetState();
}

class _UploadingButtonWidgetState extends State<UploadingButtonWidget> {
  Color bgColor = const Color(Assets.primaryGoldColor).withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          bgColor = const Color(Assets.primaryGoldColor).withOpacity(0.5);
        });
        if (widget.clicked != null) {
          widget.clicked!();
        }
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          bgColor = const Color(Assets.primaryGoldColor).withOpacity(0.8);
        });
      },
      child: Container(
        color: bgColor,
        margin: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: Colors.white,
              size: widget.size * 0.65,
            ),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: widget.size * 0.15,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
