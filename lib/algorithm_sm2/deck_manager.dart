import 'package:five_control_widget/algorithm_sm2/card.dart';
import 'package:five_control_widget/algorithm_sm2/deck.dart';

import '../firebase/cloud.dart';

class DeckManager {
  static List<Deck> deckList = [];

  static void addDeck({required String deckName}) {
    deckList.add(Deck(deckName));
  }

  static void updateDeckOnCloud(
      {required String deckName, required Cloud cloud}) {
    cloud.updateDeckOnCloud(
      deckList.length - 1,
      deckName,
    );
  }

  static void removeDeck(int index) {
    deckList.removeAt(index);
  }

  static Future<void> removeAll() async {
    deckList = [];
  }

  static void addCard(
      {required String deckName, required FlashCard flashCard}) {
    for (int i = 0; i < deckList.length; i++) {
      if (deckList[i].deckName == deckName) {
        deckList[i].addCard(flashCard: flashCard);
        return;
      }
    }
  }

  static void addCardToCloud({required String deckName, required Cloud cloud}) {
    for (int i = 0; i < deckList.length; i++) {
      if (deckList[i].deckName == deckName) {
        deckList[i].addCardToCould(deckId: i, cloud: cloud);
        return;
      }
    }
  }

  static void removeCard(String deckName, int index) {
    for (int i = 0; i < deckList.length; i++) {
      if (deckList[i].deckName == deckName) {
        deckList[i].removeCard(index);
      }
    }
  }

  static List<String> getDecksName() {
    List<String> res = [];
    for (int i = 0; i < deckList.length; i++) {
      res.add(deckList[i].deckName);
    }
    return res;
  }
}
