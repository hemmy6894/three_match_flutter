import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/data/models/country.dart';
import 'package:test_game/game/data/models/gender.dart';
import 'package:test_game/game/data/models/phone.dart';
import 'package:test_game/game/data/models/task.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/task/pages/widgets/gift.dart';
import 'package:test_game/game/ui/task/pages/widgets/rank.dart';
import 'package:test_game/game/ui/task/pages/widgets/search.dart';
import 'package:test_game/game/ui/task/pages/widgets/search_country.dart';
import 'package:test_game/game/ui/task/pages/widgets/search_gender.dart';
import 'package:test_game/game/ui/task/pages/widgets/search_task.dart';
import 'package:test_game/game/ui/task/pages/widgets/wallpaper.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';

class AssignTask extends StatefulWidget {
  final Function(int) taped;

  const AssignTask({Key? key, required this.taped}) : super(key: key);

  @override
  State<AssignTask> createState() => _AssignTaskState();
}

class _AssignTaskState extends State<AssignTask> {
  List<PhoneModel> friends = [];
  List<TaskModel> tasks = [];
  List<GenderModel> genders = [];
  List<CountryModel> countries = [];
  late PhoneModel selectedUser;
  late TaskModel selectedTask;
  late GenderModel selectedGender;
  late CountryModel selectedCountry;
  int _currentStep = 0;

