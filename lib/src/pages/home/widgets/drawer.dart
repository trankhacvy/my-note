import 'package:flutter/material.dart';
import 'package:todo_list/src/models/label.dart';
import 'package:todo_list/src/pages/home/blocs/home_bloc.dart';
import 'package:todo_list/src/pages/home/blocs/drawer_bloc.dart';
import 'package:todo_list/src/pages/labels/blocs/labels_bloc.dart';
import 'package:todo_list/src/commons/constants.dart';
import 'package:todo_list/src/pages/home/menu.dart';
import 'package:todo_list/src/utils/about_util.dart';

class SideDrawer extends StatefulWidget {
  final HomeBloc _homeBloc;
  final DrawerBloc _drawerBloc;
  final Function onLabelClick;

  SideDrawer(
      this._homeBloc, this._drawerBloc, this.onLabelClick);

  @override
  State<SideDrawer> createState() {
    return SideDrawerState();
  }
}

class SideDrawerState extends State<SideDrawer> {
  _buildLabelsSection(BuildContext context, MenuModel menuModel) {
    var widgets = <Widget>[];
    widgets.add(ListTile(
      selected: true,
      title: Text('Labels', style: Theme.of(context).textTheme.subtitle),
    ));

    widgets.add(StreamBuilder<List<Label>>(
        stream: labelsBloc.labels,
        builder: (BuildContext bc, AsyncSnapshot<List<Label>> snapshot) {
          return Column(
            children: snapshot.hasData
                ? snapshot.data
                    .map((label) => MenuItem(
                        isSelected: menuModel.isLabelModel &&
                            menuModel.label == label.name,
                        label: label.name,
                        icon: Icon(Icons.label),
                        onClick: () {
                          widget._homeBloc.setLabel(label);
                          widget._drawerBloc.setMenu(label.name, true);
                        }))
                    .toList()
                : [],
          );
        }));

    widgets.add(ListTile(
      title: Text('Add more', style: Theme.of(context).textTheme.title),
      leading: Icon(Icons.add),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/labels');
      },
    ));

    return widgets;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: StreamBuilder<MenuModel>(
          stream: widget._drawerBloc.currentMenu,
          builder: (BuildContext context, AsyncSnapshot<MenuModel> snapshot) {
            var selectedMenu = snapshot.hasData
                ? snapshot.data
                : MenuModel(MENU_ALL_NOTES, false);
            return ListView(
              shrinkWrap: true,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 48,
                      height: 48,
                      margin: EdgeInsets.all(16.0),
                      child: Image.asset('assets/ic_launcher.png'),
                    ),
                    Text('My Note', style: Theme.of(context).textTheme.title)
                  ],
                ),
                MenuItem(
                    isSelected: selectedMenu.label == MENU_ALL_NOTES,
                    label: 'All notes',
                    icon: Icon(Icons.event_note),
                    onClick: () {
                      widget._drawerBloc.setMenu(MENU_ALL_NOTES, false);
                      widget._homeBloc.setLabel(null);
                    }),
                MenuItem(
                  isSelected: selectedMenu.label == MENU_REMINDERS,
                  label: 'Reminders',
                  icon: Icon(Icons.alarm),
                  onClick: () {
                    final snackBar =
                        SnackBar(content: Text('Comming Soon'));
                        Scaffold.of(context).showSnackBar(snackBar);
                  },
                ),
                Divider(),
                Column(
                  children: _buildLabelsSection(context, selectedMenu),
                ),
                Divider(),
                MenuItem(
                  isSelected: selectedMenu.label == MENU_SETTINGS,
                  label: 'Settings',
                  icon: Icon(Icons.settings),
                  onClick: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                MenuItem(
                  isSelected: selectedMenu.label == MENU_ABOUT_US,
                  label: 'About us',
                  icon: Icon(Icons.ac_unit),
                  onClick: () {
                    showGalleryAboutDialog(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final bool isSelected;
  final String label;
  final Icon icon;
  final Function onClick;

  MenuItem({this.isSelected, this.label, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(28.0),
            bottomRight: Radius.circular(28.0)),
        color:
            isSelected ? Theme.of(context).highlightColor : Colors.transparent,
      ),
      child: ListTile(
        title: Text(label, style: Theme.of(context).textTheme.title),
        leading: icon,
        selected: true,
        onTap: () {
          Navigator.pop(context);
          onClick();
        },
      ),
    );
  }
}
