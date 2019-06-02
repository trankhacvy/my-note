import 'package:flutter/material.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/pages/labels/blocs/labels_form_bloc.dart';
import 'package:todo_list/src/models/label.dart';

class LabelRowForm extends StatefulWidget {
  final Function refresh;

  LabelRowForm({this.refresh});

  @override
  _LabelRowFormState createState() => _LabelRowFormState();
}

class _LabelRowFormState extends State<LabelRowForm> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusFakeNode = FocusNode();

  LabelFormBloc _labelFormBloc;

  bool hasFocus = true;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      print('==============>has focus: ${_focusNode.hasFocus}');
      setState(() {
        hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _labelFormBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusFakeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: hasFocus ? Border(bottom: BorderSide(width: 1.0)) : null,
      ),
      child: ListTile(
        leading: hasFocus
            ? _buttonIcon(Icons.close, _cancelCreate)
            : _buttonIcon(Icons.add, _focusInput),
        title: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Create new label"),
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _labelFormBloc.onNameChange,
              autofocus: true,
            ),
            Container(
              width: 0,
              height: 0,
              child: TextField(
                focusNode: _focusFakeNode,
              ),
            )
          ],
        ),
        trailing: hasFocus ? _buttonIcon(Icons.done, _createLabel) : null,
      ),
    );
  }

  _focusInput() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  _cancelCreate() {
    FocusScope.of(context).requestFocus(_focusFakeNode);
    _controller.clear();
  }

  _createLabel() async {
    FocusScope.of(context).requestFocus(_focusFakeNode);
    await _labelFormBloc.createLabel();
    _controller.clear();
    widget.refresh();
  }

  _buttonIcon(IconData icon, Function onPress) =>
      IconButton(icon: Icon(icon), onPressed: onPress);
}
