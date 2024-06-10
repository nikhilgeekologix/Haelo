import 'package:flutter/material.dart';

class DividerCustom extends StatelessWidget {
  DividerCustom({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Divider(
        thickness: 2,
        color: Colors.grey[100],
      ),
    );
  }
}
