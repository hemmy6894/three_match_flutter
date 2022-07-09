import 'package:flutter/material.dart';
import 'package:test_game/game/data/models/phone.dart';
import 'package:test_game/game/ui/widgets/forms/input_component.dart';

class SearchUser extends StatefulWidget {
  final List<PhoneModel> friends;
  final Function(PhoneModel) clicked;


  const SearchUser({Key? key, required this.friends, required this.clicked})
      : super(key: key);

  static Widget selectedUser({required PhoneModel friend}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Text(
        friend.displayName + " - " + friend.phone,
        style: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  double ratio = 0.3;
  int i = 0;
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * ratio,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox( height: MediaQuery.of(context).size.height * 0.05,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Select User", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 30),)
              ],
            ),
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.10,),
          InputComponent(
            hintText: "Search user",
            onSave: () {},
            onChange: (v) {
              setState(
                () {
                  search = v;
                  if (search != "") {
                    ratio = 0.38;
                  } else {
                    ratio = 0.3;
                  }
                },
              );
            },
            // initialValue: search,
            // stateValue: search,
          ),
          ...displayResults(),
        ],
      ),
    );
  }

  List<Widget> searched() {
    List<Widget> w = [];
    if (search != "") {
      for (var friend in widget.friends) {
        if (friend.displayName.toLowerCase().contains(search.toLowerCase()) ||
            friend.phone.toLowerCase().contains(search.toLowerCase())) {
          w.add(singleFriendView(friend: friend));
        }
      }
    }
    return w;
  }

  Widget singleFriendView({required PhoneModel friend}) {
    return GestureDetector(
      onTap: () {
        widget.clicked(friend);
        setState(() {
          ratio = 0.3;
          search = "";
        });
      },
      child: SearchUser.selectedUser(friend: friend),
    );
  }

  List<Widget> displayResults() {
    List<Widget> displays = [];
    int i = 0;
    for (int i = 0; i < searched().length && i < 2; i++) {
      displays.add(searched()[i]);
    }
    return displays;
  }
}
