import 'package:flutter/material.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(1),
        borderRadius: BorderRadius.all(Radius.circular((mySize.width / 12))),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3) ,
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      alignment: Alignment.center,
      height: mySize.height * 0.1,
      width: mySize.width - (mySize.width * 0.2),
      child: const Text(
        "TASK LIST", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
    );
  }
}
