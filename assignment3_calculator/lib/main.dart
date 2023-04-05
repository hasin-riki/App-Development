import 'package:flutter/material.dart';
import './calculator.dart';
import 'package:provider/provider.dart';

ThemeData _themeLight = ThemeData(primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white60);
ThemeData _themeDark = ThemeData(scaffoldBackgroundColor: Colors.black, iconTheme: IconThemeData(color: Colors.orange));

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChange()),
        ChangeNotifierProvider(create: (_) => CalculatorFunctions())
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme:
          context.watch<ThemeChange>().icon ? _themeDark : _themeLight,
      home: const MyHomePage(title: 'Calculator'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Calculator(),
    );
  }
}
