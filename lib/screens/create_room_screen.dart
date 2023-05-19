import 'package:flutter/material.dart';
import 'package:typeracer/utils/socket_client.dart';
import 'package:typeracer/utils/socket_methods.dart';
import 'package:typeracer/widgets/custom_button.dart';
import 'package:typeracer/widgets/custom_text_field.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final TextEditingController controller = TextEditingController();
  // final SocketClient _socketClient = SocketClient.instance;
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateGameListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
                const Text('Create Room', style: TextStyle(fontSize: 30)),
                SizedBox(
                  height: size.height * 0.08,
                ),
                CustomTextField(
                    controller: controller, hintText: 'Enter your nickname'),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  text: 'Create',
                  onTap: () => _socketMethods.createGame(controller.text),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
