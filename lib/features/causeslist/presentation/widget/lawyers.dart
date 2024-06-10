import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/causeslist/cubit/showwatchlist_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/showwatchlist_state.dart';
import 'package:haelo_flutter/features/causeslist/data/model/main_causelistdata_model.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/add_to_watchlist.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/lawyer_watchlist.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

import '../../../../core/utils/functions.dart';

class Lawyers extends StatefulWidget {
  final mainCauseListData;
  final setLawyerDataCallback;
  final searchedLawyerCallback;
  final selectedLawyers;
  final watchListId;
  const Lawyers(this.mainCauseListData, this.setLawyerDataCallback,
      this.searchedLawyerCallback, this.selectedLawyers,
      {this.watchListId, Key? key})
      : super(key: key);

  @override
  _LawyersState createState() => _LawyersState();
}

class _LawyersState extends State<Lawyers> {
  List? displayWatchList;
  List<String> selectedLawyerList = [];
  TextEditingController search_textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<LawyerName>? searchList = [];
  bool isSearch = false;
  List newList = [];
  late SharedPreferences pref;

  @override
  void initState() {
    pref = di.locator();
    if (widget.selectedLawyers != null &&
        widget.selectedLawyers.isNotEmpty &&
        widget.selectedLawyers != 'Select') {
      selectedLawyerList = widget.selectedLawyers.split(",");
      print("selectedLawyerList// $selectedLawyerList");
    }

    newList = [];

    for (var element in selectedLawyerList) {
      var result = widget.mainCauseListData.lawyerName!
          .indexWhere((e) => e.lawyerName == element);
      if (result != -1) {
        newList.add(widget.mainCauseListData.lawyerName![result]);
      }
    }
    for (var element in widget.mainCauseListData.lawyerName!) {
      if (!selectedLawyerList.contains(element.lawyerName)) {
        print("ok");
        newList.add(element);
      }
    }
    BlocProvider.of<ShowWatchlistCubit>(context).fetchShowWatchlist();
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocConsumer<ShowWatchlistCubit, ShowWatchlistState>(
                    builder: (context, state) {
                  return const SizedBox();
                }, listener: (context, state) {
                  if (state is ShowWatchlistLoaded) {
                    var showWatchList = state.showWatchlistModel;
                    if (showWatchList.result == 1) {
                      if (showWatchList.data != null) {
                        var showWatchListData = showWatchList.data;
                        displayWatchList = showWatchListData!.watchlist;
                      }
                    }
                    // else {
                    //   (toast(msg: showWatchList.msg.toString()));
                    // }
                  }
                }),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            // width: mediaQW(context) * 0.62,
                            child: TextFormField(
                              expands: false,
                              autofocus: true,
                              cursorColor: Colors.black,
                              controller: search_textController,
                              focusNode: _focusNode,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  searchFilterList(value.toLowerCase());
                                } else {
                                  setState(() {
                                    isSearch = false;
                                    searchList = [];
                                  });
                                }
                              },
                              style: mpHeadLine14(textColor: AppColor.black),
                              decoration: InputDecoration(
                                hintText: "Search",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                border: boarder,
                                focusedBorder: focusboarder,
                                suffixIcon:
                                    search_textController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.close_outlined,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                isSearch = false;
                                                search_textController.text = "";
                                                //isSearchFilter = false;
                                                searchList = [];
                                              });
                                              /* Clear the search field */
                                            },
                                          )
                                        : SizedBox(),
                              ),
                            ),
                          ),
                          widget.watchListId == null && isPrime(pref)
                              ? InkWell(
                                  onTap: () {
                                    if (displayWatchList != null &&
                                        displayWatchList!.isNotEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => LawyerWatchList(
                                              displayWatchList,
                                              selectedLawyerList,
                                              "1"));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => AddToWatchList(
                                              selectedLawyerList, "1"));
                                      // show_add_watchlist dialog
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Icon(
                                      Icons.add,
                                      size: 30,
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                      searchList!.isEmpty && !isSearch
                          ? ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                              ),
                              child: ListView.builder(
                                // physics: AlwaysScrollableScrollPhysics(),
                                itemCount:
                                    newList.isNotEmpty ? newList.length : 0,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: Theme(
                                          data: ThemeData(
                                            visualDensity: const VisualDensity(
                                                horizontal: VisualDensity
                                                    .minimumDensity,
                                                vertical: VisualDensity
                                                    .minimumDensity),
                                            unselectedWidgetColor:
                                                AppColor.primary,
                                          ),
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            value: selectedLawyerList.contains(
                                                newList![index]
                                                    .lawyerName
                                                    .toString()),
                                            onChanged: (value) {
                                              setState(() {
                                                if (value!) {
                                                  selectedLawyerList.add(
                                                      newList![index]
                                                          .lawyerName!);
                                                } else {
                                                  selectedLawyerList.remove(
                                                      newList![index]
                                                          .lawyerName!);
                                                }
                                              });
                                            },
                                            checkColor: AppColor.white,
                                            activeColor: AppColor.primary,
                                            title: Text(
                                              newList.isNotEmpty
                                                  ? newList![index]
                                                      .lawyerName
                                                      .toString()
                                                  : "",
                                              style: appTextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Divider(
                                          color: Colors.grey[300],
                                          thickness: 1.5,
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          : searchList != null && searchList!.isNotEmpty
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.7,
                                  ),
                                  child: ListView.builder(
                                    // physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: searchList!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            child: Theme(
                                              data: ThemeData(
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal:
                                                            VisualDensity
                                                                .minimumDensity,
                                                        vertical: VisualDensity
                                                            .minimumDensity),
                                                unselectedWidgetColor:
                                                    AppColor.primary,
                                              ),
                                              child: CheckboxListTile(
                                                contentPadding: EdgeInsets.zero,
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                value: selectedLawyerList
                                                    .contains(searchList![index]
                                                        .lawyerName
                                                        .toString()),
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value!) {
                                                      selectedLawyerList.add(
                                                          searchList![index]
                                                              .lawyerName!);
                                                    } else {
                                                      selectedLawyerList.remove(
                                                          searchList![index]
                                                              .lawyerName!);
                                                    }
                                                  });
                                                },
                                                checkColor: AppColor.white,
                                                activeColor: AppColor.primary,
                                                title: Text(
                                                  widget.mainCauseListData !=
                                                          null
                                                      ? searchList![index]
                                                          .lawyerName
                                                          .toString()
                                                      : "",
                                                  style: appTextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Divider(
                                              color: Colors.grey[300],
                                              thickness: 1.5,
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                    ),
                                    NoDataAvailable("Search data not found.",
                                        isTopmMargin: false),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (search_textController.text.isNotEmpty) {
                            selectedLawyerList.add(search_textController.text);
                          }

                          if (selectedLawyerList.isNotEmpty) {
                            String lawyerNames = selectedLawyerList.join(",");
                            if (widget.watchListId != null) {
                              widget.setLawyerDataCallback(
                                  lawyerNames, widget.watchListId.toString());
                            } else {
                              widget.setLawyerDataCallback(lawyerNames);
                            }
                          }
                          if (isSearch &&
                              (searchList == null || searchList!.isEmpty)) {
                            widget.searchedLawyerCallback(
                                search_textController.text);
                          }
                          print("selectedLawyerList $selectedLawyerList");
                          print(
                              "selectedLawyerList search_textController ${search_textController.text}");
                          setState(() {
                            /// provide a callback here
                            // showSelectedLawyerData = lawyerNames;
                            // showSelectedLawyerIndex = index;
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: mediaQH(context) * 0.05,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColor.primary)),
                          child: Text(
                            widget.watchListId != null ? "Update" : "OK",
                            style: mpHeadLine16(textColor: AppColor.primary),
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
        )
      ],
    );
  }

  void searchFilterList(String searchKey) {
    searchList = [];
    // var filterProductArray = <AdminUsers>[];
    List<LawyerName>? data = newList!.cast<LawyerName>();

    for (var item in data!) {
      if (item.lawyerName!.toLowerCase().contains(searchKey)) {
        if (!searchList!.contains(item)) {
          searchList!.add(item);
        }
      }
    }
    isSearch = true;
    //searchAdminUsers = filterProductArray;
    setState(() {});
  }
}
