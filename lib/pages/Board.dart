import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newttt/UserSimplePreferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;


class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _GameState();
}



class _GameState extends State<Board> {
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse('wss://qvxokkvyzk.execute-api.eu-central-1.amazonaws.com/production/?authorizationToken=${UserSimplePreferences.getAccessKey()}'),
    );

  }

  @override
  void dispose() {
    // Close the WebSocket connection when the widget is disposed
    channel.sink.close();

    super.dispose();
  }

  void init(String action, String code) {
    final Map<String, String> body = {
      'action': action,
      'code': code
    };

    print(jsonEncode(body));
    channel.sink.add(jsonEncode(body));
  }

  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings?.arguments as Map<String, String>;
    final action = args['action'];
    final code = args['code'];
    init(action!, code!);
    String? responseMessage;
    List<dynamic>? board;
    late bool gameStarted;

    return Scaffold(
      appBar: AppBar(
        title: Text('asd'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                Map<String, dynamic> dataMap = {};
                if (snapshot.hasData) {
                  String jsonString = snapshot.data.toString();
                  print(jsonString);
                  dataMap = json.decode(jsonString);
                  responseMessage = dataMap['responseMessage'] ?? '';
                  board = dataMap['board'];
                  gameStarted = dataMap['game started'] ?? false;

                }


                // Ensure the board has at least 9 elements
                if (board == null) {
                  // Handle the case when the board is not properly initialized
                  return Text("loading"); // You can return an empty container or another widget as needed
                }

                // Generate rows of buttons based on the board
                List<Widget> rows = [];
                rows.add(Text(responseMessage!));
                for (int i = 0; i < 3; i++) {
                  List<Widget> buttonsInRow = [];
                  for (int j = 0; j < 3; j++) {
                    int index = i * 3 + j;
                    buttonsInRow.add(
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor(board?[(3*i)+j])
                        ),
                        onPressed: () {
                          int place = (3*i)+j;
                          sendMessage(place);
                          // Your onPressed logic here
                        },
                        child: Text('${board?[index]}'),
                      ),
                    );
                  }
                  rows.add(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buttonsInRow,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: rows,
                  ),
                );
              },
            )



          ],
        ),
      ),
    );
  }

  Color buttonColor(String? place){
    if (place == " "){
      return Colors.lightBlue.shade50;
    }
    return Colors.lightBlue;
  }

  void sendMessage(int place){
    channel.sink.add(json.encode({
      "action": "play",
      "code": "123",
      "place": place
    }));
  }

  void listen(){
    //channel.stream.listen((event) {print(event);});
  }
}
