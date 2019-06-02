import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/models/note.dart';
import 'package:todo_list/src/database/note_repository.dart';

class NotesBloc extends BlocBase {

  List<Note> _taskList = List();

  BehaviorSubject<List<Note>> _taskListController = BehaviorSubject<List<Note>>();

  Stream<List<Note>> get tasks => _taskListController.stream;

  Sink<List<Note>> get _taskListSink => _taskListController.sink;

  @override
  void initState() {
    print('=>>> NotesBloc init state');
  }

  @override
  void dispose() {
    print('task list dispose');
    _taskListController.close();
  }

  void loadNotes() async {
    NoteRepository taskRepository = NoteRepository.get();
    _taskList = await taskRepository.getAll();
    _taskListSink.add(_taskList);
  }

  void loadNotesByLabel(Label label) async {
    NoteRepository taskRepository = NoteRepository.get();
    _taskList = await taskRepository.findNotesByLabel(label);
    _taskListSink.add(_taskList);
  }

  void deleteTask(int taskId) async {
    _taskList.removeWhere((task) => task.id == taskId);
    _taskListSink.add(_taskList);
    NoteRepository taskRepository = NoteRepository.get();
    await taskRepository.delete(taskId);
  }
}