import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/providers/game_state_provider.dart';
import 'package:typeracer/providers/time_state_provider.dart';
import 'package:typeracer/utils/socket_methods.dart';
import 'package:typeracer/widgets/game_text_field.dart';
import 'package:typeracer/widgets/sentence_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateTimer(context);
    _socketMethods.updateGameListener(context);
    _socketMethods.gameFinished();
    _socketMethods.timeOver();
  }

  @override
  Widget build(BuildContext context) {
    final gameStateProvider = Provider.of<GameStateProvider>(context);
    final timeStateProvider = Provider.of<TimeStateProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Chip(
                label: Text(
                  timeStateProvider.getTimeState['timer']['message'].toString(),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Text(
                timeStateProvider.getTimeState['timer']['count'].toString(),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SentenceGame(),
              ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 600, maxHeight: 500),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: gameStateProvider.gameState['players'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(
                            label: Text(
                              gameStateProvider.gameState['players'][index]
                                  ['nickname'],
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Slider(
                            value: (gameStateProvider.gameState['players']
                                    [index]['currentWordIndex'] /
                                gameStateProvider.gameState['words'].length),
                            onChanged: (val) {},
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              gameStateProvider.gameState['isJoin']
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: TextField(
                        readOnly: true,
                        onTap: () => {
                          Clipboard.setData(ClipboardData(
                                  text: gameStateProvider.gameState['id']))
                              .then((value) => ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Game code is copied to clipboard'))))
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          fillColor: const Color(0xff5f5f5fa),
                          hintStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                          hintText: 'Click to copy code',
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: const GameTextField()),
    );
  }
}
