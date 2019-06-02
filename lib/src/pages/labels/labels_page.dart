import 'package:flutter/material.dart';
import 'package:todo_list/src/pages/labels/widgets/label_row_form.dart';
import 'package:todo_list/src/pages/labels/widgets/label_row_item.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/pages/labels/blocs/labels_bloc.dart';
import 'package:todo_list/src/pages/labels/blocs/labels_form_bloc.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';

class LabelsPage extends StatefulWidget {
  @override
  State<LabelsPage> createState() => LabelsPageState();
}

class LabelsPageState extends State<LabelsPage> {

  LabelFormBloc labelFormBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    labelFormBloc = LabelFormBloc();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit labels'),
      ),
      body: StreamBuilder<List<Label>>(
        stream: labelsBloc.labels,
        builder: (BuildContext bc, AsyncSnapshot<List<Label>> snapshot) {
          List<Label> labels = snapshot.hasData ? snapshot.data : [];

          var listWidgets = <Widget>[];
          listWidgets.add(BlocProvider<LabelFormBloc>(
            bloc: LabelFormBloc(),
            child: LabelRowForm(
                refresh: _refresh),
          ));

          labels.forEach((label) {
            listWidgets.add(BlocProvider<LabelFormBloc>(
                key: Key(label.id.toString()),
                bloc: LabelFormBloc(),
                child: LabelRowItem(
                  label: label,
                  refresh: _refresh,
                )));
          });

          return ListView(
            children: listWidgets,
          );
        },
      ),
    );
  }

  _refresh() {
    labelsBloc.loadLabels();
  }

}
