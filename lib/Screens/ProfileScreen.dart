import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter/Constants/Constants.dart';
import 'package:twitter/Models/Tweet.dart';
import 'package:twitter/Models/UserModel.dart';
import 'package:twitter/Screens/EditProfileScreen.dart';
import 'package:twitter/Services/DatabaseServices.dart';
import 'package:twitter/Widgets/TweetContainer.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;

  const ProfileScreen({Key key, this.currentUserId, this.visitedUserId})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _followersCount = 0;
  int _followingCount = 0;
  bool _isFollowing = false;
  int _profileSegmentedValue = 0;
  List<Tweet> _allTweets = [];
  List<Tweet> _mediaTweets = [];

  Map<int, Widget> _profileTabs = <int, Widget>{
    0: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Tweets',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Media',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
    2: Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Likes',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
  };

  Widget buildProfileWidgets(UserModel author) {
    switch (_profileSegmentedValue) {
      case 0:
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _allTweets.length,
            itemBuilder: (context, index) {
              return TweetContainer(
                author: author,
                tweet: _allTweets[index],
              );
            });
        break;
      case 1:
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _mediaTweets.length,
            itemBuilder: (context, index) {
              return TweetContainer(
                author: author,
                tweet: _mediaTweets[index],
              );
            });
        break;
      case 2:
        return Center(child: Text('Likes', style: TextStyle(fontSize: 25)));
        break;
      default:
        return Center(
            child: Text('Something wrong', style: TextStyle(fontSize: 25)));
        break;
    }
  }

  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  followOrUnFollow() {
    if (_isFollowing) {
      unFollowUser();
    } else {
      followUser();
    }
  }

  unFollowUser() {
    DatabaseServices.unFollowUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = false;
      _followersCount--;
    });
  }

  followUser() {
    DatabaseServices.followUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = true;
      _followersCount++;
    });
  }

  setupIsFollowing() async {
    bool isFollowingThisUser = await DatabaseServices.isFollowingUser(
        widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = isFollowingThisUser;
    });
  }

  getAllTweets() async {
    List<Tweet> userTweets =
        await DatabaseServices.getUserTweets(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _allTweets = userTweets;
        _mediaTweets =
            _allTweets.where((element) => element.image.isNotEmpty).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    setupIsFollowing();
    getAllTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: usersRef.doc(widget.visitedUserId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(KTweeterColor),
                ),
              );
            }
            UserModel userModel = UserModel.fromDoc(snapshot.data);
            return ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: KTweeterColor,
                    image: userModel.coverImage.isEmpty
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(userModel.coverImage),
                          ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox.shrink(),
                        widget.currentUserId == widget.visitedUserId
                            ? PopupMenuButton(
                                icon: Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                itemBuilder: (_) {
                                  return <PopupMenuItem<String>>[
                                    new PopupMenuItem(
                                      child: Text('Logout'),
                                      value: 'logout',
                                    )
                                  ];
                                },
                                onSelected: (selectedItem) {},
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: userModel.profilePicture.isEmpty
                                ? AssetImage('assets/placeholder.png')
                                : NetworkImage(userModel.profilePicture),
                          ),
                          widget.currentUserId == widget.visitedUserId
                              ? GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfileScreen(
                                          user: userModel,
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      border: Border.all(color: KTweeterColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: KTweeterColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: followOrUnFollow,
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _isFollowing
                                          ? Colors.white
                                          : KTweeterColor,
                                      border: Border.all(color: KTweeterColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _isFollowing ? 'Following' : 'Follow',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: _isFollowing
                                              ? KTweeterColor
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        userModel.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        userModel.bio,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            '$_followingCount Following',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            '$_followersCount Followers',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoSlidingSegmentedControl(
                          groupValue: _profileSegmentedValue,
                          thumbColor: KTweeterColor,
                          backgroundColor: Colors.blueGrey,
                          children: _profileTabs,
                          onValueChanged: (i) {
                            setState(() {
                              _profileSegmentedValue = i;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                buildProfileWidgets(userModel),
              ],
            );
          },
        ));
  }
}
