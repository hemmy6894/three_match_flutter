import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/levels/widget/life_count.dart';
import 'package:test_game/game/ui/task/pages/all_task.dart';
import 'package:test_game/game/ui/task/pages/assign.dart';
import 'package:test_game/game/ui/task/pages/friend.dart';
import 'package:test_game/game/ui/task/pages/home.dart';
import 'package:test_game/game/ui/task/pages/profile.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 4;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      if(!isOn){
        index = 4;
      }
      _selectedIndex = index;
    });
  }

  Icon profile = const Icon(Icons.person);
  String profileLabel = "Profile";
  bool isOn = false;

  @override
  initState() {
    _widgetOptions = [
      const GameHomePage(),
      const AllSignedTask(),
      AssignTask(taped: (num) {
        _onItemTapped(num);
      }),
      const FriendPage(),
      const Profile(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blueGrey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(isOn)
              Container(
                padding: const EdgeInsets.all(3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const LiveCount(),
                        BlocBuilder<UiCubit, UiState>(
                          buildWhen: (previous, current) =>
                              previous.rewards != current.rewards,
                          builder: (context, state) {
                            return Character(
                              characterType: CharacterType.coin,
                              row: 100,
                              active: false,
                              col: 100,
                              verticalUpdate: (d) {},
                              isHelper: true,
                              isObstacle: true,
                              isCoin: true,
                              hasBackGround: false,
                              height: 30,
                              width: 30,
                            );
                          },
                        ),
                      ],
                    ),
                    const Icon(Icons.search),
                  ],
                ),
              ),
              Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
              MultiBlocListener(
                listeners: [
                  BlocListener<ServerBloc, ServerState>(
                    listener: (context, state) {
                      setState(() {
                        if (state.token == "") {
                          profile = const Icon(Icons.login);
                          profileLabel = "login";
                        } else {
                          profile = const Icon(Icons.person);
                          profileLabel = "Profile";
                        }
                      });
                    },
                  ),
                  BlocListener<ServerBloc, ServerState>(
                    listener: (context, state) {
                      setState(() {
                        isOn = state.token == "" ? false : true;
                      });
                    },
                  ),
                ],
                child: Container(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: !isOn ? null : BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Signed',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Sign',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: profile,
            label: profileLabel,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
