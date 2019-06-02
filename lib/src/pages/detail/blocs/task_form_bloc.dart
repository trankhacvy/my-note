import 'dart:io';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/models/note.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/database/note_repository.dart';

class TaskFormBloc implements BlocBase {

  List<int> _labelIds = [];
  List<int> _addedLabelIds = [];
  List<int> _deletedLabelIds = [];

  TaskFormBloc() {
    print('===> TaskFormBloc constr');
    _originalLabelsController.sink.add([]);
  }

  final BehaviorSubject<int> _idController = BehaviorSubject<int>();
  final BehaviorSubject<String> _titleController = BehaviorSubject<String>();
  final BehaviorSubject<String> _contentController = BehaviorSubject<String>();
  final BehaviorSubject<int> _colorController = BehaviorSubject<int>();
  final BehaviorSubject<String> _imagesController = BehaviorSubject<String>();

  final BehaviorSubject<List<Label>> _originalLabelsController =
      BehaviorSubject<List<Label>>();

  Function(int) get setTaskId => _idController.sink.add;
  Function(String) get onTitleChange => _titleController.sink.add;
  Function(String) get onContentChange => _contentController.sink.add;
  Function(int) get onColorChange => _colorController.sink.add;
  Function(String) get onSelectImage => _imagesController.sink.add;
  Function(List<Label>) get onLabelsChange =>
      _originalLabelsController.sink.add;

  Stream<String> get title => _titleController.stream;
  Stream<String> get content => _contentController.stream;
  Stream<int> get color => _colorController.stream;
  Stream<String> get image => _imagesController.stream;
  Stream<List<Label>> get labels => _originalLabelsController.stream;

  @override
  void initState() {
  }

  @override
  void dispose() {
    _titleController.close();
    _contentController.close();
    _colorController.close();
    _idController.close();
    _originalLabelsController.close();
    _imagesController.close();
  }

  void onSelectLabel(Label label, bool isSelected) {
    List<Label> labels = _originalLabelsController.value;
    if(isSelected) {
      labels.add(label);
      if(!_labelIds.contains(label.id)) {
        _addedLabelIds.add(label.id);
      }
      if(_deletedLabelIds.contains(label.id)) {
        _deletedLabelIds.remove(label.id);
      }
    } else {
      labels = labels.where((item) => item.name != label.name).toList();

      if(_addedLabelIds.contains(label.id)) {
        _addedLabelIds.remove(label.id);
      }
      if(_labelIds.contains(label.id)) {
        _deletedLabelIds.add(label.id);
      }
    }

    _originalLabelsController.sink.add(labels);
  }

  setCurrentNote(Note note) {
    setTaskId(note.id);
    onTitleChange(note.title);
    onContentChange(note.content);
    onColorChange(note.color);
    onSelectImage(note.image);
    List<Label> labels = note.labels;
    _originalLabelsController.sink.add(labels);
    _labelIds = labels.map((label) => label.id).toList();
  }

  createOrUpdateTask() async {
    NoteRepository repository = NoteRepository.get();

    int id = _idController.value;
    String title = _titleController.value;
    String content = _contentController.value;
    int color = _colorController.value;
    String url = _imagesController.value;

    if (title != null || content != null) {
      Note task = new Note(
        title,
        content,
        color,
        url,
        false,
        DateTime.now().millisecondsSinceEpoch,
      );
      task.id = id;

      await repository.save(task, _addedLabelIds, _deletedLabelIds);
    }

    return true;
  }

  bool isBelongOriginalLabel(Label label) {
    List<Label> originalLabels = _originalLabelsController.value;
    List<Label> results =
        originalLabels.where((obj) => obj.id == label.id).toList();
    return results.length > 0;
  }
}
