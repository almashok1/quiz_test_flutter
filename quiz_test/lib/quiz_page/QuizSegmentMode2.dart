import 'package:flutter/material.dart';
import 'package:quiz_test/models/quiz_model.dart';
import 'package:scoped_model/scoped_model.dart';

class QuizSegmentMode2 extends StatefulWidget {
  final int _questionNumber;
  QuizSegmentMode2(this._questionNumber);

  @override
  _QuizSegmentMode2State createState() => _QuizSegmentMode2State();
}

class _QuizSegmentMode2State extends State<QuizSegmentMode2> {
  final TextStyle _questionStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    color: Color(0xFF1C1428),
  );
  int _currentValue = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuizModel>(
        builder: (BuildContext context, Widget child, QuizModel model) {
      return Container(
          padding: EdgeInsets.all(5),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Color(0xFF1C1428),
                        child: Text("${widget._questionNumber + 1}", style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                            model.questions[widget._questionNumber].description,
                            softWrap: true,
                            style: _questionStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    color: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[...getRadioList(model)],
                        ),
                      ))
                ],
              )));
    });
  }

  List<Widget> getRadioList(QuizModel model) {
    List<Widget> list = [];
    for (int i = 0;
        i < model.questions[widget._questionNumber].options.length;
        i++) {
      list.add(RadioListTile(
          dense: false,
          activeColor: Color(0xFF1C1428),
          title: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: i == _currentValue ? Color(0xFF1C1428) : null,
              ),
              child: Text(
                model.questions[widget._questionNumber].options[i].option,
                style: TextStyle(color: i == _currentValue ? Colors.white : Color(0xFF1C1428)),
              )),
          value: i,
          groupValue: _currentValue,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
              model.chosen[widget._questionNumber] = _currentValue;
            });
          }));
    }
    return list;
  }
}
