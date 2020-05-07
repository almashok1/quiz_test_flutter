import 'Option.dart';

class Question {
  String description;
  List<Option> _options = new List<Option>();
  
  Question(this.description);

  List<Option> get options {
    return _options;
  }

  void set options(List<Option> q) {
    _options = q;
  }

  void addOption(Option o) {
    _options.add(o);
  }
  @override
  String toString() {
    String temp = description;
    for (var option in _options) {
      temp+="\n"+option.toString();
    }
    return temp;
  }
}