import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/data/models/phone.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List<PhoneModel> friends = [];

  @override
  initState() {
    context.read<ServerBloc>().add(PullFriendEvent());
    friends = context.read<ServerBloc>().state.friends;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerBloc, ServerState>(
      listenWhen: (previous, current) => previous.friends != current.friends,
      listener: (context, state) {
        setState(() {
          friends = state.friends;
        });
      },
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Friends",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 30),
              ),
              for (PhoneModel phone in friends)
                Column(
                  children: [
                    Container(
                      // color: friends.isNotEmpty ? Colors.red : Colors.blue,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(1),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              color: Colors.grey.withOpacity(0.3),
                              // height: 50,
                              // width: 50,
                              padding: const EdgeInsets.all(3),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(phone.displayName),
                              Text(phone.phone),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 0.09,
                      width: MediaQuery.of(context).size.width,
                    )
                  ],
                ),

            ],
          ),
        ),
      ),
    );
  }
}
