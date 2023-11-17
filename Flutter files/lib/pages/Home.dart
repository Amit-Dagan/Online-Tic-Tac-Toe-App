import 'package:flutter/material.dart';

import '../UserSimplePreferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                }, child: Text('Login'),
              ),
              Spacer(flex: 1),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                }, child: Text('Sign up'),
              ),
              Spacer(flex: 1)
            ],
          )
        ],
      ),
    );
  }


}
