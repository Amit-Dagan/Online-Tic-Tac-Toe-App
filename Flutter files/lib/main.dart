import 'package:flutter/material.dart';
import 'UserSimplePreferences.dart';
import 'pages/Home.dart';
import 'pages/Login.dart';
import 'pages/Game.dart';
import 'pages/Signup.dart';
import 'pages/Confirm.dart';
import 'pages/Board.dart';
import 'pages/GameCode.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();

  runApp(MaterialApp(
    routes: {
      '/': (context) => Home(),
      //'/': (context) => Board(),
      '/login': (context) => Login(),
      '/signup': (context) => Signup(),
      '/confirm': (context) => Confirm(),
      '/game': (context) => Game(),
      '/gameCode': (context) => GameCode(),
      '/board': (context) => Board()
    },
  ));

}