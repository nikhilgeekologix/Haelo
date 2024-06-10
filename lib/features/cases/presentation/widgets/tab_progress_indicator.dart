import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class TabProgressIndicator extends StatelessWidget {
  const TabProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mediaQH(context) * 0.8,
      child: const Center(child: CircularProgressIndicator(
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation(AppColor.primary),
      )),
    );
  }
}
