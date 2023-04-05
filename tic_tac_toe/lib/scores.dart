import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Scores extends StatelessWidget {
  const Scores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Scores', style: TextStyle(color: Color(0xFFFAF9F6))),
      ),
      backgroundColor: Color(0xFF6082B6),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('scores').orderBy('createdAt', descending: true).snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot? scores = snapshot.data?.docs[index];
              int? total = snapshot.data?.docs.length;
              var player1 = scores?['player1'];
              var player2 = scores?['player2'];
              String result;
              if (scores?['result'] == 0) {
                result = "Draw!";
              } else if (scores?['result'] == 1) {
                result = "${player1} Won!";
              } else {
                result = "${player2} Won!";
              }
              return Padding(
                padding: EdgeInsets.all(4),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: Color(0xFFFAF9F6),
                  leading: CircleAvatar(child: Text('${total! - index}')),
                  title: Text("${player1} vs ${player2}"),
                  trailing: Text(result),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
