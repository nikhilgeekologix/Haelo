import 'package:flutter/material.dart';
import '../core/utils/ui_helper.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation(AppColor.primary),
      ),
    );
  }
}
