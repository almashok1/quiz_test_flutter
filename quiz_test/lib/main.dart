import 'package:TestiGo/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ru')
      ],
      path: 'assets/translations',
      child: StartApp()
    );
  }
}

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
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
