import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String id;
  String authorId;
  String text;
  String image;
  Timestamp timestamp;
  int likes;
  int retweets;

  Tweet(
      {this.id,
      this.authorId,
      this.text,
      this.image,
      this.timestamp,
      this.likes,
      this.retweets});

  factory Tweet.fromDoc(DocumentSnapshot doc) {
    return Tweet(
      id: doc.id,
      authorId: doc['authorId'],
      text: doc['text'],
      image: doc['image'],
      timestamp: doc['timestamp'],
      likes: doc['likes'],
      retweets: doc['retweets'],
    );
  }
}
