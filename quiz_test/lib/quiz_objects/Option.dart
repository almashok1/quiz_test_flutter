class Option {
  var _isAnswer = false;
  String _option;
  
  Option(this._option, [this._isAnswer]);
  bool get answer {
    return _isAnswer;
  }
  set answer(bool answer) {
    this._isAnswer = answer;
  }

  String get option {
    return _option;
  }

  set option(String o) {
    _option = o;
  }

  @override
  String toString() {
    return _option + " " + _isAnswer.toString();
  }
}