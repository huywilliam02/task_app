class Note {
  int? _id;
  String _title;
  String? _description;
  int _status;
  String _date;
  String _createdAt;
  String _updatedAt;
  int _priority;
  int _color;

  Note(this._title, this._date, this._priority, this._color, this._status,
      this._createdAt, this._updatedAt,
      [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority, this._color,
      this._status, this._createdAt, this._updatedAt,
      [this._description]);

  int? get id => _id;
  String get title => _title;
  String? get description => _description;
  int get status => _status;
  String get date => _date;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get priority => _priority;
  int get color => _color;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String? newDescription) {
    if (newDescription != null && newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set status(int newStatus) {
    if (newStatus == 0 || newStatus == 1) {
      _status = newStatus;
    }
  }

  set date(String date) {
    _date = date;
  }

  set createdAt(String newCreatedAt) {
    _createdAt = newCreatedAt;
  }

  set updatedAt(String newUpdatedAt) {
    _updatedAt = newUpdatedAt;
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 3) {
      _priority = newPriority;
    }
  }

  set color(int newColor) {
    if (newColor >= 0 && newColor <= 9) {
      _color = newColor;
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': _title,
      'description': _description,
      'status': _status,
      'date': _date,
      'createdAt': _createdAt,
      'updatedAt': _updatedAt,
      'priority': _priority,
      'color': _color,
    };
    if (_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  factory Note.fromMapObject(Map<String, dynamic> map) {
    return Note.withId(
      map['id'],
      map['title'] ?? '',
      map['date'] ?? '',
      map['priority'] ?? 1,
      map['color'] ?? 0,
      map['status'] ?? 0,
      map['createdAt'] ?? '',
      map['updatedAt'] ?? '',
      map['description'],
    );
  }
}
