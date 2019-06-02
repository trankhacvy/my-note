import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/commons/constants.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/pages/home/blocs/notes_bloc.dart';

class HomeBloc implements BlocBase {

  HomeBloc(){
    _listModeController.sink.add(SHOW_LIST);
  }

  BehaviorSubject<Label> _selectedLabelController = BehaviorSubject<Label>();

  Stream<Label> get selectedLabel => _selectedLabelController.stream;

  Label get selectedLabelValue => _selectedLabelController.value;

  void setLabel(Label label) {
    _selectedLabelController.sink.add(label);
  }

  BehaviorSubject<int> _listModeController = BehaviorSubject<int>();

  Stream<int> get listMode => _listModeController.stream;

  @override
  void initState() {
  }

  @override
  void dispose() {
    _listModeController.close();
    _selectedLabelController.close();
  }

  void toggleListMode() {
    _listModeController.sink.add(_listModeController.value == SHOW_LIST
        ? SHOW_GRID
        : SHOW_LIST);
  }

  void onLabelChanged(NotesBloc notesBloc){
    _selectedLabelController.listen((label){
      if(label != null) {
        notesBloc.loadNotesByLabel(label);
      } else {
        notesBloc.loadNotes();
      }
    });
    this.setLabel(null);
  }

  void loadNotes(){
    _selectedLabelController.add(_selectedLabelController.value);
  }
}
