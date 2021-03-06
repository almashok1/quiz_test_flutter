import 'package:TestiGo/screens/quiz_page/test_mode_segment.dart';
import 'package:flutter/material.dart';
import 'package:TestiGo/localizationKeys/localizationKeys.dart';
import 'package:TestiGo/models/quiz_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:easy_localization/easy_localization.dart';

class TestMode extends StatefulWidget {
  final int size;
  TestMode(this.size);

  @override
  _TestModeState createState() => _TestModeState();
}

class _TestModeState extends State<TestMode> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuizModel>(builder: (context, child, model) {
      return ScopedModelDescendant<QuizModel>(
        builder: (context, child, model) => Scaffold(
            backgroundColor: Colors.deepOrange.shade400,
            appBar: new AppBar(
              title: Text(LocalizationKeys.test_mode_title).tr(),
              iconTheme: IconThemeData(color: Colors.deepPurple),
              backgroundColor: Colors.deepOrange.shade500,
            ),
            body: Container(
              color: Colors.deepOrange.shade400,
              child: SingleChildScrollView(
                  child: Column(
                children: [...getQuizQuestion(model), endQuiz(model)],
              )),
            )),
      );
    });
  }

  List<Widget> getQuizQuestion(QuizModel model) {
    List<Widget> list = [];
    final int sizeMin = widget.size > model.questions.length
        ? model.questions.length
        : widget.size;
    model.chosen = List(sizeMin);
    for (int i = 0; i < sizeMin; i++) {
      model.chosen[i] = null;
      list.add(TestModeSegment(i));
    }
    return list;
  }

  Widget endQuiz(QuizModel model) {
    int correctAnswers = 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
          child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        minWidth: MediaQuery.of(context).size.width * 0.8,
        color: Color(0xFF1C1428),
        child: Text(LocalizationKeys.test_mode_end,
                style: TextStyle(color: Colors.white, fontSize: 18.0))
            .tr(),
        onPressed: () {
          for (int i = 0; i < model.chosen.length; i++) {
            if (model.chosen[i] == null) {
              showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    backgroundColor: Color(0xFF1C1428),
                    child: Container(
                      height: 150,
                      child: Center(
                          child: Text(LocalizationKeys.test_mode_results_fill_all,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22.0))
                              .tr()),
                    )),
              );
              return;
            }
            if (model.questions[i].options[model.chosen[i]].answer)
              correctAnswers++;
          }
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ScopedModel<QuizModel>(
                  model: model,
                  child: QuizResults(correctAnswers: correctAnswers))));
        },
      )),
    );
  }
}

class QuizResults extends StatefulWidget {
  final int correctAnswers;
  const QuizResults({Key key, this.correctAnswers}) : super(key: key);

  @override
  _QuizResultsState createState() => _QuizResultsState();
}

class _QuizResultsState extends State<QuizResults> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuizModel>(
      builder: (context, child, model) => Scaffold(
        backgroundColor: Colors.deepPurple.shade900,
        appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text(LocalizationKeys.test_mode_results_title).tr()),
        body: Container(
            color: Colors.deepPurple.shade900,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(LocalizationKeys.test_mode_results_answer.tr(),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.deepOrange,
                                fontSize: 20.0))
                        .tr(args: [
                      widget.correctAnswers.toString(),
                      model.questions.length.toString()
                    ]),
                  ),
                  ...getQuizAnswers(model)
                ],
              ),
            )),
      ),
    );
  }

  List<Widget> getQuizAnswers(QuizModel model) {
    final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
      color: Colors.white,
    );
    List<Widget> list = [];
    for (int i = 0; i < model.chosen.length; i++) {
      list.add(Container(
          padding: EdgeInsets.all(5),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Text("${i + 1}"),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(model.questions[i].description,
                            softWrap: true, style: _questionStyle),
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
                            children: <Widget>[..._getOptionsList(i, model)],
                          ),
                        )),
                  )
                ],
              ))));
    }
    return list;
  }

  List<Widget> _getOptionsList(int n, QuizModel model) {
    List<Widget> list = [];
    for (int i = 0; i < model.questions[n].options.length; i++) {
      bool isAnswer = model.questions[n].options[i].answer;
      list.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: double.infinity,
              child: Text(model.questions[n].options[i].option,
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center),
            ),
          ),
          decoration: BoxDecoration(
              color: i == model.chosen[n]
                  ? isAnswer ? Colors.green.shade400 : Colors.red.shade300
                  : isAnswer ? Colors.green.shade400 : null,
              borderRadius: BorderRadius.circular(7.0)),
        ),
      ));
    }
    return list;
  }
}
