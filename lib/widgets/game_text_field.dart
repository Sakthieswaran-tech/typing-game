import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/providers/game_state_provider.dart';
import 'package:typeracer/utils/socket_client.dart';
import 'package:typeracer/utils/socket_methods.dart';
import 'package:typeracer/widgets/custom_button.dart';

class GameTextField extends StatefulWidget {
  const GameTextField({super.key});

  @override
  State<GameTextField> createState() => _GameTextFieldState();
}

class _GameTextFieldState extends State<GameTextField> {
  final SocketMethods _socketMethods = SocketMethods();
  late GameStateProvider gameStateProvider;
  Map<String, dynamic> leaderPlayer = {'isLeader': false};
  var showStartBtn = true;
  final TextEditingController wordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    gameStateProvider = Provider.of<GameStateProvider>(context, listen: false);
    findLeader(gameStateProvider);
  }

  findLeader(GameStateProvider gameStateProvider) {
    gameStateProvider.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        leaderPlayer = player;
      }
    });
  }

  handleStart(GameStateProvider gameStateProvider) {
    _socketMethods.startTime(
        leaderPlayer['_id'], gameStateProvider.gameState['id']);
    setState(() {
      showStartBtn = false;
    });
  }

  handleWordSubmit(String value) {
    var lastChar = value[value.length - 1];
    if (lastChar == " ") {
      _socketMethods.submitWords(value, gameStateProvider.gameState['id']);
      wordController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<GameStateProvider>(context);
    return leaderPlayer['isLeader'] && showStartBtn
        ? CustomButton(
            text: leaderPlayer['isLeader'].toString(),
            onTap: () => handleStart(gameData))
        : TextField(
            controller: wordController,
            readOnly: gameData.gameState['isJoin'],
            onChanged: (data) => handleWordSubmit(data),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              fillColor: const Color(0xff5f5f5fa),
              hintStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              hintText: 'Type here...',
            ),
          );
  }
}
