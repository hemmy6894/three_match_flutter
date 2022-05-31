import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/levels/home.dart';
import 'package:test_game/game/ui/levels/widget/life_count.dart';
import 'package:test_game/game/ui/task/pages/all_task.dart';
import 'package:test_game/game/ui/task/pages/assign.dart';
import 'package:test_game/game/ui/task/pages/friend.dart';
import 'package:test_game/game/ui/task/pages/profile.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    FriendPage(),
    AssignTask(),
    AllSignedTask(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Icon profile = const Icon(Icons.person);
  String profileLabel = "Profile";
  @override
  initState(){

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
              Container(
                padding: const EdgeInsets.all(3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        LiveCount(),
                        Icon(Icons.currency_bitcoin),
                      ],
                    ),
                    const Icon(Icons.search),
                  ],
                ),
              ),
              Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
              BlocListener<ServerBloc,ServerState>(
                  listener: (context,state) {
                  setState((){
                    if(state.token == ""){
                      profile = const Icon(Icons.login);
                      profileLabel = "login";
                    }else{
                      profile = const Icon(Icons.person);
                      profileLabel = "Profile";
                    }
                  });
              }, child: Container(),)
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Friends',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Sign',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Signed',
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
