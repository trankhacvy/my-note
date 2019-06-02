import 'package:todo_list/src/models/note.dart';
import '../models/label.dart';
import '../models/note_label.dart';
import 'db_provider.dart';

class NoteRepository {
  static final NoteRepository _noteRepository =
      NoteRepository._(AppDatabase.appDatabase);

  AppDatabase _appDatabase;

  NoteRepository._(this._appDatabase);

  static NoteRepository get() {
    return _noteRepository;
  }

  Future getAll() async {
    var db = await _appDatabase.database;
    var result = await db.rawQuery(
        "SELECT ${Note.TABLE_NAME}.*, GROUP_CONCAT(${Label.TABLE_NAME}.${Label.DB_ID}) as labelIds, GROUP_CONCAT(${Label.TABLE_NAME}.${Label.DB_NAME}) as labelNames "
        "FROM ${Note.TABLE_NAME} "
        "LEFT JOIN ${NoteLabel.TABLE_NAME} "
        "ON ${Note.TABLE_NAME}.${Note.DB_ID} = ${NoteLabel.TABLE_NAME}.${NoteLabel.DB_NOTE_ID} "
        "LEFT  JOIN ${Label.TABLE_NAME} "
        "ON ${Label.TABLE_NAME}.${Label.DB_ID} = ${NoteLabel.TABLE_NAME}.${NoteLabel.DB_LABEL_ID} "
        "GROUP BY ${Note.TABLE_NAME}.${Note.DB_ID} "
        "ORDER BY ${Note.DB_CREATED_AT} DESC;");
    List<Note> notes = result.map((map) => Note.fromMap(map)).toList();

    return notes;
  }

  Future<List<Note>> findNotesByLabel(Label label) async {
    var db = await _appDatabase.database;

    var result = await db.rawQuery(
        "SELECT ${Note.TABLE_NAME}.*, GROUP_CONCAT(${Label.TABLE_NAME}.${Label.DB_ID}) as labelIds, GROUP_CONCAT(${Label.TABLE_NAME}.${Label.DB_NAME}) as labelNames "
        "FROM ${Note.TABLE_NAME} "
        "LEFT JOIN ${NoteLabel.TABLE_NAME} "
        "ON ${Note.TABLE_NAME}.${Note.DB_ID} = ${NoteLabel.TABLE_NAME}.${NoteLabel.DB_NOTE_ID} "
        "LEFT  JOIN ${Label.TABLE_NAME} "
        "ON ${Label.TABLE_NAME}.${Label.DB_ID} = ${NoteLabel.TABLE_NAME}.${NoteLabel.DB_LABEL_ID} "
        "GROUP BY ${Note.TABLE_NAME}.${Note.DB_ID} "
        "HAVING labelNames LIKE '%${label.name}%' "
        "ORDER BY ${Note.DB_CREATED_AT} DESC;");

    List<Note> notes = result.map((map) => Note.fromMap(map)).toList();

    return notes;
  }

  Future save(Note note, List<int> addedLabelId, List<int> removedLabelIds) async {
    var db = await _appDatabase.database;
    await db.transaction((txn) async {
      int id = await txn.rawInsert('INSERT OR REPLACE INTO '
          '${Note.TABLE_NAME}(${Note.DB_ID},${Note.DB_TITLE},${Note.DB_CONTENT},${Note.DB_COLOR}, ${Note.DB_IMAGE},${Note.DB_CREATED_AT})'
          ' VALUES(${note.id}, "${note.title}", "${note.content}",${note.color}, "${note.image}", ${note.createdAt})');
      if (id > 0 && addedLabelId != null && addedLabelId.length > 0) {
        addedLabelId.forEach((labelId) {
          txn.rawInsert('INSERT OR REPLACE INTO '
              '${NoteLabel.TABLE_NAME}(${NoteLabel.DB_ID},${NoteLabel.DB_NOTE_ID},${NoteLabel.DB_LABEL_ID})'
              ' VALUES(null, $id, $labelId)');
        });
      }
      // remove label note
      if (id > 0 && removedLabelIds != null && removedLabelIds.length > 0) {
        removedLabelIds.forEach((labelId) {
          txn.rawDelete('DELETE FROM ${NoteLabel.TABLE_NAME} WHERE ${NoteLabel.TABLE_NAME}.${NoteLabel.DB_NOTE_ID} = $id AND ${NoteLabel.TABLE_NAME}.${NoteLabel.DB_LABEL_ID} = $labelId');
        });
      }

    });
  }

  Future<int> update(Note note) async {
    var db = await _appDatabase.database;
    return await db.update(Note.TABLE_NAME, note.toMap(),
        where: '${Note.DB_ID} = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    var db = await _appDatabase.database;
    return db.transaction((txn){
      txn.rawDelete("DELETE FROM ${Note.TABLE_NAME} where ${Note.TABLE_NAME}.${Note.DB_ID} = $id");
    });
  }
}
