import 'dart:io' show Directory, File, FileSystemException;

import 'package:TestiGo/models/quiz_model.dart';
import 'package:TestiGo/models/quiz_objects/option.dart';
import 'package:TestiGo/models/quiz_objects/question.dart';
import 'package:TestiGo/screens/about.dart';
import 'package:TestiGo/screens/quiz_page/preparation_mode.dart';
import 'package:TestiGo/screens/quiz_page/test_mode.dart';
import 'package:TestiGo/screens/search.dart';
import 'package:TestiGo/localizationKeys/localizationKeys.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:easy_localization/easy_localization.dart';


enum Additions { about, locale }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PermissionStatus _storageStatus;
  double _selectQuestions = 20.0;
  final QuizModel _model = QuizModel();
  File _localFile;
  static const convert_platform = const MethodChannel('quiztest/fileconvert');

  static TextStyle textStyle(Color color, double size) {
    return TextStyle(color: color, fontFamily: 'Montserrat', fontSize: size);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<QuizModel>(
      model: _model,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.deepOrange.shade400,
        body: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top + 50.0),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Testi',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.deepPurple.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0)),
                      Text('Go',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 40.0))
                    ],
                  ),
                  PopupMenuButton<Additions>(
                      color: Color(0xFF1C1428),
                      onSelected: (Additions result) {
                        switch (result) {
                          case Additions.about:
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => About()));
                            break;
                          default: return;
                        }
                        
                      },
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => <PopupMenuEntry<Additions>>[
                            PopupMenuItem<Additions>(
                                value: Additions.about,
                                child: Text(LocalizationKeys.about_title,
                                        style: TextStyle(color: Colors.white))
                                    .tr())
                          ])
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height - 185.0,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade600,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(75.0)),
                ),
                child: ListView(
                  primary: false,
                  padding: EdgeInsets.only(left: 25.0, right: 20.0),
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 45.0),
                        child: Container(
                            height: MediaQuery.of(context).size.height - 300.0,
                            child: FutureBuilder(
                              future: _getFilesFromDirectory(context),
                              builder: (BuildContext futureContext,
                                  AsyncSnapshot<List<Widget>> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView(children: snapshot.data);
                                }
                                return CircularProgressIndicator();
                              },
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 65.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xFF1C1428)),
                            child: Center(
                                child: FlatButton(
                                    onPressed: () async {
                                      await _askPermission();
                                      _localFile = await FilePicker.getFile(
                                          type: FileType.ANY);
                                      final wordExtensions = [
                                        '.doc',
                                        '.docx',
                                        '.txt'
                                      ];
                                      if (!wordExtensions.contains(
                                          extension(_localFile.path))) {
                                        _showErrorSnackBar(context,
                                            LocalizationKeys.exception_correct_file.tr());
                                        return;
                                      }

                                      await _read(context);
                                      setState(() {});
                                    },
                                    child: Text(
                                            LocalizationKeys.home_upload_test,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.white,
                                                fontSize: 15.0))
                                        .tr())),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _read(BuildContext context, {String file}) async {
    _model.questions = new List<Question>();

    try {
      if (file != null) {
        List<String> list = File(file).readAsLinesSync();
        processLinesWithVariant(list);
        if (_model.questions.isEmpty) {
          throw FileSystemException();
        }
        return;
      }
      final wordExtensions = ['.doc', '.docx'];
      final ext = extension(_localFile.path);
      String externalPath = await getExternalPath;
      if (wordExtensions.contains(ext)) {
        var map = <String, dynamic>{
          'filePath': _localFile.path,
          'externalPath': externalPath,
        };
        int t = await convert_platform.invokeMethod('convertWordToTxt', map);

        _localFile = File(join(
            externalPath, basenameWithoutExtension(_localFile.path) + ".txt"));
      } else if (ext == '.txt') {
        File copying = File(join(
            externalPath, basenameWithoutExtension(_localFile.path) + ".txt"));
        if (!copying.existsSync()) _localFile.copySync(copying.path);
      }
      List<String> list = _localFile.readAsLinesSync();
      processLinesWithVariant(list);
      if (_model.questions.isEmpty) {
        throw FileSystemException();
      }
    } catch (e) {
      _localFile.deleteSync();
      _showErrorSnackBar(context, LocalizationKeys.exception_cannot_read.tr());
    }
  }

  void _showErrorSnackBar(BuildContext context, String text) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(text)));
  }

  void _showModalBottomSheet(BuildContext context, {String file}) {
    showModalBottomSheet(
        backgroundColor: Colors.black45,
        isDismissible: false,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (BuildContext incontext) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffff5848), Color(0xffff9a44)],
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0, 2.0),
                                blurRadius: 5.0),
                          ]),
                      height: 150,
                      child: Center(
                        child: Text(
                          LocalizationKeys.test_mode_title,
                          style: textStyle(Colors.white, 20.0),
                        ).tr(),
                      )),
                ),
                onPressed: () async {
                  try {
                    Navigator.of(context).pop();
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return WillPopScope(
                            onWillPop: () async => false,
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              ),
                            ),
                          );
                        });
                    await _read(context, file: file);
                  } catch (e) {
                    _showErrorSnackBar(context, LocalizationKeys.exception_cannot_read.tr());
                    return;
                  }
                  _model.questions =
                      _model.questions.take(_selectQuestions.round()).toList();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ScopedModel<QuizModel>(
                          model: _model,
                          child: TestMode(_selectQuestions.round()))));
                },
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        LocalizationKeys.amount_of_questions,
                        style: textStyle(Colors.white, 17.0),
                      ).tr(),
                    ),
                    StatefulBuilder(builder: (BuildContext context, setState) {
                      return Slider.adaptive(
                          activeColor: Colors.deepOrange,
                          min: 10.0,
                          max: 200.0,
                          divisions: 19,
                          value: _selectQuestions,
                          label: _selectQuestions == 200.0
                              ? LocalizationKeys.all.tr()
                              : '${_selectQuestions.round()}',
                          onChanged: (newValue) {
                            setState(() {
                              _selectQuestions = newValue;
                            });
                          });
                    }),
                  ],
                ),
              ),
              FlatButton(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff2b5876), Color(0xff4e4376)],
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0, 2.0),
                                blurRadius: 5.0),
                          ]),
                      height: 150,
                      child: Center(
                        child: Text(
                          LocalizationKeys.preparation_mode_title,
                          style: textStyle(Colors.white, 20.0),
                        ).tr(),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      Navigator.of(context).pop();
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                ),
                              ),
                            );
                          });
                      await _read(context, file: file);
                    } catch (e) {
                      _showErrorSnackBar(context, LocalizationKeys.exception_cannot_read.tr());
                      return;
                    }
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ScopedModel<QuizModel>(
                            model: _model,
                            child: PreparationMode(_selectQuestions.round()))));
                  }),
            ],
          );
        });
  }

  Future<String> get getExternalPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  processLinesWithVariant(List<String> lines) {
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].trim().contains('<question>')) {
        Question question =
            Question(lines[i].replaceFirst("<question>", "").trim());
        ++i;
        if (i >= lines.length - 1) break;
        bool isFirst = true;
        while (lines[i].trim().contains('<variant>') && i < lines.length) {
          question.addOption(
              Option(lines[i].replaceFirst("<variant>", "").trim(), isFirst));
          isFirst = false;
          i++;
          if (i >= lines.length - 1) break;
        }
        question.options.shuffle();
        _model.questions.add(question);
      }
    }
    _model.questions.shuffle();
  }

  Future _askPermission() async {
    await PermissionHandler()
        .requestPermissions([PermissionGroup.storage]).then(_onStatusRequested);
  }

  void _onStatusRequested(
      Map<PermissionGroup, PermissionStatus> statuses) async {
    final status = statuses[PermissionGroup.storage];
    if (status != PermissionStatus.granted)
      await PermissionHandler().openAppSettings();
    else
      _updateStatus(status);
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _storageStatus) {
      setState(() {
        _storageStatus = status;
      });
    }
  }

  Future<List<Widget>> _getFilesFromDirectory(BuildContext context) async {
    final dir = Directory(await getExternalPath);
    final files = await dir.list().toList();
    List<Widget> list = [];
    for (var file in files) {
      list.add(Container(
        margin: EdgeInsets.symmetric(vertical: 15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 2.0),
                  blurRadius: 5.0)
            ],
            color: Colors.deepOrange[300],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 60.0,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF1C1428)),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Search(file: File(file.path))));
                  },
                  child: Center(
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: FlatButton(
                    child: Text(basenameWithoutExtension(file.path),
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.deepPurple.shade900,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      _showModalBottomSheet(context, file: file.path);
                    }),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  child: Center(
                      child: Icon(Icons.delete_outline, color: Colors.white)),
                  onPressed: () {
                    File willBeDeletedFile = File(file.path);
                    willBeDeletedFile.deleteSync();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return list;
  }
}
