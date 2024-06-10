import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';

class CauseListPopup extends StatefulWidget {
  final list;
  final listName;
  final callback;

  const CauseListPopup(this.list, this.listName, this.callback, {Key? key})
      : super(key: key);

  @override
  State<CauseListPopup> createState() => _CaseNosState();
}

class _CaseNosState extends State<CauseListPopup> {
  List dataList = [];

  //done by rahul
  TextEditingController search_textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List searchList = [];
  bool isSearch = false;

  @override
  void initState() {
    //print("widget lst ${widget.list}");
    dataList = widget.list;
    // dataList.insert(0, "None");
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
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.listName != 6
                              ? Expanded(
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
                                    style:
                                        mpHeadLine14(textColor: AppColor.black),
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                      border: boarder,
                                      focusedBorder: focusboarder,
                                      suffixIcon: search_textController
                                              .text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.close_outlined,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isSearch = false;
                                                  search_textController.text =
                                                      "";
                                                  //isSearchFilter = false;
                                                  searchList = [];
                                                });
                                                /* Clear the search field */
                                              },
                                            )
                                          : SizedBox(),
                                    ),
                                  ),
                                )
                              : SizedBox(),
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
                                itemCount: dataList!.length + 1,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            String selectedString = "None";
                                            index == 0
                                                ? selectedString = "None"
                                                : selectedString = widget
                                                            .listName ==
                                                        1
                                                    ? dataList[index - 1]
                                                        .causeListType
                                                        .toString()
                                                    : widget.listName == 2
                                                        ? dataList[index - 1]
                                                            .courtNo
                                                            .toString()
                                                        : widget.listName == 3
                                                            ? dataList[
                                                                    index - 1]
                                                                .benchName
                                                                .toString()
                                                            : widget.listName ==
                                                                    4
                                                                ? dataList[
                                                                        index -
                                                                            1]
                                                                    .caseNo
                                                                    .toString()
                                                                : widget.listName ==
                                                                        5
                                                                    ? dataList[
                                                                            index -
                                                                                1]
                                                                        .partyName
                                                                        .toString()
                                                                    : dataList[
                                                                            index -
                                                                                1]
                                                                        .toString();
                                            widget.callback(selectedString,
                                                widget.listName);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          width: double.maxFinite,
                                          // decoration: BoxDecoration(
                                          //     border: Border(
                                          //         bottom: BorderSide(
                                          //   color: AppColor.grey_color,
                                          // ))),
                                          alignment: Alignment.center,
                                          child: index == 0
                                              ? const Text("None")
                                              : widget.listName == 1
                                                  ? Text(dataList[index - 1]
                                                      .causeListType
                                                      .toString())
                                                  : widget.listName == 2
                                                      ? Text(dataList[index - 1]
                                                          .courtNo
                                                          .toString())
                                                      : widget.listName == 3
                                                          ? Text(
                                                              dataList[
                                                                      index - 1]
                                                                  .benchName
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          : widget.listName == 4
                                                              ? Text(dataList[
                                                                      index - 1]
                                                                  .caseNo
                                                                  .toString())
                                                              : widget.listName ==
                                                                      5
                                                                  ? Text(
                                                                      dataList[index -
                                                                              1]
                                                                          .partyName
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center)
                                                                  : Text(dataList[
                                                                          index -
                                                                              1]
                                                                      .toString()),
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
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                String selectedString = "None";
                                                if (searchList[index] ==
                                                    "none") {
                                                  selectedString = "None";
                                                } else {
                                                  selectedString = widget
                                                              .listName ==
                                                          1
                                                      ? searchList[index]
                                                          .causeListType
                                                          .toString()
                                                      : widget.listName == 2
                                                          ? searchList[index]
                                                              .courtNo
                                                              .toString()
                                                          : widget.listName == 3
                                                              ? searchList[
                                                                      index]
                                                                  .benchName
                                                                  .toString()
                                                              : widget.listName ==
                                                                      4
                                                                  ? searchList[
                                                                          index]
                                                                      .caseNo
                                                                      .toString()
                                                                  : widget.listName ==
                                                                          5
                                                                      ? searchList[
                                                                              index]
                                                                          .partyName
                                                                          .toString()
                                                                      : searchList[
                                                                              index]
                                                                          .toString();
                                                }
                                                widget.callback(selectedString,
                                                    widget.listName);
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              width: double.maxFinite,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                color: AppColor.grey_color,
                                              ))),
                                              alignment: Alignment.center,
                                              child: searchList[index] == "none"
                                                  ? const Text("None")
                                                  : widget.listName == 1
                                                      ? Text(searchList[index]
                                                          .causeListType
                                                          .toString())
                                                      : widget.listName == 2
                                                          ? Text(
                                                              searchList[index]
                                                                  .courtNo
                                                                  .toString())
                                                          : widget.listName == 3
                                                              ? Text(
                                                                  searchList[
                                                                          index]
                                                                      .benchName
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              : widget.listName ==
                                                                      4
                                                                  ? Text(searchList[
                                                                          index]
                                                                      .caseNo
                                                                      .toString())
                                                                  : widget.listName ==
                                                                          5
                                                                      ? Text(
                                                                          searchList[index]
                                                                              .partyName
                                                                              .toString(),
                                                                          textAlign: TextAlign
                                                                              .center)
                                                                      : Text(searchList[
                                                                              index]
                                                                          .toString()),
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

    if ("none".contains(searchKey.toLowerCase())) {
      if (!searchList.contains("none")) {
        searchList.add("none");
      }
    }

    for (int i = 0; i < dataList.length; i++) {
      if (widget.listName == 1) {
        if (dataList[i]
            .causeListType
            .toString()
            .toLowerCase()
            .contains(searchKey.toLowerCase())) {
          if (!searchList!.contains(dataList[i])) {
            searchList!.add(dataList[i]);
          }
        }
      }

      if (widget.listName == 2) {
        if (dataList[i].courtNo.toString().toLowerCase().contains(searchKey)) {
          if (!searchList!.contains(dataList[i])) {
            searchList!.add(dataList[i]);
          }
        }
      }

      if (widget.listName == 3) {
        if (dataList[i]
            .benchName
            .toString()
            .toLowerCase()
            .contains(searchKey)) {
          if (!searchList!.contains(dataList[i])) {
            searchList!.add(dataList[i]);
          }
        }
      }

      if (widget.listName == 4) {
        if (dataList[i].caseNo.toString().toLowerCase().contains(searchKey)) {
          if (!searchList!.contains(dataList[i])) {
            searchList!.add(dataList[i]);
          }
        }
      }

      if (widget.listName == 5) {
        if (dataList[i]
            .partyName
            .toString()
            .toLowerCase()
            .contains(searchKey)) {
          if (!searchList!.contains(dataList[i])) {
            searchList!.add(dataList[i]);
          }
        }
      }
    }

    // for (int i = 0; i < dataList.length; i++) {
    //   if (dataList[i].caseNo.toString().toLowerCase().contains(searchKey)) {
    //     if (!searchList!.contains(dataList[i])) {
    //       searchList!.add(dataList[i]);
    //     }
    //   }
    //   // print("searchlist length ${searchList.length}");
    //   isSearch = true;
    //   setState(() {});
    // }
    isSearch = true;
    setState(() {});
  }
}
