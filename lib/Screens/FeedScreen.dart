import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/Screens/CreateTweetScreen.dart';
import 'package:twitter/Screens/HomeScreen.dart';
import 'package:twitter/Screens/NotificationsScreen.dart';
import 'package:twitter/Screens/ProfileScreen.dart';
import 'package:twitter/Screens/SearchScreen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedTab = 0;
  List<Widget> _feedScreens = [
    HomeScreen(),
    SearchScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _feedScreens.elementAt(_selectedTab),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Image.asset('assets/tweet.png'),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateTweetScreen()));
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        activeColor: Color(0xff00acee),
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
