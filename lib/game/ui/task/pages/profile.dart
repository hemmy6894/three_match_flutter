import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:test_game/game/data/models/country.dart';
import 'package:test_game/game/data/models/gender.dart';
import 'package:test_game/game/data/models/user_model.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';
import 'package:test_game/game/ui/widgets/forms/input_component.dart';
import 'package:test_game/game/ui/widgets/forms/select_input_component.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> genders = {};
  Map<String, dynamic> countries = {};

  @override
  void initState() {
    context.read<ServerBloc>().add(ServerDestroyPayload());
    context.read<ServerBloc>().add(PullGenderEvent());
    context.read<ServerBloc>().add(PullCountryEvent());
    getContactList();
    super.initState();
  }

  getContactList() async {
    if (await FlutterContacts.requestPermission()) {
      context.read<ServerBloc>().add(FetchContactEvent());
    }
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: display(),
    );
  }

  bool isOn = false;
  UserModel userModel = UserModel.empty();

  Widget display() {
    return MultiBlocListener(
      listeners: [
        BlocListener<ServerBloc, ServerState>(
          listener: (context, state) {
            setState(() {
              isOn = state.token == "" ? false : true;
              userModel = state.user;
            });
          },
        ),
        BlocListener<ServerBloc, ServerState>(
          listener: (context, state) {
            setState(
              () {
                if (state.countries.isNotEmpty) {
                  countries = {};
                  countries.addAll({"": "Select country"});
                  for (CountryModel country in state.countries) {
                    countries.addAll({country.id: country.name});
                  }
                }
                if (state.genders.isNotEmpty) {
                  genders = {};
                  genders.addAll({"": "Select gender"});
                  for (GenderModel gender in state.genders) {
                    genders.addAll({gender.id: gender.name});
                  }
                }
              },
            );
          },
        ),
      ],
      child: isOn ? profile() : register(),
    );
  }

  Widget profile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          displayTap(key: "Name", value: userModel.name),
          displayTap(key: "Email", value: userModel.email),
          displayTap(key: "Phone", value: userModel.phone),
          if (genders.isNotEmpty)
            displayTapSelect(
                key: "Gender", value: userModel.genderId, values: genders),
          if (countries.isNotEmpty)
            displayTapSelect(
                key: "Country", value: userModel.countryId, values: countries),
          serverListeners(
            child: Row(
              children: [
                Expanded(
                  child: ButtonComponent(
                    isLoading: loading,
                    title: "Update",
                    onPressed: () {
                      context.read<ServerBloc>().add(UpdateUserEvent());
                    },
                    transparent: false,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget displayTap({
    required String key,
    required String value,
  }) {
    if (value != "") {
      if (key.toLowerCase() == "phone") {
        if (value.isNotEmpty) {
          if (value[0] == "0") {
            value = "255" + value.replaceFirst("0", "");
          }
        }
      }
      context.read<ServerBloc>().add(
            ServerPutPayload(
              value: value,
              key: key.toLowerCase(),
            ),
          );
    }
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
              child: Text(
            key,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
          Expanded(
            flex: 4,
            child: InputComponent(
              onSave: () {},
              onChange: (change) {
                if (key.toLowerCase() == "phone") {
                  if (change.isNotEmpty) {
                    if (change[0] == "0") {
                      change = "255" + change.replaceFirst("0", "");
                    }
                  }
                }
                context.read<ServerBloc>().add(
                    ServerPutPayload(value: change, key: key.toLowerCase()));
              },
              initialValue: value,
            ),
          ),
        ],
      ),
    );
  }

  Widget displayTapSelect({
    required String key,
    required String value,
    required Map<String, dynamic> values,
  }) {
    if (value != "") {
      context.read<ServerBloc>().add(
            ServerPutPayload(
              value: value,
              key: key.toLowerCase(),
            ),
          );
    }
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              key,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: SelectInputComponent(
              onSave: () {},
              onChange: (change) {
                context.read<ServerBloc>().add(
                      ServerPutPayload(
                        value: change,
                        key: key.toLowerCase(),
                      ),
                    );
              },
              items: values,
              hintText: "Select " + key,
              initialValue: value,
            ),
          )
        ],
      ),
    );
  }

  Widget register() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          InputComponent(
            hintText: "Username",
            initialValue: "",
            onSave: (String? value) {},
            onChange: (value) => context.read<ServerBloc>().add(
                  ServerPutPayload(
                    value: value,
                    key: "name",
                  ),
                ),
            validate: "string",
          ),
          const SizedBox(
            height: 4.0,
          ),
          serverListeners(
            child: Row(
              children: [
                Expanded(
                  child: ButtonComponent(
                    isLoading: loading,
                    title: "Login",
                    onPressed: () {
                      context.read<ServerBloc>().add(
                            RegisterUserEvent(),
                          );
                    },
                    transparent: false,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget serverListeners({Widget? child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ServerBloc, ServerState>(
          listenWhen: (previous, current) =>
              previous.logging != current.logging,
          listener: (context, state) {
            setState(
              () {
                loading = state.logging;
              },
            );
          },
        ),
        BlocListener<ServerBloc, ServerState>(
          listenWhen: (previous, current) => previous.phones != current.phones,
          listener: (context, state) {
            if (state.phones.isNotEmpty) {
              context.read<ServerBloc>().add(
                    RequestFriendEvent(),
                  );
            }
          },
        ),
      ],
      child: child ?? Container(),
    );
  }
}
