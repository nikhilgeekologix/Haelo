import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_state.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_cubit.dart';
import 'package:haelo_flutter/widgets/date_format.dart';

class DownloadFileOption extends StatelessWidget {
  // final dateList;
  // final dateSelectCallback;
  // const DownloadFileOption(this.dateList,this.dateSelectCallback,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
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
          margin: EdgeInsets.fromLTRB(20, 40, 0, 5),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  var myCasesList = {"downloadFile": "mycase"};
                  Navigator.pop(context);
                  BlocProvider.of<MyCasesCubit>(context)
                      .fetchMyCases(myCasesList);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "My Cases",
                        style: mpHeadLine14(),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: AppColor.primary),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: Text(
                          "new",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: "Roboto",
                            fontSize: 10,
                          ),
                        ),
                      ),
                      /*  RichText(
                        text: TextSpan(
                          style: mpHeadLine14(),
                          children: [
                            TextSpan(
                              text: "(new) ",
                              style: TextStyle(
                                color: AppColor.primary,
                              ),
                            ),
                            TextSpan(
                              text: "My Cases",
                            ),
                          ],
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              SizedBox(
                width: mediaQW(context) * 0.45,
                child: const Divider(
                  thickness: 1,
                  color: AppColor.white,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              InkWell(
                onTap: () {
                  var myCasesList = {"downloadFile": "expense"};
                  Navigator.pop(context);
                  BlocProvider.of<MyCasesCubit>(context)
                      .fetchMyCases(myCasesList);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Expenses",
                    style: mpHeadLine14(),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              SizedBox(
                width: mediaQW(context) * 0.45,
                child: const Divider(
                  thickness: 1,
                  color: AppColor.white,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              InkWell(
                onTap: () {
                  var myCasesList = {"downloadFile": "document"};
                  Navigator.pop(context);
                  BlocProvider.of<MyCasesCubit>(context)
                      .fetchMyCases(myCasesList);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Documents",
                    style: mpHeadLine14(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
