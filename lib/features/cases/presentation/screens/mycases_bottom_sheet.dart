import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_state.dart';
import 'package:haelo_flutter/features/cases/data/model/office_stage_model.dart';
import 'package:haelo_flutter/widgets/commonButtons.dart';

class CasesBottomSheet extends StatefulWidget {
  final filterCallback;
  final selected;
  List<String> oficeStage;
  CasesBottomSheet(this.filterCallback, this.selected, this.oficeStage,
      {Key? key})
      : super(key: key);

  @override
  State<CasesBottomSheet> createState() => _CasesBottomSheetState();
}

class _CasesBottomSheetState extends State<CasesBottomSheet> {
  List<String> decisionStatus = [];
  String grpValue = "";
  String selectedValue = "";

  @override
  void initState() {
    print("${widget.selected}");
    decisionStatus = widget.oficeStage;
    if (widget.selected != null) {
      if (widget.selected.toString().isNotEmpty) {
        grpValue = decisionStatus.indexOf(widget.selected).toString();
      }
      selectedValue = widget.selected;
    }

    print(decisionStatus);
    print(decisionStatus.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: mediaQW(context) * 0.18,
                  child: const Divider(
                    thickness: 5,
                    color: AppColor.hint_color_grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColor.hint_color_grey,
                    )),
                Text(
                  "Filter",
                  style: mpHeadLine20(
                      textColor: AppColor.bold_text_color_dark_blue,
                      fontWeight: FontWeight.w500),
                ),
                InkWell(
                  onTap: () {
                    widget.filterCallback("");
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Reset",
                    style: mpHeadLine14(
                        textColor: grpValue.isNotEmpty
                            ? AppColor.primary
                            : AppColor.hint_color_grey),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Decision",
              style: mpHeadLine18(
                  textColor: AppColor.bold_text_color_dark_blue,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              itemCount: decisionStatus.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Theme(
                      data: ThemeData(
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                        unselectedWidgetColor: AppColor.primary,
                      ),
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColor.primary,
                        title: Row(
                          children: [
                            SizedBox(
                              width: mediaQW(context) * 0.24,
                            ),
                            Text(
                              decisionStatus[index],
                              style: mpHeadLine18(),
                            ),
                          ],
                        ),
                        value: (index).toString(),
                        groupValue: grpValue,
                        onChanged: (value) {
                          setState(() {
                            print("value ${decisionStatus[index]}");
                            selectedValue =
                                decisionStatus[index]; //value.toString();
                            grpValue = value.toString();
                            print("grp value ${grpValue}");
                          });
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CommonButtons(
                buttonText: "Apply Filter",
                buttonCall: () {
                  widget.filterCallback(selectedValue);
                  // var myCasesList = {
                  //   "filterByDecision": selectedValue,
                  // };
                  // BlocProvider.of<MyCasesCubit>(context).fetchMyCases(myCasesList);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ));
  }
}
