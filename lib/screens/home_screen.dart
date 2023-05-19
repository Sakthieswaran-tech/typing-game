import 'package:flutter/material.dart';
import 'package:typeracer/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  goToCreateScreen() {
    Navigator.pushNamed(context, '/create-room');
  }

  goToJoinScreen() {
    Navigator.pushNamed(context, '/join-room');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create/Join a room to play",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                      text: 'Create', onTap: goToCreateScreen, isHome: true),
                  CustomButton(
                      text: 'Join', onTap: goToJoinScreen, isHome: true),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
