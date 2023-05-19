import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer/providers/game_state_provider.dart';
import 'package:typeracer/providers/time_state_provider.dart';
import 'package:typeracer/screens/create_room_screen.dart';
import 'package:typeracer/screens/game_screen.dart';
import 'package:typeracer/screens/home_screen.dart';
import 'package:typeracer/screens/join_room_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameStateProvider()),
        ChangeNotifierProvider(create: (context) => TimeStateProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const HomeScreen(),
          '/create-room': (context) => const CreateRoom(),
          '/join-room': (context) => const JoinRoom(),
          '/game-screen': (context) => const GameScreen(),
        },
      ),
    );
  }
}
