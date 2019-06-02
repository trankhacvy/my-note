import '../models/note.dart';
import '../models/label.dart';
import '../models/note_label.dart';
import 'db_provider.dart';

class NoteLabelRepository {
  static final NoteLabelRepository _NoteLabelRepository = NoteLabelRepository._(AppDatabase.appDatabase);

  AppDatabase _appDatabase;

  NoteLabelRepository._(this._appDatabase);

  static NoteLabelRepository get(){
    return _NoteLabelRepository;
  }

  Future<NoteLabel> save(Note note, Label label) async {
    var db = await _appDatabase.database;
    NoteLabel noteLabel = NoteLabel.create(note.id, label.id);
    var id = await db.insert(NoteLabel.TABLE_NAME, noteLabel.toMap());
    noteLabel.id = id;

    return noteLabel;
  }

  Future<Null> saveMany(Note note, List<Label> labels) async {
    var db = await _appDatabase.database;
    var batch = db.batch();
    NoteLabel noteLabel;
    for(var i = 0; i < labels.length; i++) {
      noteLabel = NoteLabel.create(note.id, labels[0].id);
      batch.insert(NoteLabel.TABLE_NAME, noteLabel.toMap());
    }
    await batch.commit(noResult: true);
  }

}