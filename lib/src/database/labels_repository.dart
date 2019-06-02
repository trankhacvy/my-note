import '../models/label.dart';
import 'db_provider.dart';

class LabelRepository {
  static final LabelRepository _labelRepository = LabelRepository._(AppDatabase.appDatabase);

  AppDatabase _appDatabase;

  LabelRepository._(this._appDatabase);

  static LabelRepository get(){
    return _labelRepository;
  }

  Future<List<Label>> findAll() async {
    var db = await _appDatabase.database;
    var result = await db.rawQuery("SELECT * FROM ${Label.TABLE_NAME} ORDER BY ${Label.DB_CREATED_AT} DESC");

    return result.map((map) => Label.fromMap(map)).toList();
  }

  Future save(Label label) async {
    var db = await _appDatabase.database;
    return await db.transaction((txn) async {
      return await txn.rawInsert('INSERT OR REPLACE INTO '
          '${Label.TABLE_NAME}(${Label.DB_ID},${Label.DB_NAME},${Label.DB_CREATED_AT})'
          ' VALUES(${label.id}, "${label.name}", ${label.createdAt})');
    });
  }

  Future<int> update(Label label) async {
    var db = await _appDatabase.database;
    return await db.update(Label.TABLE_NAME, label.toMap(),
        where: '${Label.DB_ID} = ?', whereArgs: [label.id]);
  }

  Future<int> delete(int id) async {
    var db = await _appDatabase.database;
    return await db.delete(Label.TABLE_NAME,  where: "${Label.DB_ID} = ?", whereArgs: [id]);
  }

}