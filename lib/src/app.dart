import 'package:flutter/material.dart';
import 'pages/home/home_page.dart';
import 'package:todo_list/src/bloc/bloc_provider.dart';
import 'package:todo_list/src/pages/home/blocs/home_bloc.dart';
import 'package:todo_list/src/pages/labels/labels_page.dart';
import 'package:todo_list/src/pages/labels/blocs/labels_bloc.dart';
import 'package:todo_list/src/pages/detail/detail_page.dart';
import 'package:todo_list/src/pages/detail/blocs/task_form_bloc.dart';
import 'package:todo_list/src/pages/dummy_screen.dart';
import 'package:todo_list/src/pages/settings/settings_page.dart';
import 'package:todo_list/src/bloc/theme_bloc.dart';
import 'package:todo_list/src/models/app_config.dart';
import 'package:todo_list/src/utils/theme_util.dart';
import 'package:todo_list/src/commons/scales.dart';

class App extends StatefulWidget {
  final DisplayConfig displayConfig;

  App({this.displayConfig});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeBloc.setDisplayConfig = widget.displayConfig;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DisplayConfig>(
      stream: themeBloc.displayConfig,
      initialData: widget.displayConfig,
      builder: (BuildContext context, AsyncSnapshot<DisplayConfig> snapshot) {
        return MaterialApp(
          title: 'My Note',
          theme: buildTheme(snapshot.data),
          routes: <String, WidgetBuilder>{
            '/': (context) => BlocProvider<HomeBloc>(
                  bloc: HomeBloc(),
                  child: HomePage(),
                ),
            '/labels': (context) => BlocProvider<LabelsBloc>(
                  bloc: labelsBloc,
                  child: LabelsPage(),
                ),
            '/detail': (context) => BlocProvider<TaskFormBloc>(
                  bloc: TaskFormBloc(),
                  child: DetailPage(),
                ),
            '/settings': (context) => SettingsScreen(),
            '/about': (context) => DummyScreen(title: 'About us'),
          },
          builder: (BuildContext context, Widget child) {
            return Builder(
              builder: (BuildContext context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor:
                        getTextValueScaleByLabel(snapshot.data.fontSize).scale,
                  ),
                  child: child,
                );
              },
            );
          },
        );
      },
    );
  }
}