  @override
  initState() {
    selectedUser = PhoneModel.empty();
    selectedTask = TaskModel.empty();
    selectedGender = GenderModel.empty();
    selectedCountry = CountryModel.empty();
    context.read<ServerBloc>().add(PullFriendEvent());
    context.read<ServerBloc>().add(PullTaskEvent());
    context.read<ServerBloc>().add(PullGenderEvent());
    context.read<ServerBloc>().add(PullCountryEvent());
    friends = context.read<ServerBloc>().state.friends;
    tasks = context.read<ServerBloc>().state.tasks;
    genders = context.read<ServerBloc>().state.genders;
    countries = context.read<ServerBloc>().state.countries;
    if (context.read<ServerBloc>().state.user.type == "company") {
      rankStep = 2;
      taskStep = 3;
      wallpaperStep = 4;
      prizeStep = 5;
    } else {
      taskStep = 1;
      prizeStep = 2;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: MultiBlocListener(
          listeners: [
            BlocListener<ServerBloc, ServerState>(
              // listenWhen: (previous, current) => previous.genders != current.genders,
              listener: (context, state) {
                setState(() {
                  if (state.genders.isNotEmpty) {
                    genders = state.genders;
                    genders.insert(
                      0,
                      const GenderModel(
                        name: "All gender",
                        id: "",
                      ),
                    );
                  }
                  if (state.countries.isNotEmpty) {
                    countries = state.countries;
                    countries.insert(
                      0,
                      const CountryModel(
                        name: "All country",
                        id: "",
                      ),
                    );
                  }
                  if (state.tasks.isNotEmpty) {
                    tasks = state.tasks;
                  }
                  if (state.friends.isNotEmpty) {
                    friends = state.friends;
                  }
                });
              },
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (context.read<ServerBloc>().state.user.type == "company")
                _genderWidget(),
              if (context.read<ServerBloc>().state.user.type == "company")
                _countryWidget(),
              if (context.read<ServerBloc>().state.user.type == "company")
                _enterRank(),
              if (context.read<ServerBloc>().state.user.type == "company")
                _enterWallpaper(),
              if (context.read<ServerBloc>().state.user.type != "company")
                _selectUser(),
              _selectTask(),
              _enterPrize(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectUser() {
    if (_currentStep == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchUser(
            friends: friends,
            clicked: (phone) {
              context
                  .read<ServerBloc>()
                  .add(ServerPutPayload(value: phone.id, key: "user_id"));
              setState(
                () {
                  selectedUser = phone;
                },
              );
            },
          ),
          if (selectedUser != PhoneModel.empty())
            Row(
              children: [
                const Text("SELECTED: "),
                SearchUser.selectedUser(friend: selectedUser),
              ],
            ),
          Row(
            children: [nextButton()],
          )
        ],
      );
    }
    return Container();
  }

  Widget _genderWidget() {
    if (_currentStep == 0) {
      return Column(
        children: [
          SearchGender(
            genders: genders,
            clicked: (gender) {
              context
                  .read<ServerBloc>()
                  .add(ServerPutPayload(value: gender.id, key: "gender_id"));
              setState(() {
                selectedGender = gender;
              });
            },
          ),
          if (selectedGender != GenderModel.empty())
            Row(
              children: [
                const Text("SELECTED: "),
                SearchGender.selected(gender: selectedGender),
              ],
            ),
          Row(
            children: [
              nextButton(),
            ],
          )
        ],
      );
    }
    return Container();
  }

  int taskStep = 1;
  int prizeStep = 2;

  Widget _countryWidget() {
    if (_currentStep == 1) {
      return Column(
        children: [
          SearchCountry(
            countries: countries,
            clicked: (country) {
              context
                  .read<ServerBloc>()
                  .add(ServerPutPayload(value: country.id, key: "country_id"));
              setState(() {
                selectedCountry = country;
              });
            },
          ),
          if (selectedCountry != CountryModel.empty())
            Row(
              children: [
                const Text("SELECTED: "),
                SearchCountry.selected(country: selectedCountry),
              ],
            ),
          Row(
            children: [
              nextButton(),
              backButton(),
            ],
          )
        ],
      );
    }
    return Container();
  }

  Widget _selectTask() {
    if (_currentStep == taskStep) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchTask(
            tasks: tasks,
            clicked: (task) {
              context
                  .read<ServerBloc>()
                  .add(ServerPutPayload(value: task.id, key: "task_id"));
              setState(() {
                selectedTask = task;
              });
            },
          ),
          if (selectedTask != TaskModel.empty())
            Row(
              children: [
                SearchTask.selected(task: selectedTask),
              ],
            ),
          Row(
            children: [
              nextButton(),
              backButton(),
            ],
          )
        ],
      );
    }
    return Container();
  }

  PlatformFile? myFile;
  Widget _enterPrize() {
    if (_currentStep == prizeStep) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GiftWidget(
            getFilet: (file) {
              setState(() {
                myFile = file;
              });
            },
          ),
          Row(
            children: [
              backButton(),
              saveButton(),
            ],
          ),
        ],
      );
    }
    return Container();
  }

  PlatformFile? wallPaper;
  int wallpaperStep = 0;
  Widget _enterWallpaper() {
    if (_currentStep == wallpaperStep) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WallpaperWidget(
            getFilet: (file) {
              setState(() {
                wallPaper = file;
              });
            },
          ),
          Row(
            children: [
              nextButton(),
              backButton(),
            ],
          ),
        ],
      );
    }
    return Container();
  }

  int rankStep = 0;
  Widget _enterRank() {
    if (_currentStep == rankStep) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RankWidget(),
          Row(
            children: [
              nextButton(),
              backButton(),
            ],
          ),
        ],
      );
    }
    return Container();
  }

  Widget nextButton() {
    return Expanded(
      child: ButtonComponent(
        onPressed: () {
          setState(
            () {
              _currentStep++;
            },
          );
        },
        title: "Next",
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  bool isLoading = false;
  bool clicked = false;

  Widget saveButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(
            () {
              context
                  .read<ServerBloc>()
                  .add(ServerPutPayload(value: myFile, key: "attachment"));
              context
                  .read<ServerBloc>()
                  .add(ServerPutPayload(value: wallPaper, key: "wallpaper"));
              context.read<ServerBloc>().add(AssignTaskEvent());
              clicked = true;
            },
          );
        },
        child: BlocListener<ServerBloc, ServerState>(
          listenWhen: (previous, current) =>
              previous.logging != current.logging,
          listener: (context, state) {
            if (!isLoading && clicked) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Assigned Success"),
                ),
              );
              widget.taped(0);
            }
            setState(() {
              isLoading = state.logging;
            });
          },
          child: isLoading
              ? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(),
                )
              : const Text(
                  "Save",
                ),
        ),
      ),
    );
  }

  Widget backButton() {
    return TextButton(
      onPressed: () {
        setState(
          () {
            _currentStep--;
          },
        );
      },
      child: const Text(
        "Back",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
