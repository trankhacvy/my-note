import 'package:todo_list/src/models/label.dart';

class Note {
  static const TABLE_NAME = 'tbl_notes';

  static const DB_ID = 'id';
  static const DB_TITLE = 'title';
  static const DB_CONTENT = 'content';
  static const DB_COLOR = 'color';
  static const DB_DONE = 'done';
  static const DB_IMAGE = 'image';
  static const DB_CREATED_AT = 'created_at';

  int _id;
  String _title;
  String _content;
  bool _isDone;
  int _createdAt;
  int _color;
  String _image;
  List<Label> _labels;

  Note(this._title, this._content, this._color, this._image, this._isDone,
      this._createdAt);

  Note.create(this._title, this._content, this._color) {
    _isDone = false;
    _createdAt = DateTime.now().millisecondsSinceEpoch;
    _labels = List();
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map[DB_ID];
    this._title = map[DB_TITLE];
    this._content = map[DB_CONTENT];
    this._color = map[DB_COLOR];
    this._isDone = map[DB_DONE] == 1;
    this._image = map[DB_IMAGE];
    this._createdAt = map[DB_CREATED_AT];

    this._labels = List();
    var labelNamesStr = map["labelNames"];
    if (labelNamesStr != null) {
      List<String> labelNames = labelNamesStr.toString().split(",");
      var labelIdsStr = map["labelIds"];
      List<int> labelIds =
          labelIdsStr.toString().split(",").map((i) => int.parse(i)).toList();
      Label label;
      labelNames.asMap().forEach((index, value) {
        label = Label(labelIds.elementAt(index), value);
        this._labels.add(label);
      });
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      DB_TITLE: _title,
      DB_CONTENT: _content,
      DB_COLOR: _color,
      DB_IMAGE: _image,
      DB_DONE: _isDone ? 1 : 0,
      DB_CREATED_AT: _createdAt,
    };
    if (_id != null) {
      map[DB_ID] = _id;
    }

    return map;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get content => _content;

  int get createdAt => _createdAt;

  set createdAt(int value) {
    _createdAt = value;
  }

  bool get isDone => _isDone;

  set isDone(bool value) {
    _isDone = value;
  }

  set content(String value) {
    _content = value;
  }

  int get color => _color;

  set color(int value) {
    _color = value;
  }

  List<Label> get labels => _labels;

  String get image => _image;

  @override
  String toString() {
    return 'Task{_id: $_id, _title: $_title, _content: $_content, _isDone: $_isDone, _createdAt: $_createdAt, _color: $_color, _labels: $_labels}';
  }
}
