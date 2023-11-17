import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../UserSimplePreferences.dart';
import '/User.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _LoginState();
}

class _LoginState extends State<Signup> {
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
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                icon: Icon(Icons.mail),
                hintText: 'mail@mail.com',
                labelText: 'mail',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                hintText: '*****',
                labelText: 'password',
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
    }
  }

  void success(){

    Navigator.pushNamed(context, '/confirm');
  }

  Future<bool> signIn() async {
    const String apiUrl = 'https://4m0nwhh52f.execute-api.eu-central-1.amazonaws.com/dev/sign_up'; // Replace with your API endpoint

    // Replace with your credentials and client ID
    const String mail = 'amitdagan78@gmail.com';
    const String password = '!23Qweasd';

    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> data = {
      'USERNAME': mail,
      'PASSWORD': password
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(data),
    );
    Map<String, dynamic> lambda_response = jsonDecode(response.body);
    print(lambda_response);
    if (lambda_response["statusCode"] == 200) {
      print('200');
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      showErrorMessageToast(lambda_response["body"]);
      return false;
    }
  }


  void showErrorMessageToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

