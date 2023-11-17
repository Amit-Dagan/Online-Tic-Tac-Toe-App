import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../UserSimplePreferences.dart';
import '/User.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Confirm extends StatefulWidget {
  const Confirm({Key? key}) : super(key: key);

  @override
  State<Confirm> createState() => _LoginState();
}

class _LoginState extends State<Confirm> {
  late User futureUserData;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(Icons.confirmation_num),
                hintText: '123456',
                labelText: 'confirmation code',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: on_press,
              child: Text('Confirm')),
          Spacer(flex: 1)

        ],
      ),

    );

  }

  on_press() async {
    bool managedToConnect = await signIn();
    //bool managedToConnect = false;

    if (managedToConnect){
      success();
    }
    else{
      showErrorMessageToast();
    }
  }

  void success(){

    Navigator.pushNamed(context, '/game');
  }

  Future<bool> signIn() async {
    const String apiUrl = 'https://4m0nwhh52f.execute-api.eu-central-1.amazonaws.com/dev/confirm'; // Replace with your API endpoint

    // Replace with your credentials and client ID
    const String mail = 'amitdagan78@gmail.com';
    const String password = '!23Qweasd';
    const String clientId = '7dl7nlht20c37ogbfbb1t2157u';

    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> data = {
      'AuthFlow': 'USER_PASSWORD_AUTH',
      'AuthParameters': {'USERNAME': mail, 'CODE': 379842}
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print('200');

      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print('Failed to sign in.');
      return false;
    }
  }


  void showErrorMessageToast() {
    Fluttertoast.showToast(
      msg: "Login failed. Please check your credentials.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

