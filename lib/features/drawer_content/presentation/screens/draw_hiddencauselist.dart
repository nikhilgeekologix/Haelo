import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/hightlight_text.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/hidden_causelist_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/hidden_causelist_state.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/unhide_causelist_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/unhide_causelist_state.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:haelo_flutter/features/drawer_content/data/model/hidden_causelist_model.dart';

class HiddenCauselist extends StatefulWidget {
  const HiddenCauselist({Key? key}) : super(key: key);

  @override
  State<HiddenCauselist> createState() => _HiddenCauselistState();
}

class _HiddenCauselistState extends State<HiddenCauselist> {

  var hiddenCauseListData;

  @override
  void initState() {
    // pref = di.locator();
    BlocProvider.of<HiddenCauseListCubit>(context).fetchHiddenCauseList();
    super.initState();
  }

  bool isSearch = false;
  bool isLoading = true;
  bool isSearchFilter=false;
  TextEditingController search_textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<Causelist> searchList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.home_background,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 24,
          ),
        ),
        backgroundColor: AppColor.white,
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          isSearch ? "" : "My Hidden Causes",
          style: mpHeadLine16(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: isSearch
            ? [
                Container(
                  width: mediaQW(context) * 0.8,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextField(
                        onChanged: (value) {
                          if(value.isNotEmpty) {
                            searchFilterList(value.toLowerCase());
                          }else{
                            setState(() {
                              isSearchFilter=false;
                              searchList=[];
                            });
                          }
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  isSearch = false;
                                  isSearchFilter=false;
                                  searchList=[];
                                });
                                /* Clear the search field */
                              },
                            ),
                            hintText: 'Search...',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        goToHomePage(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.home_outlined,
                          size: 30,
                        ),
                      ),
                    )),
              ]
            : [
                IconButton(
                    onPressed: () => setState(() {
                          isSearch = true;
                        }),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    )),
                // const SizedBox(
                //   width: 22,
                // ),
                GestureDetector(
                  onTap: () {
                    goToHomePage(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.home_outlined,
                      size: 30,
                    ),
                  ),
                )
              ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: BlocConsumer<HiddenCauseListCubit, HiddenCauseListState>(
                builder: (context, state) {
                  if (state is HiddenCauseListLoaded) {
                    var hiddenCauseList = state.hiddenCauseListModel;
                    if (hiddenCauseList.result == 1) {
                      if (hiddenCauseList.data != null) {
                         hiddenCauseListData = hiddenCauseList.data;
                        return hiddenCauseListData!=null && hiddenCauseListData!.causelist.isNotEmpty?

                          searchList.isEmpty && !isSearchFilter?
                        ListView.builder(
                          itemCount: hiddenCauseListData!.causelist!.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.only(
                                  top: 10, left: 15, right: 15, bottom: 10),
                              color: AppColor.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: mediaQW(context) * 0.8,
                                          child: RichText(
                                            text: TextSpan(
                                                text: "(Court No. ${hiddenCauseListData
                                                    .causelist![index].courtNo}) ",
                                                style: mpHeadLine12(
                                                    fontWeight:
                                                        FontWeight.w600),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: hiddenCauseListData
                                                          .causelist![index]
                                                          .benchName
                                                          .toString(),
                                                      style: mpHeadLine12(
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ]),
                                          ),
                                        ),
                                        Container(
                                          width: 15,
                                          height: 30,
                                          child: PopupMenuButton<int>(
                                            onSelected: (i) async {
                                              if (i == 1) {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) {
                                                      return AlertDialog(
                                                        // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        content: SizedBox(
                                                          // height:
                                                          //     mediaQH(context) *
                                                          //         0.16,
                                                          // width: mediaQW(context) * 0.8,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15,
                                                                        top:
                                                                            25),
                                                                child: Text(
                                                                  "Are you sure you want to unhide your cause ${hiddenCauseListData.causelist![index].caseNo.toString()}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: mpHeadLine14(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 25,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {

                                                                        var unhideList =
                                                                            {
                                                                          "causeId": hiddenCauseListData
                                                                              .causelist![index]
                                                                              .causeId
                                                                              .toString(),
                                                                        };
                                                                        BlocProvider.of<UnHideCauseListCubit>(context)
                                                                            .fetchUnHideCauseList(unhideList);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        height: mediaQH(context) *
                                                                            0.05,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                const BorderRadius.only(bottomLeft: Radius.circular(5)),
                                                                            border: Border.all(color: AppColor.primary)),
                                                                        child:
                                                                            Text(
                                                                          "Yes",
                                                                          style:
                                                                              mpHeadLine16(textColor: AppColor.primary),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        height: mediaQH(context) *
                                                                            0.05,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.only(bottomRight: Radius.circular(5)),
                                                                          color:
                                                                              AppColor.primary,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "No",
                                                                          style:
                                                                              mpHeadLine16(textColor: AppColor.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            },
                                            padding: EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.more_vert_outlined,
                                              size: 22,
                                              color: AppColor.black,
                                            ),
                                            itemBuilder: (context) => [
                                              // popupmenu item 1
                                              const PopupMenuItem(
                                                value: 1,
                                                child: Text("Unhide"),
                                              ),
                                            ],
                                            offset: Offset(-15, 10),
                                            color: Colors.white,
                                            elevation: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [

                                        Text("Sr. No: "+hiddenCauseListData
                                            .causelist![index].sno
                                            .toString(),style: mpHeadLine12(
                                            fontWeight:
                                            FontWeight
                                                .w600)),
                                        Flexible(
                                          child: HighlightText(
                                            "${ hiddenCauseListData
                                                .causelist![index]
                                                .causeListType!=null && hiddenCauseListData
                                                .causelist![index]
                                                .causeListType=="Daily"?" (D)":" (S)"}",
                                            "(S)",
                                            mpHeadLine12(
                                                fontWeight:
                                                FontWeight.w500,
                                                textColor:
                                                AppColor.black),
                                            mpHeadLine12(
                                                fontWeight:
                                                FontWeight.w500,
                                                textColor: Colors.red),
                                          ),
                                        ),



                                        // RichText(
                                        //   text: TextSpan(
                                        //       text: "Sr. No: ",
                                        //       style: mpHeadLine12(
                                        //           fontWeight: FontWeight.w600),
                                        //       children: <TextSpan>[
                                        //         TextSpan(
                                        //             text: hiddenCauseListData
                                        //                 .causelist![index].sno
                                        //                 .toString(),
                                        //             style: mpHeadLine12(
                                        //                 fontWeight:
                                        //                     FontWeight.w600)),
                                        //       ]),
                                        // ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          hiddenCauseListData
                                              .causelist![index].caseNo
                                              .toString(),
                                          style: mpHeadLine14(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      hiddenCauseListData
                                          .causelist![index].stage
                                          .toString(),
                                      style: mpHeadLine12(),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      width: mediaQW(context) * 0.9,
                                      child: Text(
                                        hiddenCauseListData
                                            .causelist![index].partyName
                                            .toString(),
                                        style: mpHeadLine12(
                                            fontWeight: FontWeight.w600,
                                            textColor: AppColor.primary),
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 2,
                                      color: AppColor.primary,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Petitioner:",
                                          style: mpHeadLine12(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        SizedBox(
                                          width: mediaQW(context) * 0.65,
                                          child: Text(
                                              hiddenCauseListData
                                                  .causelist![index].petitioner
                                                  .toString(),
                                              style: mpHeadLine12(
                                                  fontWeight: FontWeight.w400)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Respondent:",
                                          style: mpHeadLine12(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        SizedBox(
                                            width: mediaQW(context) * 0.66,
                                            child: Text(
                                                hiddenCauseListData
                                                    .causelist![index]
                                                    .respondent
                                                    .toString(),
                                                style: mpHeadLine12(
                                                    fontWeight:
                                                        FontWeight.w400)))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ):searchList.isNotEmpty?
                        ListView.builder(
                          itemCount: searchList.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.only(
                                  top: 10, left: 15, right: 15, bottom: 10),
                              color: AppColor.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: mediaQW(context) * 0.8,
                                          child: RichText(
                                            text: TextSpan(
                                                text: "(Court No. ${searchList[index].courtNo}) ",
                                                style: mpHeadLine12(
                                                    fontWeight:
                                                    FontWeight.w600),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: searchList[index]
                                                          .benchName
                                                          .toString(),
                                                      style: mpHeadLine12(
                                                          fontWeight:
                                                          FontWeight.w600)),
                                                ]),
                                          ),
                                        ),
                                        Container(
                                          width: 15,
                                          height: 30,
                                          child: PopupMenuButton<int>(
                                            onSelected: (i) async {
                                              if (i == 1) {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) {
                                                      return AlertDialog(
                                                        // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                                        contentPadding:
                                                        EdgeInsets.zero,
                                                        content: SizedBox(
                                                          // height:
                                                          //     mediaQH(context) *
                                                          //         0.16,
                                                          // width: mediaQW(context) * 0.8,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    15,
                                                                    right:
                                                                    15,
                                                                    top:
                                                                    25),
                                                                child: Text(
                                                                  "Are you sure you want to unhide your cause ${searchList![index].caseNo.toString()}",
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: mpHeadLine14(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 25,
                                                              ),
                                                              Row(
                                                                children: [

                                                                  Expanded(
                                                                    child:
                                                                    InkWell(
                                                                      onTap:
                                                                          () {

                                                                        var unhideList =
                                                                        {
                                                                          "causeId": searchList[index]
                                                                              .causeId
                                                                              .toString(),
                                                                        };
                                                                        BlocProvider.of<UnHideCauseListCubit>(context)
                                                                            .fetchUnHideCauseList(unhideList);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                      Container(
                                                                        alignment:
                                                                        Alignment.center,
                                                                        height: mediaQH(context) *
                                                                            0.05,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            const BorderRadius.only(bottomLeft: Radius.circular(5)),
                                                                            border: Border.all(color: AppColor.primary)),
                                                                        child:
                                                                        Text(
                                                                          "Yes",
                                                                          style:
                                                                          mpHeadLine16(textColor: AppColor.primary),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                      Container(
                                                                        alignment:
                                                                        Alignment.center,
                                                                        height: mediaQH(context) *
                                                                            0.05,
                                                                        decoration:
                                                                        const BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.only(bottomRight: Radius.circular(5)),
                                                                          color:
                                                                          AppColor.primary,
                                                                        ),
                                                                        child:
                                                                        Text(
                                                                          "No",
                                                                          style:
                                                                          mpHeadLine16(textColor: AppColor.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            },
                                            padding: EdgeInsets.all(0),
                                            icon: const Icon(
                                              Icons.more_vert_outlined,
                                              size: 22,
                                              color: AppColor.black,
                                            ),
                                            itemBuilder: (context) => [
                                              // popupmenu item 1
                                              const PopupMenuItem(
                                                value: 1,
                                                child: Text("Unhide"),
                                              ),
                                            ],
                                            offset: Offset(-15, 10),
                                            color: Colors.white,
                                            elevation: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                              text: "Sr. No: ",
                                              style: mpHeadLine12(
                                                  fontWeight: FontWeight.w600),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: searchList![index].sno
                                                        .toString(),
                                                    style: mpHeadLine12(
                                                        fontWeight:
                                                        FontWeight.w600)),
                                              ]),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          searchList[index].caseNo
                                              .toString(),
                                          style: mpHeadLine14(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      searchList[index].stage
                                          .toString(),
                                      style: mpHeadLine12(),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      width: mediaQW(context) * 0.9,
                                      child: Text(
                                        searchList[index].partyName
                                            .toString(),
                                        style: mpHeadLine12(
                                            fontWeight: FontWeight.w600,
                                            textColor: AppColor.primary),
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 2,
                                      color: AppColor.primary,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Petitioner:",
                                          style: mpHeadLine12(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        SizedBox(
                                          width: mediaQW(context) * 0.65,
                                          child: Text(
                                              searchList[index].petitioner
                                                  .toString(),
                                              style: mpHeadLine12(
                                                  fontWeight: FontWeight.w400)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Respondent:",
                                          style: mpHeadLine12(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        SizedBox(
                                            width: mediaQW(context) * 0.66,
                                            child: Text(
                                                searchList[index]
                                                    .respondent
                                                    .toString(),
                                                style: mpHeadLine12(
                                                    fontWeight:
                                                    FontWeight.w400)))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ):NoDataAvailable(
                              "Search data not found."):isLoading?SizedBox():
                        NoDataAvailable(
                            "Your Hidden Causes will be shown here."
                        );
                      }
                    }
                    return isLoading?SizedBox():NoDataAvailable(
                        "Your Hidden Causes will be shown here."
                    );
                  }
                  return const SizedBox();
                },
                listener: (context, state) {
                  if (state is HiddenCauseListLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  }
                  else{
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
            ),
            Visibility(
              visible: isLoading,
              child: const Center(child: AppProgressIndicator()),
            ),
            BlocConsumer<
                UnHideCauseListCubit,
                UnHideCauseListState>(
              builder:
                  (context,
                  state) {
                return const SizedBox();
              },
              listener:
                  (context,
                  state) {
                if(state is UnHideCauseListLoading){
                  setState(() {
                    isLoading=true;
                  });
                }
                if (state
                is UnHideCauseListLoaded) {
                  var unhideCauseList =
                      state.unHideCauseListModel;
                  if (unhideCauseList.result ==
                      1) {
                    BlocProvider.of<HiddenCauseListCubit>(context)
                        .fetchHiddenCauseList();

                  }else{
                    toast(
                        msg: unhideCauseList.msg.toString());
                  }
                  setState(() {
                    isLoading=false;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void searchFilterList(String searchKey) {

    setState(() {
      searchList=[];
    });

    for (var item in hiddenCauseListData!.causelist!) {
      if (item.courtNo!.toLowerCase().contains(searchKey) || item.petitioner!.toLowerCase().contains(searchKey) ||
          item.benchName!.toLowerCase().contains(searchKey) || item.caseNo!.toLowerCase().contains(searchKey) ||
          item.partyName!.toLowerCase().contains(searchKey) || item.respondent!.toLowerCase().contains(searchKey) ||
          item.sno!.toLowerCase().contains(searchKey) || //item.bottomNo!.toLowerCase().contains(searchKey) ||
          item.stage!.toLowerCase().contains(searchKey) || item.causeListDate!.toLowerCase().contains(searchKey) ) {
        if (!searchList.contains(item)) {
          searchList.add(item);
        }
      }
    }
    print("searchlist length ${searchList.length}");
    isSearchFilter=true;
    setState(() {});
  }


}
