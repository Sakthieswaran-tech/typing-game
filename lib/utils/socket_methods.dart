import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/providers/game_state_provider.dart';
import 'package:typeracer/providers/time_state_provider.dart';
import 'package:typeracer/utils/socket_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  createGame(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('create-game', {'nickname': nickname});
    }
  }

  joinGame(String gameID, String nickname) {
    if (gameID.isNotEmpty && nickname.isNotEmpty) {
      _socketClient.emit('join-game', {'gameID': gameID, 'nickname': nickname});
    }
  }

  updateGameListener(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      Provider.of<GameStateProvider>(context, listen: false).updateGameState(
          id: data['_id'],
          players: data['players'],
          isJoin: data['isJoin'],
          isOver: data['isOver'],
          words: data['words']);

      if (data['isJoin']) {
        if (data['_id'].toString().isNotEmpty) {
          Navigator.pushNamed(context, '/game-screen');
        }
      }
    });
  }

  notCorrectGame(BuildContext context) {
    _socketClient.on(
        'not-a-game',
        (data) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(data)))
            });
  }

  startTime(playerID, gameID) {
    _socketClient.emit('start-time', {'playerID': playerID, 'gameID': gameID});
  }

  updateTimer(BuildContext context) {
    final timeStateProvider =
        Provider.of<TimeStateProvider>(context, listen: false);
    _socketClient.on('timer-update', (data) {
      timeStateProvider.setTimeState(data);
    });
  }

  submitWords(String value, String gameID) {
    _socketClient.emit('submit-word', ({'value': value, 'gameID': gameID}));
  }

  gameFinished() {
    _socketClient.on('done', (data) => _socketClient.off('timer-update'));
  }

  timeOver() {
    _socketClient.on('game-over', (data) => _socketClient.off('timer-update'));
  }
}
