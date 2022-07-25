import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/layouts/app.dart';
import 'package:test_game/game/ui/levels/widget/life_count.dart';
import 'package:test_game/game/ui/task/pages/all_task.dart';
import 'package:test_game/game/ui/task/pages/assign.dart';
import 'package:test_game/game/ui/task/pages/friend.dart';
import 'package:test_game/game/ui/task/pages/home.dart';
import 'package:test_game/game/ui/task/pages/profile.dart';
import 'package:test_game/game/ui/task/pages/user_profile.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      if (!isOn) {
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
      AssignTask(taped: (numb) {
        _onItemTapped(numb);
      }),
      const FriendPage(),
      const UserProfilePage(),
    ];
    isOn = context.read<ServerBloc>().state.token == "" ? false : true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isOn) {
      return const AppLayout(
        child: Profile(
          closable: true,
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blueGrey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      _widgetOptions.elementAt(_selectedIndex),
                      if (isOn &&
                          (_selectedIndex != 4 &&
                              _selectedIndex != 2 &&
                              _selectedIndex != 3))
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: Container(
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
                                // const Icon(Icons.search),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
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
                    // listenWhen: (previous,current) => previous.token != current.token,
                    listener: (context, state) {
                      setState(() {
                        isOn = state.token == "" ? false : true;
                        if (!isOn && _selectedIndex != 4) {
                          _selectedIndex = 4;
                        }
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
      bottomNavigationBar: !isOn
          ? null
          : BottomNavigationBar(
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
              // selectedItemColor: Colors.amber[800],
              backgroundColor: const Color(Assets.primaryGoldColor),
              onTap: _onItemTapped,
            ),
    );
  }
}
