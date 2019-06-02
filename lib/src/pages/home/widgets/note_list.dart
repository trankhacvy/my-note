import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo_list/src/pages/home/blocs/notes_bloc.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/models/note.dart';
import 'package:todo_list/src/pages/home/widgets/note_row.dart';
import 'package:todo_list/src/commons/constants.dart';

class NoteList extends StatelessWidget {
  final int listMode;
  final Function(Note) onItemClick;

  NoteList({this.listMode, this.onItemClick});

  @override
  Widget build(BuildContext context) {
    NotesBloc notesBloc = BlocProvider.of(context);

    return StreamBuilder<List<Note>>(
      stream: notesBloc.tasks,
      builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                'Empty note',
                style: Theme.of(context).textTheme.body1,
              ),
            );
          }
          if (listMode == SHOW_LIST) {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    color: Colors.transparent,
                    height: 8.0,
                  ),
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(8.0),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) => NoteRow(
                    note: snapshot.data[index],
                    dismissDirection: DismissDirection.horizontal,
                    onItemClick: (Note task) {
                      onItemClick(task);
                    },
                    onArchive: (Note a) {
                      print('onArchive');
                    },
                    onDelete: (Note task) {
                      notesBloc.deleteTask(task.id);
                    },
                  ),
            );
          } else {
            return StaggeredGridView.countBuilder(
              primary: false,
              itemCount: snapshot.data.length,
              padding: EdgeInsets.all(8.0),
              crossAxisCount: 4,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              itemBuilder: (context, index) => NoteRow(
                    note: snapshot.data[index],
                    dismissDirection: DismissDirection.horizontal,
                    onItemClick: (Note task) {
                      onItemClick(task);
                    },
                    onArchive: (Note a) {
                      print('onArchive');
                    },
                    onDelete: (Note task) {
                      notesBloc.deleteTask(task.id);
                    },
                  ),
              staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
