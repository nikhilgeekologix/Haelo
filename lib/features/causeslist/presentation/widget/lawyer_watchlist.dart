import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/causeslist/cubit/createwatchlist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/createwatchlist_state.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/add_to_watchlist.dart';

import '../../../../widgets/error_widget.dart';
import '../../../../widgets/progress_indicator.dart';
import '../../../alert/cubit/edit_watchlist/edit_watchlist_cubit.dart';
import '../../../alert/cubit/edit_watchlist/edit_watchlist_state.dart';

class LawyerWatchList extends StatefulWidget {
  final displayWatchList;
  final selectedLawyerList;
  final type;
  final isFromCauseListAdd;
  final btnCallback;
  const LawyerWatchList(
      this.displayWatchList, this.selectedLawyerList, this.type,
      {this.isFromCauseListAdd = false, Key? key, this.btnCallback})
      : super(key: key);

  @override
  _LawyerWatchListState createState() => _LawyerWatchListState();
}

class _LawyerWatchListState extends State<LawyerWatchList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(1),
          ),
          margin: EdgeInsets.all(20),
          child: SizedBox(
            // height: mediaQH(context) * 0.25,
            width: mediaQW(context) * 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                ImageConstant.close,
                                color: AppColor.black,
                                height: 12,
                                width: 12,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Select WatchList",
                              textAlign: TextAlign.center,
                              style: mpHeadLine14(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);

                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                if (widget.isFromCauseListAdd) {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AddToWatchList(
                                            widget.selectedLawyerList,
                                            caseId: widget.selectedLawyerList,
                                            widget.type,
                                            isFromCauseListAdd: true,
                                          ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AddToWatchList(
                                          widget.selectedLawyerList,
                                          widget.type));
                                }
                              });
                            },
                            child: const Icon(Icons.add)),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),

                  BlocConsumer<EditWatchlistCubit, EditWatchlistState>(
                      builder: (context, state) {
                    return const SizedBox();
                  }, listener: (context, state) {
                    if (state is EditWatchlistLoaded) {
                      var model = state.model;
                      if (model.result == 1) {
                        toast(msg: model.msg.toString());
                        if (!widget.isFromCauseListAdd) {
                          widget.btnCallback.call();
                        }
                        Navigator.pop(context);
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) =>
                                AppMsgPopup(model.msg.toString()));
                      }
                    }
                  }),
                  Container(
                    color: AppColor.grey_color,
                    child: ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: widget.displayWatchList!.length,
                        itemBuilder: (context, index) {
                          var model = widget.displayWatchList[index];
                          return InkWell(
                            onTap: () {
                              var body = {
                                "watchlistId": widget
                                    .displayWatchList![index].watchlistId
                                    .toString(),
                                "caseList":
                                    widget.selectedLawyerList.toString(),
                                "requestType": "edit_watchlist"
                              };
                              BlocProvider.of<EditWatchlistCubit>(context)
                                  .editWatchlist(body);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Text(
                                widget.displayWatchList![index].watchlistName
                                    .toString(),
                                style:
                                    mpHeadLine14(fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
