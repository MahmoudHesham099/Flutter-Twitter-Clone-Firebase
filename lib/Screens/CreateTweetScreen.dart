import 'package:flutter/material.dart';

class CreateTweetScreen extends StatefulWidget {
  @override
  _CreateTweetScreenState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends State<CreateTweetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("create tweet"),
      ),
    );
  }
}
