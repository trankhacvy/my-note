class NoteLabel {
  static const TABLE_NAME = 'tbl_note_label';

  static const DB_ID = 'id';
  static const DB_NOTE_ID = 'note_id';
  static const DB_LABEL_ID = 'label_id';

  int _id;
  int _noteId;
  int _labelId;

  NoteLabel.create(this._noteId, this._labelId);

//  NoteLabel.fromMap(Map<String, dynamic> map){
//    this._id = map[DB_ID];
//    this._name = map[DB_NAME];
//    this._createdAt = DateTime.fromMicrosecondsSinceEpoch(map[DB_CREATED_AT]);
//  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = <String, dynamic>{
      DB_NOTE_ID: _noteId,
      DB_LABEL_ID: _labelId,
    };
    if(_id != null) {
      map[DB_ID] = _id;
    }

    return map;
  }

  int get labelId => _labelId;

  set labelId(int value) {
    _labelId = value;
  }

  int get noteId => _noteId;

  set noteId(int value) {
    _noteId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}