import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_game/common/helpers/helper.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/levels/home.dart';
import 'package:test_game/game/ui/task/main_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBlocOverrides.runZoned(
          () => runApp(const MyApp()),
      storage: storage);
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
          bottomNavigationBarTheme: ThreeBottomNavigationBar().bottomNavigationBarTheme()
        ),
        home: const MainApp(),
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
      BlocProvider<UiCubit>(create: (context) => UiCubit()),
    ], child: widget.child);
  }
}
