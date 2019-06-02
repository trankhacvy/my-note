class Label {
  static const TABLE_NAME = 'tbl_labels';

  static const DB_ID = 'id';
  static const DB_NAME = 'title';
  static const DB_CREATED_AT = 'created_at';

  int _id;
  String _name;
  int _createdAt;

  Label(this._id, this._name);

  Label.create(this._name){
    _createdAt = DateTime.now().millisecondsSinceEpoch;
  }

  Label.fromMap(Map<String, dynamic> map){
    this._id = map[DB_ID];
    this._name = map[DB_NAME];
    this._createdAt = map[DB_CREATED_AT];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = <String, dynamic>{
      DB_NAME: _name,
      DB_CREATED_AT: _createdAt,
    };
    if(_id != null) {
      map[DB_ID] = _id;
    }

    return map;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  int get createdAt => _createdAt;

  set createdAt(int value) {
    _createdAt = value;
  }

  set name(String value) {
    _name = value;
  }

  @override
  String toString() {
    return 'Label{_id: $_id, _name: $_name, _createdAt: $_createdAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Label &&
              runtimeType == other.runtimeType && other.id == _id;

  @override
  int get hashCode =>
      _id.hashCode ^ _name.hashCode ^ _createdAt.hashCode;


}

class LabelInNote {
  Label label;
  bool isAdded;
  bool isNew;
  bool isDeleted;

  LabelInNote.copyFromExist(this.label){
    isAdded = true;
    isNew = false;
    isDeleted = false;
  }

  LabelInNote.addNew(this.label){
    isNew = true;
    isDeleted = false;
  }
}