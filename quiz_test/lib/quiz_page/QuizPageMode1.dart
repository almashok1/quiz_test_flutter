import 'package:flutter/material.dart';
import 'package:quiz_test/models/quiz_model.dart';
import 'package:quiz_test/quiz_page/QuizSegmentMode1.dart';
import 'package:scoped_model/scoped_model.dart';


class QuizPageMode1 extends StatefulWidget {
  final int size;

  QuizPageMode1(this.size);

  @override
  _QuizPageMode1State createState() => _QuizPageMode1State();
}

class _QuizPageMode1State extends State<QuizPageMode1> {
  
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuizModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.deepPurple.shade500,
            title: Text("Режим Тестирования")
          ),
          body: Container(
            constraints: BoxConstraints.expand(),
            color: Colors.deepPurple.shade800,
            child: Center(
              child: SingleChildScrollView(
                child: QuizSegmentMode1(widget.size),
              ),
            ),
          )
        );
      }
    );
  }
}
