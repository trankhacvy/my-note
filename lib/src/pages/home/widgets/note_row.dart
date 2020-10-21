import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:todo_list/src/models/note.dart';
import 'package:todo_list/src/utils/date_util.dart';

class NoteRow extends StatelessWidget {
  NoteRow(
      {Key key,
      this.note,
      this.onItemClick,
      this.onDelete,
      this.onArchive,
      this.dismissDirection})
      : super(key: key);

  final Note note;
  final Function onItemClick;
  final void Function(Note) onDelete;
  final void Function(Note) onArchive;
  final DismissDirection dismissDirection;

  void _handleArchive() {
    onArchive(note);
  }

  void _handleDelete() {
    onDelete(note);
  }

  @override
  Widget build(BuildContext context) {
    bool notNull(Object o) => o != null;

    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        onItemClick(note);
      },
      child: Semantics(
        customSemanticsActions: <CustomSemanticsAction, VoidCallback>{
          CustomSemanticsAction(String: 'Archive'): _handleArchive,
          CustomSemanticsAction(String: 'Delete'): _handleDelete,
        },
        child: Dismissible(
          key: Key(note.id.toString()),
          direction: DismissDirection
              .startToEnd, // use dismissDirection to swipe both side,
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart)
              _handleArchive();
            else
              _handleDelete();
          },
          confirmDismiss: (DismissDirection direction) async {
            switch (direction) {
              case DismissDirection.endToStart:
                print('confirmDismiss $direction');
                if (await _showConfirmationDialog(context, 'archive'))
                  _handleArchive();
                break;
              case DismissDirection.startToEnd:
                print('confirmDismiss $direction');
                if (await _showConfirmationDialog(context, 'delete'))
                  _handleDelete();
                break;
              case DismissDirection.horizontal:
              case DismissDirection.vertical:
              case DismissDirection.up:
              case DismissDirection.down:
                assert(false);
            }
          },
          background: Card(
            child: Container(
              color: Colors.redAccent,
              child: Center(
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.white, size: 36.0),
                ),
              ),
            ),
          ),
          secondaryBackground: Card(
            child: Container(
              color: theme.primaryColor,
              child: Center(
                child: ListTile(
                  trailing:
                      Icon(Icons.archive, color: Colors.white, size: 36.0),
                ),
              ),
            ),
          ),
          child: Card(
            color: note.color != null ? Color(note.color) : Colors.white,
            child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.transparent,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.file(File(note.image)),
                    Text(note.title, style: Theme.of(context).textTheme.title),
                    Container(
                      margin: EdgeInsets.only(top: 4.0),
                      child: Text(getFormattedDate(note.createdAt)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: Text(note.content,
                          style: Theme.of(context).textTheme.body1),
                    ),
                    note.labels != null && note.labels.length > 0
                        ? (Container(
                            margin: EdgeInsets.only(top: 16.0),
                            color: Colors.transparent,
                            child: Wrap(
                              children: note.labels
                                  .map((label) => Container(
                                        margin: EdgeInsets.only(right: 8.0),
                                        child: Chip(
                                          backgroundColor: Colors.transparent,
                                          label: Text(label.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ))
                        : null,
                  ].where(notNull).toList(),
                )),
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String action) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to $action this item?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true); 
              },
            ),
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
