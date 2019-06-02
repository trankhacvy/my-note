import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/commons/constants.dart';
import 'package:todo_list/src/models/label.dart';

class HomeUIBloc implements BlocBase {

  HomeUIBloc(){
    print('home block const');

    _listModeController.sink.add(SHOW_LIST);
  }

  BehaviorSubject<String> _homeTitleController = BehaviorSubject<String>();

  void setTitle(String title) {
    _homeTitleController.sink.add(title);
  }

  Stream<String> get title => _homeTitleController.stream;

  BehaviorSubject<int> _listModeController = BehaviorSubject<int>();

  Stream<int> get listMode => _listModeController.stream;

  @override
  void initState() {
  }

  @override
  void dispose() {
    _listModeController.close();
    _homeTitleController.close();
  }

  void setListMode() {
    _listModeController.sink.add(_listModeController.value == SHOW_LIST
        ? SHOW_GRID
        : SHOW_LIST);
  }
}
