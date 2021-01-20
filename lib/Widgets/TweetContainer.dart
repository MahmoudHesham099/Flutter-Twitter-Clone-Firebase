import 'package:flutter/material.dart';
import 'package:twitter/Constants/Constants.dart';
import 'package:twitter/Models/Tweet.dart';
import 'package:twitter/Models/UserModel.dart';

class TweetContainer extends StatefulWidget {
  final Tweet tweet;
  final UserModel author;

  const TweetContainer({Key key, this.tweet, this.author}) : super(key: key);
  @override
  _TweetContainerState createState() => _TweetContainerState();
}

class _TweetContainerState extends State<TweetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.author.profilePicture.isEmpty
                    ? AssetImage('assets/placeholder.png')
                    : NetworkImage(widget.author.profilePicture),
              ),
              SizedBox(width: 10),
              Text(
                widget.author.name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            widget.tweet.text,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          widget.tweet.image.isEmpty
              ? SizedBox.shrink()
              : Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                          color: KTweeterColor,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.tweet.image),
                          )),
                    )
                  ],
                ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                        ),
                        onPressed: () {},
                      ),
                      Text(
                        widget.tweet.likes.toString() + ' Likes',
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.repeat,
                        ),
                        onPressed: () {},
                      ),
                      Text(
                        widget.tweet.retweets.toString() + ' Retweets',
                      )
                    ],
                  ),
                ],
              ),
              Text(
                widget.tweet.timestamp.toDate().toString().substring(0, 19),
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: 10),
          Divider()
        ],
      ),
    );
  }
}
