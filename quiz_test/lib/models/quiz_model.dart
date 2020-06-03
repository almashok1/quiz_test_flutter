import 'package:TestiGo/models/quiz_objects/question.dart';
import 'package:scoped_model/scoped_model.dart';

class QuizModel extends Model{
  List<int> chosen;
  List<Question> questions;
}