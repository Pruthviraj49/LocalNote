// ignore_for_file: unnecessary_null_comparison, prefer_collection_literals

class Model {
  late int _id = 1;
  late String _title;
  late String _description;
  late String _date;
  late int _priority;

  Model(this._title, this._date, this._priority, this._description);
  Model.withId(
      this._id, this._title, this._date, this._priority, this._description);

  int get id => _id;
  int get priority => _priority;
  String get description => _description;
  String get date => _date;
  String get title => _title;

  set title(String newTitle) {
    if (newTitle.length <= 100) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 250) {
      _description = newDescription;
    }
  }

  set date(String newdate) {
    _date = newdate;
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  Model.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _priority = map['priority'];
    _date = map['date'];
  }
}
