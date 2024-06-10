import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/causeslist/cubit/createwatchlist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/createwatchlist_state.dart';
import 'package:haelo_flutter/features/causeslist/cubit/showwatchlist_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import '../../../alert/cubit/edit_watchlist/edit_watchlist_cubit.dart';
import '../../../alert/cubit/edit_watchlist/edit_watchlist_state.dart';

class AddToWatchList extends StatefulWidget {
  final selectedLawyerList;
  final type;
  final isUpdate;
  final caseId;
  final updateData;
  final VoidCallback? onOkayPressed;
  final isFromCauseListAdd;
  const AddToWatchList(this.selectedLawyerList, this.type,
      {this.isUpdate = false,
      this.isFromCauseListAdd = false,
      this.updateData = const {},
      this.onOkayPressed,
      Key? key,
      this.caseId})
      : super(key: key);

  @override
  _AddToWatchListState createState() => _AddToWatchListState();
}

class _AddToWatchListState extends State<AddToWatchList> {
  TextEditingController _watchlistController = TextEditingController();

  @override
  void initState() {
    print("createWatchList ${widget.isFromCauseListAdd}");
    if (widget.isUpdate) {
      _watchlistController.text =
          widget.updateData['watchlist_name'].toString();
    }
    super.initState();
  }

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
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(20),
          child: Stack(
            children: [
              SizedBox(
                height: mediaQH(context) * 0.25,
                width: mediaQW(context) * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 15),
                      child: Text(
                        widget.isUpdate
                            ? "Update Watchlist"
                            : "Please enter watchlist name.",
                        textAlign: TextAlign.center,
                        style: mpHeadLine14(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _watchlistController,
                        expands: false,
                        autofocus: true,
                        cursorColor: Colors.black,
                        readOnly: widget.isUpdate,
                        decoration: InputDecoration(
                          hintText: "Watchlist Name",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          border: boarder,
                          fillColor: widget.isUpdate
                              ? Colors.grey.shade200
                              : Colors.white,
                          focusedBorder: focusboarder,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (widget.isUpdate) {
                                String stringList =
                                    widget.selectedLawyerList.join(",");
                                print(stringList);
                                var body = {
                                  "watchlistId": widget
                                      .updateData['watchlist_id']
                                      .toString(),
                                  "caseList": stringList
                                };
                                BlocProvider.of<EditWatchlistCubit>(context)
                                    .editWatchlist(body);
                              } else {
                                Map<String, String> watchListBody = {
                                  "watchlist": _watchlistController.text,
                                  "type": widget.type,
                                  "from_date": "",
                                  "to_date": "",
                                };
                                BlocProvider.of<CreateWatchlistCubit>(context)
                                    .fetchCreateWatchlist(watchListBody);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: mediaQH(context) * 0.05,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(5)),
                                  border: Border.all(color: AppColor.primary)),
                              child: Text(
                                widget.isUpdate ? "Update" : "OK",
                                style:
                                    mpHeadLine16(textColor: AppColor.primary),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: mediaQH(context) * 0.05,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(5)),
                                color: AppColor.primary,
                              ),
                              child: Text(
                                "Cancel",
                                style: mpHeadLine16(textColor: AppColor.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              BlocConsumer<CreateWatchlistCubit, CreateWatchlistState>(
                  builder: (context, state) {
                if (state is CreateWatchlistLoading) {
                  return AppProgressIndicator();
                }
                return const SizedBox();
              }, listener: (context, state) {
                if (state is CreateWatchlistLoaded) {
                  var createWatchList = state.createWatchlistModel;
                  print("createWatchList $createWatchList");

                  if (createWatchList.result == 1) {
                    if (widget.isFromCauseListAdd) {
                      var body = {
                        "watchlistId":
                            createWatchList.data!.watchlistId.toString(),
                        "caseList": widget.caseId.toString()
                      };
                      BlocProvider.of<EditWatchlistCubit>(context)
                          .editWatchlist(body);
                    } else {
                      String stringList = widget.selectedLawyerList.join(",");
                      print(stringList);
                      var body = {
                        "watchlistId":
                            createWatchList.data!.watchlistId.toString(),
                        "caseList": stringList
                      };
                      BlocProvider.of<EditWatchlistCubit>(context)
                          .editWatchlist(body);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (ctx) => AppMsgPopup(
                          createWatchList.msg.toString(), btnCallback: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                    );
                  }
                }
              }),
              BlocConsumer<EditWatchlistCubit, EditWatchlistState>(
                  builder: (context, state) {
                if (state is EditWatchlistLoading) {
                  return AppProgressIndicator();
                }
                return const SizedBox();
              }, listener: (context, state) {
                if (state is EditWatchlistLoaded) {
                  var model = state.model;
                  Navigator.pop(context);
                  if (model.result == 1) {
                    BlocProvider.of<ShowWatchlistCubit>(context)
                        .fetchShowWatchlist();
                    toast(msg: model.msg.toString());
                    /* showDialog(
                            context: context,
                            builder: (ctx) => AppMsgPopup(
                              model.msg.toString(),isError: false,));*/
                  } else {
                    showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(model.msg.toString()));
                  }
                }
              }),
            ],
          ),
        ),
      ],
    );
  }
}
