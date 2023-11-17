import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GameCode extends StatefulWidget {
  const GameCode({Key? key}) : super(key: key);

  @override
  State<GameCode> createState() => _GameCodeState();
}

class _GameCodeState extends State<GameCode> {


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings?.arguments as String;
    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                icon: Icon(Icons.confirmation_num),
                hintText: '123456',
                labelText: getText(args),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {confirm(args, '123');},
              child: Text('Confirm')),
          Spacer(flex: 1)

        ],
      ),

    );
  }
  void confirm(String action, String code){
    Navigator.pushNamed(context, '/board', arguments: {
      'action': action,
      'code': code
    });
  }

  String getText(String s){
    if (s == 'joingame'){
      return 'Enter the room name';
    }
    return 'Create a name for your room';
  }

}
