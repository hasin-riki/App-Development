import 'package:flutter/material.dart';

bool _icon = false;
IconData _iconLight = Icons.sunny;
IconData _iconDark = Icons.dark_mode;
ThemeData _themeLight = ThemeData(primarySwatch: Colors.blue);
ThemeData _themeDark = ThemeData.dark();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      theme: _icon ? _themeDark : _themeLight,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Assignment 1'),
          actions: [
            IconButton(
              icon: Icon(_icon ? _iconLight : _iconDark),
              onPressed: () {
                setState(() {
                  _icon = !_icon;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.75,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/android_logo.png',
                    height: 160,
                    width: 160,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'EMAIL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.lightGreen[500],
                      ),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'abc@live.com',
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightGreen, width: 1)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'PASSWORD',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.lightGreen[500],
                      ),
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '**********',
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightGreen, width: 1)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.lightGreen[500],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'LOGIN',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      backgroundColor: Colors.lightGreen[500],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Divider(
                        thickness: 2,
                      )),
                      Text(
                        'OR CONNECT WITH',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 2,
                      )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.facebook,
                          color: Colors.white,
                          size: 22,
                        ),
                        label: Text('FACEBOOK'),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            backgroundColor: Colors.blue[800],
                            minimumSize: Size(150, 45)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.alarm,
                        ),
                        label: Text('GOOGLE'),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            backgroundColor: Colors.red[800],
                            minimumSize: Size(150, 45)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
