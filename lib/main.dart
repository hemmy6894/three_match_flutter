import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/ui/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GameProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GameHome(),
      ),
    );
  }
}

class GameProvider extends StatefulWidget {
  final Widget child;

  const GameProvider({Key? key, required this.child}) : super(key: key);

  @override
  State<GameProvider> createState() => _GameProviderState();
}

class _GameProviderState extends State<GameProvider> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<GameBlock>(create: (context) => GameBlock()),
    ], child: widget.child);
  }
}
