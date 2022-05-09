import 'package:flutter/material.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  const AppLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}
