import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_state.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_cubit.dart';
import 'package:haelo_flutter/widgets/date_format.dart';

class OfficeStageDropDown extends StatelessWidget {
  final callbackToHistory;
  final String alreadySelectedOnHistory;
  List<String> items;
  OfficeStageDropDown(
      this.callbackToHistory, this.alreadySelectedOnHistory, this.items)
      : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3),
              bottomLeft: Radius.circular(3),
            ),
          ),
          margin: EdgeInsets.fromLTRB(58, 140, 20, 5),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          width: MediaQuery.of(context).size.width * 0.30,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((e) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    callbackToHistory(e);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      e.toString(),
                      style: mpHeadLine14(),
                    ),
                  ),
                );
              }).toList()),
        ),
      ],
    );
  }
}
