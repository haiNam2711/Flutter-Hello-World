import 'package:five_control_widget/add_scene.dart';
import 'package:five_control_widget/algorithm_sm2/deck_manager.dart';
import 'package:five_control_widget/firebase.dart';
import 'package:flutter/material.dart';

TextEditingController deckNameController = TextEditingController();

class ControlButton extends StatelessWidget {
  final BuildContext context;
  final AnimationController rotateController;
  final Animation<double> rotateAnimation;
  final AnimationController moveController;
  final Animation<double> moveAnimation;
  final ValueNotifier<bool> openedButton;

  const ControlButton(this.context,
      this.rotateController,
      this.rotateAnimation,
      this.moveController,
      this.moveAnimation,
      this.openedButton,
      {super.key, required this.changeState});

  final Function() changeState;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedBuilder(
                  animation: moveAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Create deck button.
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          color: Colors.black54,
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: const Text(
                            'Create deck',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: 'creat deck',
                          mini: true,
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.folder),
                          onPressed: () {
                            rotateController.reverse();
                            moveController.reverse();
                            openedButton.value = !openedButton.value;
                            showCreateDia(context);
                          },
                        ),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      // Get shared data button.
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          color: Colors.black54,
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: const Text(
                            'Get shared decks',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // FloatingActionButton(
                        //   heroTag: 'get shard decks',
                        //   mini: true,
                        //   backgroundColor: Colors.blue,
                        //   child: const Icon(Icons.download),
                        //   onPressed: () {},
                        // ),
                        const AddUser('thangg', 'uet', 15),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      // Add note button.
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          color: Colors.black54,
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: 'add',
                          mini: true,
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.add),
                          onPressed: () {
                            rotateController.reverse();
                            moveController.reverse();
                            openedButton.value = !openedButton.value;
                            if (DeckManager.deckList.isEmpty) {
                              showAddDia(context);
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddScene(
                                    changeState: () {
                                      changeState();
                                    },
                                  )),
                            );
                          },
                        ),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  builder: (context, child) =>
                      Transform.translate(
                        offset: Offset(
                          0.0,
                          -moveAnimation.value + 400.0,
                        ),
                        child: child,
                      ),
                ),

                // Main control button.
                AnimatedBuilder(
                  animation: rotateAnimation,
                  child: FloatingActionButton(
                    heroTag: 'control',
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add),
                    onPressed: () {
                      openedButton.value = !openedButton.value;
                      if (openedButton.value) {
                        rotateController.forward();
                      } else {
                        rotateController.reverse();
                      }
                      if (openedButton.value) {
                        moveController.forward();
                      } else {
                        moveController.reverse();
                      }
                    },
                  ),
                  builder: (context, child) =>
                      Transform.rotate(
                        angle: rotateAnimation.value,
                        child: child,
                      ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void showCreateDia(dynamic context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Create Deck'),
        content: TextFormField(
          controller: deckNameController,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (deckNameController.text != '') {
                DeckManager.addDeck(deckName: deckNameController.text);
                changeState();
              }
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showAddDia(dynamic context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add card flase'),
        content: const Text('Your deck list is empty.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}