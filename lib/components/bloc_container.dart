import 'package:flutter/material.dart';

abstract class BlocContainer extends StatelessWidget {}

Future<dynamic> push(BuildContext blocContext, BlocContainer container) {
  return Navigator.of(blocContext).push(
    MaterialPageRoute(builder: (context) => container),
  );
}