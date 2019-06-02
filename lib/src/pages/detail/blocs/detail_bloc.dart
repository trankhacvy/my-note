import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/pages/home/blocs/labels_bloc.dart';
import 'package:todo_list/src/pages/detail/blocs/task_form_bloc.dart';

class DetailBloc extends BlocBase {

  TaskFormBloc _taskFormBloc;
  LabelsBloc _labelsBloc;

  DetailBloc(){
    _taskFormBloc = TaskFormBloc();
    _labelsBloc = LabelsBloc();
  }


  TaskFormBloc get taskFormBloc => _taskFormBloc;

  @override
  void dispose() {
    _labelsBloc.dispose();
    _taskFormBloc.dispose();
  }

  @override
  void initState() {
    _labelsBloc.initState();
  }

  LabelsBloc get labelsBloc => _labelsBloc;


}