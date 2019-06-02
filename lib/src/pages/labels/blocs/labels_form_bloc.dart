import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/database/labels_repository.dart';

class LabelFormBloc implements BlocBase {
  final BehaviorSubject<String> _nameController = BehaviorSubject<String>();

  Stream<String> get name => _nameController.stream;

  Function(String) get onNameChange => _nameController.sink.add;

  final BehaviorSubject<int> _idController = BehaviorSubject<int>();

  Function(int) get setId => _idController.sink.add;

  @override
  void initState() {}

  @override
  void dispose() {
    _nameController.close();
    _idController.close();
  }

  setLabel(Label label) {
    onNameChange(label.name);
    setId(label.id);
  }

  resetForm() {
    _nameController.sink.add(null);
    _idController.sink.add(null);
  }

  createLabel() async {
    String name = _nameController.value;
    int id = _idController.value;
    if (name != null && name.trim().isNotEmpty) {
      LabelRepository repository = LabelRepository.get();
      Label label = Label.create(name);
      label.id = id;

      await repository.save(label);
    }
    resetForm();
  }

  deleteLabel(id) async {
    if (id != null) {
      LabelRepository repository = LabelRepository.get();
      await repository.delete(id);
    }
  }
}
