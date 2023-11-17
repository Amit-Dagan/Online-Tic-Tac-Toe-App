import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newttt/UserSimplePreferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;


class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}



class _GameState extends State<Game> {
  @override
  // final channel = WebSocketChannel.connect(
  //   Uri.parse('wss://qvxokkvyzk.execute-api.eu-central-1.amazonaws.com/production/?authorizationToken=${UserSimplePreferences.getAccessKey()}'),
  // );



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('asd'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: newGame, child: Text('new game')),
            ElevatedButton(onPressed: joinGame, child: Text('join game')),
            SizedBox(height: 24),
            // StreamBuilder(
            //   stream: channel.stream,
            //   builder: (context, snapshot) {
            //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
            //   },
            //)
          ],
        ),
      ),
    );
  }

  void newGame(){


    final Map<String, String> body = {
      'action': 'newgame'
    };

    //print(jsonEncode(body));
    //channel.sink.add(jsonEncode(body));

    Navigator.pushNamed(context, '/gameCode', arguments: 'newgame');
  }

  void joinGame(){
    Navigator.pushNamed(context, '/gameCode', arguments: 'joingame');
  }

  void listen(){
    //channel.stream.listen((event) {print(event);});
  }
}
