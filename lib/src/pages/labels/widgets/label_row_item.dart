import 'package:flutter/material.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/pages/labels/blocs/labels_form_bloc.dart';

class LabelRowItem extends StatefulWidget {
  final Label label;
  final Function refresh;

  LabelRowItem({this.label, this.refresh});

  @override
  _LabelRowItemState createState() => _LabelRowItemState();
}

class _LabelRowItemState extends State<LabelRowItem> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  LabelFormBloc _labelFormBloc;

  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    _controller.value = _controller.value.copyWith(text: widget.label.name);

    _focusNode.addListener(() {
      setState(() {
        isFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _labelFormBloc = BlocProvider.of(context);
    _labelFormBloc.setLabel(widget.label);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isFocus
            ? Border(
                top: BorderSide(width: 1.0), bottom: BorderSide(width: 1.0))
            : null,
      ),
      child: ListTile(
        leading: isFocus
            ? _buttonIcon(Icons.delete, _showDeleteConfirm)
            : Icon(Icons.label),
        title: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          controller: _controller,
          onChanged: _labelFormBloc.onNameChange,
          focusNode: _focusNode,
        ),
        trailing: isFocus
            ? _buttonIcon(Icons.done, _updateLabel)
            : _buttonIcon(Icons.edit, _editLabel),
      ),
    );
  }

  _editLabel() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  _updateLabel() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await _labelFormBloc.createLabel();
    widget.refresh();
  }

  _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete label"),
          content: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.subhead,
                children: <TextSpan>[
                  TextSpan(text: 'Are you sure you want to remove '),
                  TextSpan(
                      text: widget.label.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' label ?'),
                ]),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel", style: Theme.of(context).textTheme.button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Delete",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .merge(TextStyle(color: Colors.white))),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteLabel();
              },
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
          ],
        );
      },
    );
  }

  _deleteLabel() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await _labelFormBloc.deleteLabel(widget.label.id);
    widget.refresh();
  }

  _buttonIcon(IconData icon, Function onPress) =>
      IconButton(icon: Icon(icon), onPressed: onPress);
}
