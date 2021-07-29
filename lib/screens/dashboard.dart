

import 'package:falemais/components/bloc_container.dart';
import 'package:falemais/screens/input_form.dart';
import 'package:flutter/material.dart';

class DashboardContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return DashboardView();
  }
}

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Fale Mais")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Image.asset("images/falemais.png")),
          ),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FeatureItem('Cálculo de tarifa', Icons.monetization_on,
                        () => _navigateToCallPrice(context)),

              ],
            ),
          ),
        ],
      ),
    );
  }

  _navigateToCallPrice(BuildContext context) {
    push(context, InputFormContainer());
  }
}


class FeatureItem extends StatelessWidget {
  final String _name;
  final IconData _icon;
  final Function onClick;

  FeatureItem(this._name, this._icon, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () {
            onClick();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _icon,
                  color: Colors.white,
                  size: 24,
                ),
                Text(
                  _name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}