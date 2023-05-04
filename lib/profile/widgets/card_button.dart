import 'package:flutter/material.dart';

class GridList extends StatelessWidget {
  const GridList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Button(context),
    );
  }
}

@override
Widget Button(
  BuildContext context,
) {
  return Container(
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 2.0,
        );
      },
    ),
  );
}
