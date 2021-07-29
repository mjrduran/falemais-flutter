import 'package:falemais/components/theme.dart';
import 'package:falemais/screens/dashboard.dart';
import 'package:falemais/screens/input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(MyApp());
}

class LogObserver extends BlocObserver {

  @override
  void onChange(BlocBase bloc, Change change) {
    print('${bloc.runtimeType} > ${change.nextState}');
    super.onChange(bloc, change);
  }

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Bloc.observer = LogObserver();
    return MaterialApp(
      title: 'Fale Mais',
      theme: faleMaisTheme,
      home: DashboardContainer(),
    );
  }
}


