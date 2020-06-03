import 'package:flutter/material.dart';
import 'package:TestiGo/localizationKeys/localizationKeys.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
            backgroundColor: Color(0xFF1C1428),
            title: Text(LocalizationKeys.about_title).tr()),
        body: Center(
            child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: double.infinity,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    LocalizationKeys.language,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 25),
                  ).tr(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          color: EasyLocalization.of(context)
                                      .locale
                                      .languageCode ==
                                  'en'
                              ? Colors.deepOrange[900]
                              : null,
                          onPressed: () {
                            EasyLocalization.of(context).locale = Locale("en");
                          },
                          child: Text("EN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 20))),
                      FlatButton(
                          color: EasyLocalization.of(context)
                                      .locale
                                      .languageCode ==
                                  'ru'
                              ? Colors.deepOrange[900]
                              : null,
                          onPressed: () {
                            EasyLocalization.of(context).locale = Locale("ru");
                          },
                          child: Text("RU",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 20)))
                    ],
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(LocalizationKeys.about_developers,
                          style: TextStyle(
                              color: Colors.deepOrange[800],
                              fontSize: 30.0,
                              fontFamily: 'Montserrat'))
                      .tr(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Card(
                    color: Colors.deepOrange[900],
                    child: ListTile(
                        title: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Text("Almas Tanayev",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontFamily: 'Montserrat'))),
                        subtitle: InkWell(
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.contact_mail),
                                    SizedBox(width: 20.0),
                                    Text("Telegram",
                                        style: TextStyle(
                                            color: Color(0xFF1C1428),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            fontFamily: 'Montserrat'))
                                  ],
                                )),
                            onTap: () => launch('http://t.me/almashok1'))),
                  ),
                  Card(
                    color: Colors.deepOrange[900],
                    child: ListTile(
                        title: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Text("Ramazan Maulen",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontFamily: 'Montserrat'))),
                        subtitle: InkWell(
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.contact_mail),
                                    SizedBox(width: 20.0),
                                    Text("Telegram",
                                        style: TextStyle(
                                            color: Color(0xFF1C1428),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            fontFamily: 'Montserrat'))
                                  ],
                                )),
                            onTap: () => launch('http://t.me/ramazan_maulen'))),
                  ),
                ],
              )
            ],
          )),
        )));
  }
}
