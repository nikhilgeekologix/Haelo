
import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class ColorNode extends StatelessWidget {
  final color;
  final name;

  ColorNode(this.color, this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(4),
              color: color,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            name,
            style: mpHeadLine10(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }



}