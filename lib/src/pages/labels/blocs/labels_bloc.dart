import 'dart:async';
import 'dart:collection';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/database/labels_repository.dart';

class LabelsBloc implements BlocBase {

  BehaviorSubject<List<Label>> _listLabelsController = BehaviorSubject<List<Label>>();
  
  Stream<List<Label>> get labels => _listLabelsController.stream;
  
    ///
  /// Singleton factory
  ///
  static final LabelsBloc _bloc = new LabelsBloc._internal();
  factory LabelsBloc(){
    return _bloc;
  }
  LabelsBloc._internal(){
  }

  @override
  void initState() {
    loadLabels();
  }
  
  @override
  void dispose() {
    // _listLabelsController.close();
  }
  
  void loadLabels() async {
    LabelRepository repository = LabelRepository.get();
    var listLabels = await repository.findAll();
    var str = '';
    listLabels.forEach((label){
      str += (label.name + ' , ') ;
    });
    _listLabelsController.sink.add(UnmodifiableListView<Label>(listLabels));
  }
  
}

LabelsBloc labelsBloc = LabelsBloc();
