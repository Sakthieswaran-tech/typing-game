import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/providers/game_state_provider.dart';
import 'package:typeracer/utils/socket_client.dart';
import 'package:typeracer/utils/socket_methods.dart';
import 'package:typeracer/widgets/scoreboard.dart';

class SentenceGame extends StatefulWidget {
  const SentenceGame({super.key});

  @override
  State<SentenceGame> createState() => _SentenceGameState();
}

class _SentenceGameState extends State<SentenceGame> {
  var playerMe;
  SocketMethods socketMethods = SocketMethods();

  findPlayerMe(GameStateProvider gameStateProvider) {
    gameStateProvider.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  Widget getTypedWords(words, player) {
    var tempList = words.sublist(0, player['currentWordIndex']);
    var typedWords = tempList.join(' ');
    typedWords += ' ';
    return Text(
      typedWords,
      style:
          const TextStyle(color: Color.fromRGBO(52, 235, 119, 1), fontSize: 30),
    );
  }

  Widget getCurrentWord(words, player) {
    return Text(words[player['currentWordIndex']] + ' ',
        style: const TextStyle(
            fontSize: 30, decoration: TextDecoration.underline));
  }

  Widget getRemainingWords(words, player) {
    var tempList =
        words.sublist(player['currentWordIndex'] + 1, words.length).join(' ');
    return Text(
      tempList,
      style: const TextStyle(fontSize: 30),
    );
  }

  @override
  void initState() {
    super.initState();
    socketMethods.updateGameListener(context);
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    findPlayerMe(game);

    if (game.gameState['words'].length > playerMe['currentWordIndex']) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          textDirection: TextDirection.ltr,
          children: [
            getTypedWords(game.gameState['words'], playerMe),
            getCurrentWord(game.gameState['words'], playerMe),
            getRemainingWords(game.gameState['words'], playerMe)
          ],
        ),
      );
    }
    return const ScoreBoard();
  }
}
