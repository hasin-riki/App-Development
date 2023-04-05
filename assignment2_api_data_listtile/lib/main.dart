import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:assignment2_hasin/Models/CommentsModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment 2',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Comments'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<CommentsModel>>? _comments;

  @override
  void initState() {
    _comments = getComments();
    super.initState();
  }

  Future<List<CommentsModel>>? getComments() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<CommentsModel>((json) => CommentsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<Future<List<CommentsModel>>?> _refresh(BuildContext context) async {
    _comments = getComments();
    setState(() {});
    return _comments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: FutureBuilder(
                  future: _comments,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      var data=snapshot.data!;
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30))),
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 16, 2, 2),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 5),
                                              child: RichText(
                                                text: TextSpan(
                                                    text: "Post Id : ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                    children: [
                                                      TextSpan(
                                                          text: data[index]
                                                              .postId
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                                    ]),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 5),
                                              child: RichText(
                                                text: TextSpan(
                                                    text: "Id : ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                    children: [
                                                      TextSpan(
                                                          text: data[index]
                                                              .id
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                                    ]),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 5),
                                              child: RichText(
                                                text: TextSpan(
                                                    text: "Name : ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                    children: [
                                                      TextSpan(
                                                          text: data[index]
                                                              .name
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                                    ]),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 5),
                                              child: RichText(
                                                text: TextSpan(
                                                    text: "Email : ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                    children: [
                                                      TextSpan(
                                                          text: data[index]
                                                              .email
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                                    ]),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 5),
                                              child: RichText(
                                                text: TextSpan(
                                                    text: "Body : ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                    children: [
                                                      TextSpan(
                                                          text: data[index]
                                                              .body
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                                    ]),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Card(
                                child: ListTile(
                                  leading:
                                      CircleAvatar(child: Text('${index + 1}')),
                                  title: Text(data[index].name.toString()),
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ),
        ]),
      ),
    );
  }
}
