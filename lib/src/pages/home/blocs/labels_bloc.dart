import 'dart:async';
import 'dart:collection';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/database/labels_repository.dart';

class LabelsBloc implements BlocBase {
  
  List<Label> _listLabels = List();
  
  BehaviorSubject<List<Label>> _listLabelsController = BehaviorSubject<List<Label>>();
  
  Stream<List<Label>> get labels => _listLabelsController.stream;
  
  @override
  void initState() {
    print('LabelsBloc init');
    loadLabels();
  }
  
  @override
  void dispose() {
    print('LabelsBloc dispose');
    _listLabelsController.close();
  }
  
  void loadLabels() async {
    LabelRepository repository = LabelRepository.get();
    _listLabels = await repository.findAll();
    _listLabelsController.sink.add(UnmodifiableListView<Label>(_listLabels));
  }
  
}