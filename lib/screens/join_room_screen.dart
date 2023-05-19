import 'package:flutter/material.dart';
import 'package:typeracer/utils/socket_methods.dart';
import 'package:typeracer/widgets/custom_button.dart';
import 'package:typeracer/widgets/custom_text_field.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateGameListener(context);
    _socketMethods.notCorrectGame(context);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    idController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Join Room', style: TextStyle(fontSize: 30)),
                SizedBox(
                  height: size.height * 0.08,
                ),
                CustomTextField(
                    controller: nameController,
                    hintText: 'Enter your nickname'),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    controller: idController, hintText: 'Enter game id'),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                    text: 'Join',
                    onTap: () => _socketMethods.joinGame(
                        idController.text, nameController.text))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
