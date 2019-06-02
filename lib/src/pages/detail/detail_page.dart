import 'package:flutter/material.dart';
import 'dart:io';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/pages/detail/blocs/task_form_bloc.dart';
import 'package:todo_list/src/pages/detail/widgets/color_picker.dart';
import 'package:todo_list/src/models/note.dart';
import 'package:todo_list/src/pages/labels/blocs/labels_bloc.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/utils/image_utils.dart';

class DetailPage extends StatefulWidget {
  final Note task;

  DetailPage({Key key, this.task}) : super(key: key);

  @override
  State createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  TaskFormBloc _taskFormBloc;

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    labelsBloc.loadLabels();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final note = ModalRoute.of(context).settings.arguments;
    if(_taskFormBloc == null) {
      _taskFormBloc = BlocProvider.of(context);
    }
    if (note != null) {
      _taskFormBloc.setCurrentNote(note);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: StreamBuilder<int>(
          stream: _taskFormBloc.color,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: snapshot.hasData ? Color(snapshot.data) : Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SafeArea(
                    child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _titleTextField(),
                            _contentTextField(),
                            StreamBuilder<List<Label>>(
                              stream: _taskFormBloc.labels,
                              builder: (BuildContext bc,
                                  AsyncSnapshot<List<Label>> snapshot) {
                                if (snapshot.hasData) {
                                  return Wrap(
                                    children: snapshot.data
                                        .map((Label label) => Container(
                                              margin:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Chip(
                                                label: Text(label.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption),
                                              ),
                                            ))
                                        .toList(),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            StreamBuilder<String>(
                                stream: _taskFormBloc.image,
                                builder: (BuildContext bc,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 8.0),
                                      width: double.infinity,
                                      color: Colors.redAccent,
                                      child: Image.file(
                                        File(snapshot.data),
                                        width: double.infinity,
                                      ),
                                    );
                                  }
                                  return Container();
                                })
                          ],
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.color_lens),
                              onPressed: () {
                                _openColorPalette();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.label),
                              onPressed: () {
                                _openLabelsPicker();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.insert_photo),
                              onPressed: () {
                                _openImagePicker();
                              },
                            )
                          ],
                        ))
                  ],
                )),
              ),
            );
          }),
    );
  }

  Widget _titleTextField() => StreamBuilder<String>(
        stream: _taskFormBloc.title,
        initialData: '',
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          _titleController.value =
              _titleController.value.copyWith(text: snapshot.data);

          return TextField(
            controller: _titleController,
            onChanged: _taskFormBloc.onTitleChange,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Title'),
            style: Theme.of(context).textTheme.title,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_focusNode);
            },
            autocorrect: false,
          );
        },
      );

  Widget _contentTextField() => StreamBuilder<String>(
        stream: _taskFormBloc.content,
        initialData: '',
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          _contentController.value =
              _contentController.value.copyWith(text: snapshot.data);

          return TextField(
            controller: _contentController,
            onChanged: _taskFormBloc.onContentChange,
            focusNode: _focusNode,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Note'),
            style: Theme.of(context).textTheme.body1,
            keyboardType: TextInputType.multiline,
            autocorrect: false,
            maxLines: null,
          );
        },
      );

  void _openColorPalette() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StreamBuilder<int>(
            stream: _taskFormBloc.color,
            initialData: Colors.white.value,
            builder: (BuildContext context, AsyncSnapshot snapshot) =>
                ColorPalette(
                    selectedColor:
                        snapshot.hasData ? snapshot.data : Colors.white.value,
                    onSelectColor: (color) {
                      _taskFormBloc.onColorChange(color);
                    }),
          );
        });
  }

  void _openLabelsPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) => StreamBuilder(
              stream: labelsBloc.labels,
              builder:
                  (BuildContext bc, AsyncSnapshot<List<Label>> labelsSnapshot) {
                return StreamBuilder<List<Label>>(
                  stream: _taskFormBloc.labels,
                  builder: (BuildContext bc,
                      AsyncSnapshot<List<Label>> selectedLabelsSnapshot) {
                    List<Label> selectedLabels = selectedLabelsSnapshot.hasData
                        ? selectedLabelsSnapshot.data
                        : <Label>[];

                    var listLabelWidgets = <Widget>[];
                    if (labelsSnapshot.hasData) {
                      listLabelWidgets = labelsSnapshot.data
                          .map((label) => ListTile(
                                leading: Checkbox(
                                    value:
                                        isSelectedLabel(label, selectedLabels),
                                    onChanged: (checked) {
                                      _taskFormBloc.onSelectLabel(
                                          label, checked);
                                    }),
                                title: Text(label.name),
                                onTap: () {
                                  _taskFormBloc.onSelectLabel(label,
                                      !isSelectedLabel(label, selectedLabels));
                                },
                              ))
                          .toList();
                    }

                    listLabelWidgets.add(ListTile(
                      leading: Container(
                        margin: EdgeInsets.only(left: 12.0),
                        child: Icon(Icons.add),
                      ),
                      title: Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: Text('Add'),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/labels');
                      },
                    ));

                    return SafeArea(
                      child: ListView(
                        shrinkWrap: true,
                        children: listLabelWidgets,
                      ),
                    );
                  },
                );
              },
            ));
  }

  void _openImagePicker() async {
    File image = await getImageFromGallery();
    if(image != null) {
      _taskFormBloc.onSelectImage(image.path);
    }
    
  }

  bool isSelectedLabel(Label label, List<Label> labelInNotes) {
    bool result = false;
    for (var i = 0; i < labelInNotes.length; i++) {
      result = labelInNotes[i].id == label.id;
      if (result) {
        break;
      }
    }
    return result;
  }

  Future<bool> _onWillPop() async {
    await _taskFormBloc.createOrUpdateTask();
    return true;
  }
}
