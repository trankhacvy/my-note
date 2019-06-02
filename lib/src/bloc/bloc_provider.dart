import 'package:flutter/material.dart';

Type _typeOf<T>() => T;

abstract class BlocBase {
  void initState();

  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {

  BlocProvider({
    Key key,
    @required this.child,
    this.bloc,
  }) : super(key: key);

  final Widget child;
  final T bloc;

  @override
  BlocProviderState<T> createState() => BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context){
    final type = _typeOf<BlocProviderInherited<T>>();
    BlocProviderInherited<T> provider =
        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }

}

class BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    widget.bloc?.initState();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProviderInherited<T>(
    bloc: widget.bloc,
    child: widget.child,
  );
}

class BlocProviderInherited<T> extends InheritedWidget {
  BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(BlocProviderInherited oldWidget) => false;
}