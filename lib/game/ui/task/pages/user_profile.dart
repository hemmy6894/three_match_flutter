import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/user_model.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/task/pages/profile.dart';
import 'package:test_game/game/ui/task/pages/profile_pages/assigned.dart';
import 'package:test_game/game/ui/task/pages/profile_pages/assigns.dart';
import 'package:test_game/game/ui/task/pages/profile_pages/won.dart';
import 'package:test_game/game/ui/task/pages/widgets/view_button.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserModel userModel = UserModel.empty();

  @override
  void initState() {
    userModel = context.read<ServerBloc>().state.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 7,
          ),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.4),
            child: Image.asset(
              Assets.background,
              height: MediaQuery.of(context).size.width * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            userModel.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: const [
                  Text(
                    "0K",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Assigned",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.grey, width: 0.5),
                    right: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                    children: const [
                      Text(
                        "0K",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Plays",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: const [
                  Text(
                    "0K",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Won",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ButtonComponent(
              title: "Edit Profile",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const Profile(),
                    fullscreenDialog: true,
                  ),
                );
              },
              mainAxisAlignment: MainAxisAlignment.center,
              buttonSizeHeight: 45,
              transparent: true,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          gridView(),
          const SizedBox(
            height: 0,
          ),
        ],
      ),
    );
  }

  Widget gridView() {
    int gridCount = MediaQuery.of(context).size.width > 500 ? 4 : 2;
    double size = (MediaQuery.of(context).size.width / gridCount);
    return Expanded(
      child: GridView.count(crossAxisCount: gridCount, children: [
        UploadingButtonWidget(
          size: size,
          title: "Assigned",
          icon: Icons.directions_boat,
          clicked: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    const UserAssignedTask(),
                    fullscreenDialog: true,
              ),
            );
          },
        ),
        UploadingButtonWidget(
          size: size,
          title: "Assigns",
          icon: Icons.directions_bike,
          clicked: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                const UserAssignsTask(),
                fullscreenDialog: true,
              ),
            );
          },
        ),
        UploadingButtonWidget(
          size: size,
          title: "Won",
          icon: Icons.wine_bar_outlined,
          clicked: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                const UserWonTask(),
                fullscreenDialog: true,
              ),
            );
          },
        ),
        UploadingButtonWidget(
          size: size,
          title: "Save",
          icon: Icons.save,
          clicked: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (BuildContext context) =>
            //         const MovieUploadPopup(),
            //     fullscreenDialog: true,
            //   ),
            // );
          },
        ),
      ]),
    );
  }

  Widget tabController({required Widget child}) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            child,
            const TabBar(
              indicatorColor: Color(Assets.primaryGoldColor),
              labelColor: Color(Assets.primaryGoldColor),
              unselectedLabelColor: Color(Assets.primaryBlueColor),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.directions_car,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.directions_transit,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.directions_bike,
                  ),
                ),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  // UserProfilePage(),
                  Icon(Icons.directions_car),
                  Icon(Icons.directions_transit),
                  Icon(Icons.directions_bike),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
