import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:midterm_exam/APIDataModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midterm Exam',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(title: 'Products'),
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
  List<APIDataModel> products = [];

  Future<List<APIDataModel>> getProductsApi() async {
    final url = Uri.parse(
        'https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline');
    final response = await http.get(url);
    final body = jsonDecode(response.body.toString());
    for (Map i in body) {
      products.add(APIDataModel.fromJson(i));
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: getProductsApi(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: Image.network(
                                          products[index].imageLink.toString()),
                                      title:
                                          Text(products[index].name.toString()),
                                      subtitle: Text(
                                          products[index].description.toString()),
                                    ),
                                    ListTile(
                                      leading: Text("Brand: " +
                                          (products[index].brand.toString())),
                                      trailing: RichText(
                                          text: TextSpan(
                                              text: "Price: ",
                                              style:
                                                  TextStyle(color: Colors.black),
                                              children: [
                                            TextSpan(
                                                text: "\$ ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700)),
                                            TextSpan(
                                                text: (products[index]
                                                    .price
                                                    .toString()))
                                          ])),
                                    ),
                                    ListTile(
                                      leading: RichText(
                                          text: TextSpan(
                                              text: "Product Type: ",
                                              style: TextStyle(color: Colors.black),
                                              children: [
                                            TextSpan(
                                                text: (products[index]
                                                    .productType
                                                    .toString()),
                                                style: TextStyle(
                                                    color: Colors.brown))
                                          ])),
                                      trailing: RichText(
                                          text: TextSpan(
                                              text: "Rating: ",
                                              style: TextStyle(color: Colors.black),
                                              children: [
                                                TextSpan(
                                                    text: (products[index]
                                                        .rating
                                                        .toString()),
                                                    style: TextStyle(
                                                        color: Colors.red))
                                              ]))
                                    ),
                                    ListTile(
                                      trailing: Container(
                                        width: 20.0,
                                        height: 20.0,
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),)
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image.network(
                              products[index].imageLink.toString()),
                          title: Text(products[index].name.toString()),
                          trailing:
                              Text('\$ ' + (products[index].price.toString())),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}