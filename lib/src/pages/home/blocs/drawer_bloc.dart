import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/commons/constants.dart';
import 'package:rxdart/subjects.dart';
import 'package:todo_list/src/pages/home/menu.dart';

class DrawerBloc extends BlocBase {
  
  BehaviorSubject<MenuModel> _menuController = BehaviorSubject<MenuModel>();

  Stream<MenuModel> get currentMenu => _menuController.stream;

  @override
  void initState() {
    _menuController.sink.add(MenuModel(MENU_ALL_NOTES, false));
    _menuController.listen((data){
      print('[_menuController] listen ${data.label}');
    });
  }

  @override
  void dispose() {
    print('DrawerBloc dispose');
    _menuController.close();
  }

  void setMenu(String label, bool isLabeledMenu){
    _menuController.sink.add(MenuModel(label, isLabeledMenu));
  }

}