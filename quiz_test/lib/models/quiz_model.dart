import 'package:quiz_test/quiz_objects/Question.dart';
import 'package:scoped_model/scoped_model.dart';

class QuizModel extends Model{
  List<int> chosen;
  List<Question> questions;
}