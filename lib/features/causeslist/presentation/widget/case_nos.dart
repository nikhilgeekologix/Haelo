import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';

class CaseNoWidget extends StatefulWidget {
  final list;
  final callback;

  const CaseNoWidget(this.list, this.callback, {Key? key}) : super(key: key);

  @override
  State<CaseNoWidget> createState() => _CaseNosState();
}

class _CaseNosState extends State<CaseNoWidget> {
  List dataList = [];

  //done by rahul
  TextEditingController search_textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
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
                        ],
                      ),
                      searchList.isEmpty && !isSearch
                          ? ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                              ),
                              child: Scrollbar(
                                thickness: 10,
                                thumbVisibility: true,
                                radius: const Radius.circular(10),
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
                                              print("index $index");
                                              if (index == 0) {
                                                selectedString = "None";
                                              } else {
                                                selectedString =
                                                    dataList[index - 1]
                                                        .caseNo
                                                        .toString();
                                              }
                                              // index == 0
                                              //     ? selectedString = "None"
                                              //     : dataList[index - 1]
                                              //         .caseNo
                                              //         .toString();
                                              // print("caseno ${dataList[index - 1]
                                              //     .caseNo
                                              //     .toString()}");
                                              print(
                                                  "selectedString $selectedString");
                                              widget.callback(selectedString);
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: SizedBox(
                                            height: 30,
                                            child: index == 0
                                                ? Text("None")
                                                : Text(
                                                    dataList[index - 1]
                                                        .caseNo
                                                        .toString(),
                                                    textAlign: TextAlign.center,
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
                              ),
                            )
                          : searchList != null && searchList.isNotEmpty
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.7,
                                  ),
                                  child: Scrollbar(
                                    thickness: 10,
                                    thumbVisibility: true,
                                    radius: const Radius.circular(10),
                                    child: ListView.builder(
                                      // physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: searchList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  String selectedString =
                                                      "None";
                                                  if (searchList[index] ==
                                                      "none") {
                                                    selectedString = "None";
                                                  } else {
                                                    selectedString =
                                                        searchList[index]
                                                            .caseNo
                                                            .toString();
                                                  }
                                                  widget
                                                      .callback(selectedString);
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: SizedBox(
                                                height: 30,
                                                child: searchList[index] ==
                                                        "none"
                                                    ? const Text("None")
                                                    : Text(
                                                        searchList[index]
                                                            .caseNo
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
      if (dataList[i].caseNo.toString().toLowerCase().contains(searchKey)) {
        if (!searchList!.contains(dataList[i])) {
          searchList!.add(dataList[i]);
        }
      }
      // print("searchlist length ${searchList.length}");
      isSearch = true;
      setState(() {});
    }
  }
}
