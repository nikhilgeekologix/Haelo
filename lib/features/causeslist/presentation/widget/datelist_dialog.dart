import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';


class CauseDateList extends StatelessWidget {
  final dateList;
  final dateSelectCallback;
  const CauseDateList(this.dateList,this.dateSelectCallback,{Key? key}) : super(key: key);

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
          margin: EdgeInsets.fromLTRB(20,20,20,50),
          width: mediaQW(context) * 0.5,
          constraints:
          BoxConstraints(maxHeight: mediaQH(context) * 0.8),
          child: ListView.builder(
            itemCount: dateList.length + 1,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  if(i!=0) {
                    Navigator.pop(context);
                    dateSelectCallback(dateList[i - 1]);
                  }else{
                    Navigator.pop(context);
                  }

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        i == 0
                            ? "Select Date"
                            : dateList[i - 1],
                        style: mpHeadLine14(),
                      ),
                      const Divider(
                        thickness: 1,
                        color: AppColor.grey_color,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
