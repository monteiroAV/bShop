import 'package:bhop/models/home_manager.dart';
import 'package:bhop/models/section.dart';
import 'package:flutter/material.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget(this.homeManager);
  final HomeManager homeManager;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'List'));
            },
            textColor: Colors.blue[300],
            child: const Text('Adicionar Lista'),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'Staggered'));
            },
            textColor: Colors.blue[300],
            child: const Text('Adicionar Grade'),
          ),
        ),
      ],
    );
  }
}
