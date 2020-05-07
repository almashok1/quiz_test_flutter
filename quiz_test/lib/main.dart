import 'package:flutter/material.dart';

import 'Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.deepOrange[200],
        appBarTheme: AppBarTheme(
          color: Colors.deepOrange[200],
          textTheme: TextTheme(
            title: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
          )
        )
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}     
