import 'package:flutter/material.dart';

class ModelCard extends StatelessWidget {
  String nama;
  ModelCard({this.nama});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [Text(nama)],
      ),
    );
  }
}
