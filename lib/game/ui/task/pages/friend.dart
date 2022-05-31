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
            children: [
              // for (int i = 0; i < 10; i++)
                for (PhoneModel phone in friends)
                  Container(
                    color: friends.isNotEmpty ? Colors.red : Colors.blue,
                    margin: const EdgeInsets.all(1),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 50,
                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
