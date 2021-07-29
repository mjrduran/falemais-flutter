import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final String text;

  Progress({this.text = 'Loading'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          Text(
            this.text,
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
