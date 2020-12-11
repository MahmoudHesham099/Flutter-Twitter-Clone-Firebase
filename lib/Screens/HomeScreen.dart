import 'package:flutter/material.dart';
import 'package:twitter/Screens/CreateTweetScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Image.asset('assets/tweet.png'),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateTweetScreen()));
        },
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
