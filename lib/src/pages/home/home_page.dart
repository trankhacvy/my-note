import 'package:flutter/material.dart';
import 'package:todo_list/src/pages/home/widgets/drawer.dart';
import 'package:todo_list/src/pages/home/blocs/notes_bloc.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/pages/home/widgets/note_list.dart';
import 'package:todo_list/src/commons/constants.dart';
import 'package:todo_list/src/models/note.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/pages/home/blocs/home_bloc.dart';
import 'package:todo_list/src/pages/home/blocs/drawer_bloc.dart';

import 'package:todo_list/src/pages/labels/blocs/labels_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomeBloc _homeBloc;
  DrawerBloc _drawerBloc;
  NotesBloc _notesBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _homeBloc = BlocProvider.of(context);
    _notesBloc = NotesBloc();
    _drawerBloc = DrawerBloc();

    _homeBloc.onLabelChanged(_notesBloc);
    labelsBloc.loadLabels();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showNotesByLabel(Label label) {
    _notesBloc.loadNotesByLabel(label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Label>(
            stream: _homeBloc.selectedLabel,
            builder: (BuildContext context, AsyncSnapshot<Label> snapshot) {
              return Text(snapshot.hasData ? snapshot.data.name : 'All notes');
            }),
        actions: <Widget>[
          StreamBuilder<int>(
            stream: _homeBloc.listMode,
            initialData: SHOW_LIST,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return IconButton(
                icon: Icon(
                    snapshot.data == SHOW_LIST ? Icons.list : Icons.grid_on),
                onPressed: () {
                  _homeBloc.toggleListMode();
                },
              );
            },
          ),
        ],
      ),
      drawer: SideDrawer(_homeBloc, _drawerBloc, _showNotesByLabel),
      body: StreamBuilder(
          stream: _homeBloc.listMode,
          initialData: SHOW_LIST,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) =>
              BlocProvider(
                bloc: _notesBloc,
                child: NoteList(
                    listMode: snapshot.data,
                    onItemClick: (Note task) {
                      Navigator.pushNamed(context, '/detail', arguments: task).then((_) {
                        _homeBloc.loadNotes();
                      });
                    }),
              )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/detail').then((_) {
              _homeBloc.loadNotes();
            });
          }),
    );
  }
}
