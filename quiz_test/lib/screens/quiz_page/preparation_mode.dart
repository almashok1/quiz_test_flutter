import 'package:TestiGo/screens/quiz_page/preparation_mode_segment.dart';
import 'package:flutter/material.dart';
import 'package:TestiGo/localizationKeys/localizationKeys.dart';
import 'package:TestiGo/models/quiz_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:easy_localization/easy_localization.dart';


class PreparationMode extends StatefulWidget {
  final int size;

  PreparationMode(this.size);

  @override
  _PreparationModeState createState() => _PreparationModeState();
}

class _PreparationModeState extends State<PreparationMode> {
  
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuizModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.deepPurple.shade500,
            title: Text(LocalizationKeys.preparation_mode_title).tr()
          ),
          body: Container(
            constraints: BoxConstraints.expand(),
            color: Colors.deepPurple.shade800,
            child: Center(
              child: SingleChildScrollView(
                child: PreparationModeSegment(widget.size),
              ),
            ),
          )
        );
      }
    );
  }
}
