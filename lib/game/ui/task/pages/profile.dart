import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/helpers/validation.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/widgets/forms/input_component.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {

    context.read<ServerBloc>().add(ServerDestroyPayload());
    context.read<ServerBloc>().add(ServerPutPayload(value: "hemmy6894", key: "name"));
    context.read<ServerBloc>().add(RegisterUserEvent());
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        InputComponent(
          hintText: "Email / Username",
          initialValue: "",
          onSave: (String? value) => print("object"),
          onChange: (value) => context
              .read<ServerBloc>()
              .add(ServerPutPayload(value: value, key: "username")),
          validate: "email",
        ),
        const SizedBox(height: 4.0),
      ],
    );
  }
}
