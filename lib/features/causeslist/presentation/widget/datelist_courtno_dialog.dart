import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/causeslist/data/model/date_court_model.dart';
import 'package:haelo_flutter/widgets/date_format.dart';

class CauseDateListCourtNo extends StatelessWidget {
  List<DatesCourtModel> dateList;
  final dateSelectCallback;
  final dateCourtSelectCallback;
  bool isPendingOrder = false;

  CauseDateListCourtNo(this.dateList, this.dateSelectCallback,
      this.dateCourtSelectCallback, this.isPendingOrder,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.fromLTRB(20, 20, 20, 50),
          width: mediaQW(context) * 0.40,
          constraints: BoxConstraints(maxHeight: mediaQH(context) * 0.8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Text(
                    "Select Date",
                    style: mpHeadLine14(),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: AppColor.grey_color,
                ),
                ListView.builder(
                  itemCount: dateList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: i == dateList.length - 1
                                          ? AppColor.colorTransparent
                                          : AppColor.grey_color))),
                          child: ListTileTheme(
                            contentPadding: EdgeInsets.all(0),
                            dense: true,
                            horizontalTitleGap: 0.0,
                            minLeadingWidth: 0,
                            minVerticalPadding: 0,
                            child: ExpansionTile(
                              title: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  dateSelectCallback(dateList[i].date);
                                },
                                child: Text(
                                  isPendingOrder
                                      ? getddMMYYYY_with_splash(
                                          dateList[i].date!)
                                      : dateList[i].date!,
                                  style:
                                      mpHeadLine14(fontWeight: FontWeight.w500),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              collapsedShape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              clipBehavior: Clip.hardEdge,
                              tilePadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              expandedAlignment: Alignment.centerLeft,
                              childrenPadding: EdgeInsets.zero,
                              children: dateList[i].courtNo!.map((element) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    dateCourtSelectCallback(
                                        dateList[i].date, element.toString());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Text(
                                      "Court No: " + element.toString(),
                                      style: mpHeadLine12(),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
