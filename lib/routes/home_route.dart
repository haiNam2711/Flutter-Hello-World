import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:five_control_widget/algorithm_sm2/deck_manager.dart';
import 'package:five_control_widget/dark_mode/theme.dart';
import 'package:five_control_widget/firebase/cloud.dart';

import '../dark_mode/config.dart';
import 'package:flutter/material.dart';
import 'learning_route.dart';
import '../widget/main_button.dart';

class HomeRoute extends StatefulWidget {
  final FirebaseFirestore fireStore;
  const HomeRoute({Key? key, required this.fireStore}) : super(key: key);

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with TickerProviderStateMixin {
  late AnimationController rotateController;
  late Animation<double> rotateAnimation;

  late AnimationController moveController;
  late Animation<double> moveAnimation;
  late Cloud cloud;

  ValueNotifier<bool> openedButton = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    cloud = Cloud(widget.fireStore);

    rotateController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    rotateAnimation = Tween<double>(
      begin: 0.0,
      end: pi / 4 * 3,
    ).animate(rotateController);

    moveController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    moveAnimation = Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(moveController);

    openedButton.value = false;
//moveController.forward();
//rotateController.forward();
  }

  @override
  void dispose() {
    rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        rotateController.reverse();
        moveController.reverse();
        openedButton.value = false;
      },
      child: Scaffold(
        drawer: const SideBar(),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.menu,
          //   ),
          //   onPressed: () {},
          // ),
          title: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              children: const [
                Text(
                  'AnkiDroid',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '10 cards due.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton (
                onPressed: ()  async {
                  cloud.pullFromCloud();
                  await Future.delayed(const Duration(milliseconds: 3000));
                  setState(() {

                  });
                },
                icon: const Icon(
                  Icons.download,
                ),
            ),
            IconButton (
              onPressed: () {
                cloud.pushToCloud();
              },
              icon: const Icon(
                Icons.backup,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {

                });
              },
              icon: const Icon(
                Icons.more_vert,
              ),
            ),
          ],
        ),
        floatingActionButton: MainButton(
          context,
          rotateController,
          rotateAnimation,
          moveController,
          moveAnimation,
          openedButton,
          changeState: () {
            setState(() {});
          },
        ),
        body: SafeArea(
          child: ListView.builder(
            itemCount: DeckManager.deckList.length,
            itemBuilder: (context, index) {
              return Card(
                color: index % 2 == 0 ? Colors.grey : Colors.white,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.only(top: 4.5),
                    child: Text(
                      DeckManager.deckList[index].deckName,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppTheme().currentTheme() == ThemeMode.dark
                            ? Colors.black
                            : Colors.black,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${DeckManager.deckList[index].getNewCard()} ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Text(
                        '${DeckManager.deckList[index].getLearningCard()} ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red.shade700,
                        ),
                      ),
                      Text(
                        '${DeckManager.deckList[index].getGraduatedCard()}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade900),
                      ),
                    ],
                  ),
                  onTap: () {
                    rotateController.reverse();
                    moveController.reverse();
                    openedButton.value = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LearningRoute(
                                deckIndex: index,
                                changeState: () {
                                  setState(() {});
                                },
                              )),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Image(
            image: AssetImage('images/anki.png'),
            fit: BoxFit.fill,
          ),
          const ListTile(
            leading: Icon(Icons.manage_search),
            title: Text('Decks'),
          ),
          const ListTile(
            leading: Icon(Icons.search),
            title: Text('Card browser'),
          ),
          const ListTile(
            leading: Icon(Icons.dynamic_form),
            title: Text('Statistics'),
          ),
          SizedBox(
            width: double.infinity,
            height: 1,
            child: Container(
              color: Colors.grey,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.mode_night),
            title: Text('Night Mode'),
            trailing: NightModeSwitch(),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          const ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
          ),
        ],
      ),
    );
  }
}

class NightModeSwitch extends StatefulWidget {
  const NightModeSwitch({Key? key}) : super(key: key);

  @override
  State<NightModeSwitch> createState() => _NightModeSwitchState();
}

class _NightModeSwitchState extends State<NightModeSwitch> {
  static bool light = false;
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: light,
        onChanged: (bool value2) {
          light = value2;
          appTheme.switchTheme();
          setState(() {});
        });
  }
}
