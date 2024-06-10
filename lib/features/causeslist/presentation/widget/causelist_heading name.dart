import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class CauseListHeadingName extends StatelessWidget {
  final headingText;
  const CauseListHeadingName({Key? key, required this.headingText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      headingText,
      style: mpHeadLine14(fontWeight: FontWeight.w500),
    );
  }
}
