import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_test/models/quiz_model.dart';
import 'package:scoped_model/scoped_model.dart';

class QuizSegmentMode1 extends StatefulWidget {
  final int size;
  QuizSegmentMode1(this.size);
  @override
  _QuizSegmentMode1State createState() => _QuizSegmentMode1State();
}

class _QuizSegmentMode1State extends State<QuizSegmentMode1> {
  int _questionNumber = 0;
  final TextStyle _questionStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    color: Colors.white,
  );
  int correctAnswers = 0;
  int currentValue = -1;
  bool selectedOnce = false;
  int size;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuizModel>(builder: (context, child, model) {
      size = widget.size > model.questions.length ? model.questions.length : widget.size;
      return Container(
          padding: EdgeInsets.all(5),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Text("${_questionNumber + 1}"),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                            model.questions[_questionNumber].description,
                            softWrap: true,
                            style: _questionStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    child: Card(
                        color: Colors.white70,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[..._getOptionsList(model)],
                          ),
                        )),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        onPressed: () async {
                          if (!selectedOnce) return;
                          if (_questionNumber + 1 == size) {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      backgroundColor: Colors.deepOrange[400],
                                      child: Container(
                                        height: MediaQuery.of(context).size.height/2.5,
                                        child: Center(
                                          child: Text(
                                            "Правильно $correctAnswers из $size",
                                            style: TextStyle(
                                                color: Colors.deepPurple.shade800,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Montserrat',
                                                fontSize: 24.0
                                            ),
                                          ),
                                        ),
                                      ));
                                }).then((val) {
                              Navigator.pop(context);
                            });
                            return;
                          }
                          setState(() {
                            _questionNumber++;
                            selectedOnce = false;
                            currentValue = -1;
                          });
                        },
                        child: Icon(
                          CupertinoIcons.right_chevron,
                          color: Colors.white,
                          size: 60.0,
                        ),
                      ))
                ],
              )));
    });
  }

  List<Widget> _getOptionsList(QuizModel model) {
    int n = _questionNumber;
    List<Widget> list = [];
    for (int i = 0; i < model.questions[n].options.length; i++) {
      bool isAnswer = model.questions[n].options[i].answer;
      list.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          child: MaterialButton(
            height: 55,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            highlightColor: Colors.deepOrange[300],
            onPressed: () {
              setState(() {
                if (selectedOnce) return;
                if (model.questions[n].options[i].answer) correctAnswers++;
                currentValue = i;
                selectedOnce = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: double.infinity,
                child: Text(model.questions[n].options[i].option,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center),
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: currentValue != -1
                  ? model.questions[n].options[currentValue].answer &&
                          i == currentValue
                      ? Colors.green.shade400
                      : i == currentValue
                          ? Colors.red.shade300
                          : isAnswer ? Colors.green.shade400 : null
                  : null,
              border: Border.all(color: Colors.deepPurple.shade800, width: 1.7),
              borderRadius: BorderRadius.circular(7.0)),
        ),
      ));
    }
    return list;
  }
}
