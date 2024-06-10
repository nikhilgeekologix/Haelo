import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/cubit/cmt_suggestion/cmt_suggestion_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/cmt_suggestion/cmt_suggestion_state.dart';
import 'package:haelo_flutter/features/cases/cubit/comments_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/updatecomment_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/updatecomment_state.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/tab_progress_indicator.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/widgets/commonButtons.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:intl/intl.dart';

class EditComment extends StatefulWidget {
  final getCaseIdd;
  final commentId;
  final getComment;
  final bool isCaseHistory;
  final getDateOfListing;
  final courtDate;
  final dateType;
  final noOfWeek;

  const EditComment(
      {Key? key,
      this.getCaseIdd,
      this.commentId,
      this.getComment,
      this.isCaseHistory = false,
      this.getDateOfListing,
      this.courtDate,
      this.dateType,
      this.noOfWeek})
      : super(key: key);

  @override
  State<EditComment> createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  bool _seletedDate = false;
  DateTime date = DateTime.now();

  String dropdownvalue = 'On';
  var items = ['Not Set', 'On', 'After'];

  TextEditingController _commentController = TextEditingController();
  TextEditingController _weekController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    Map<String, String> body = {};
    BlocProvider.of<CommentSuggestionCubit>(context)
        .fetchCommentSuggestion(body);

    _commentController.text = widget.getComment;
    print("update cmt dateType ${widget.dateType}");
    if (widget.dateType != null && widget.dateType == "On") {
      dropdownvalue = "On";
      DateFormat format = DateFormat("dd/MM/yyyy");
      // print(format.parse(widget.courtDate));
      if (format.parse(widget.courtDate).isBefore(DateTime.now())) {
        date = DateTime.now();
      } else {
        date = format.parse(widget.courtDate);
      }
      // date = format.parse(widget.courtDate);
      // date.isBefore(DateTime.now())?date:DateTime.now()
      _seletedDate = true;
    } else if (widget.dateType != null && widget.dateType == "After") {
      dropdownvalue = "After";
      _weekController.text = widget.noOfWeek.toString();
      _seletedDate = false;
    }

    // if(widget.apiDateOfListing!=null && widget.apiDateOfListing.toString().isNotEmpty) {
    //   dropdownvalue="On";
    //   DateFormat format = DateFormat("dd/MM/yyyy");
    //   print(format.parse(widget.apiDateOfListing));
    //   date = format.parse(widget.apiDateOfListing);
    //   _seletedDate = true;
    // }
    else {
      dropdownvalue = "Not Set";
      _seletedDate = false;
    }
    print(">>date $date");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          titleSpacing: -5,
          title: Text(
            "Update Comment",
            style: mpHeadLine16(
                fontWeight: FontWeight.w500,
                textColor: AppColor.bold_text_color_dark_blue),
          ),
          actions: [
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
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocConsumer<UpdateCommentCubit, UpdateCommentState>(
                        builder: (context, state) {
                          return const SizedBox();
                        },
                        listener: (context, state) {
                          if (state is UpdateCommentLoading) {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          if (state is UpdateCommentLoaded) {
                            var addCommentList = state.updateCommentModel;
                            if (addCommentList.result == 1) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context, true);
                              toast(msg: addCommentList.msg.toString());
                              /* showDialog(
                                  context: context,
                                  builder: (ctx) => AppMsgPopup(
                                        addCommentList.msg.toString(),
                                        isCloseIcon: false,
                                        isError: false,
                                        btnCallback: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context, true);
                                        },
                                      ));*/
                              var caseIdDetails = {
                                "caseId": widget.getCaseIdd.toString(),
                              };
                              BlocProvider.of<CasesCommentCubit>(context)
                                  .fetchCasesComment(caseIdDetails);
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AppMsgPopup(
                                        addCommentList.msg.toString(),
                                      ));
                            }
                          }
                        },
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 12, top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                                controller: _commentController,
                                cursorColor: Colors.black,
                                cursorHeight: 25,
                                maxLines: 40,
                                minLines: 10,
                                decoration: InputDecoration(
                                  // hintText: widget.getComment,
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1.5, color: Colors.black54),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  errorBorder: errorboarder,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1.5, color: Colors.black54),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: boarder,
                                ),
                                textInputAction: TextInputAction.done),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              Constants.comment_note,
                              style: appTextStyle(
                                  textColor: AppColor.rejected_color_text),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            widget.isCaseHistory
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Listing date:",
                                        style: mpHeadLine16(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        height: mediaQH(context) * 0.05,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black54, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width: mediaQW(context) * 0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 50),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            underline: SizedBox(),
                                            // Initial Value
                                            value: dropdownvalue,

                                            // Down Arrow Icon
                                            icon: const Icon(
                                                Icons.arrow_drop_down),

                                            // Array list of items
                                            items: items.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            // After selecting the desired option,it will
                                            // change button value to selected value
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _seletedDate = false;
                                                _weekController.text = "";
                                                dropdownvalue = newValue!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            const SizedBox(
                              height: 25,
                            ),
                            widget.isCaseHistory
                                ? Text(
                                    dropdownvalue == "After"
                                        ? "Enter Weeks"
                                        : dropdownvalue == "On"
                                            ? "Select Date"
                                            : "",
                                    style: mpHeadLine14(
                                        fontWeight: FontWeight.w500,
                                        textColor:
                                            AppColor.bold_text_color_dark_blue),
                                  )
                                : SizedBox(),
                            const SizedBox(
                              height: 6,
                            ),
                            !widget.isCaseHistory
                                ? SizedBox()
                                : dropdownvalue == "After"
                                    ? TextFormField(
                                        controller: _weekController,
                                        cursorColor: Colors.black54,
                                        cursorHeight: 25,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10),
                                          hintText: "Example: 3",
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1.5,
                                                color: Colors.black54),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          errorBorder: errorboarder,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1.5,
                                                color: Colors.black54),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          border: boarder,
                                        ),
                                      )
                                    : dropdownvalue == "On"
                                        ? InkWell(
                                            onTap: () async {
                                              //print("date $date");
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());

                                              DateTime? newDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate:
                                                    date, //currently selected
                                                firstDate: DateTime
                                                    .now(), //from where date enable
                                                lastDate: DateTime(2100),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      colorScheme:
                                                          ColorScheme.light(
                                                        primary: AppColor
                                                            .primary, // <-- SEE HERE
                                                        onPrimary: Colors
                                                            .white, // <-- SEE HERE
                                                        onSurface: Colors
                                                            .black, // <-- SEE HERE
                                                      ),
                                                      textButtonTheme:
                                                          TextButtonThemeData(
                                                        style: TextButton.styleFrom(
                                                            // primary: AppColor.primary,
                                                            // button text color
                                                            ),
                                                      ),
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                              );
                                              if (newDate == null) return;
                                              setState(() {
                                                date = newDate;
                                                _seletedDate = true;
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: mediaQH(context) * 0.05,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black54,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              width: mediaQW(context) * 1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: _seletedDate == false
                                                    ? Text(
                                                        "Example: 25.05.2022",
                                                        style: mpHeadLine16(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    : Text(
                                                        "${date.day.toString().length > 1 ? date.day : "0${date.day}"}/${date.month.toString().length > 1 ? date.month : "0${date.month}"}/${date.year}",
                                                        style: mpHeadLine16(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: BlocConsumer<CommentSuggestionCubit,
                                        CommentSuggestionState>(
                                    builder: (context, state) {
                                      if (state is CommentSuggestionLoading) {
                                        return TabProgressIndicator();
                                      }
                                      if (state is CommentSuggestionLoaded) {
                                        var model = state.model;
                                        if (model.result == 1) {
                                          if (model.data != null) {
                                            var suggestionList = model.data;
                                            // toast(msg: expensesList.msg.toString());
                                            return suggestionList!.isNotEmpty
                                                ? Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    runAlignment:
                                                        WrapAlignment.center,
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children:
                                                        suggestionList.map((e) {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10,
                                                                bottom: 10),
                                                        child: InkWell(
                                                          onTap: () {
                                                            _commentController
                                                                    .text =
                                                                "${_commentController.text} ${e.text} ";
                                                            _commentController
                                                                    .selection =
                                                                TextSelection.collapsed(
                                                                    offset: _commentController
                                                                        .text
                                                                        .length);
                                                            // _commentController.selection =
                                                            //     TextSelection.fromPosition(TextPosition(offset: _commentController.text.length));
                                                            //  _commentController.moveCursorToEnd();
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: AppColor
                                                                        .primary),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: AppColor
                                                                    .white),

                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        15),
                                                            child: Text(
                                                                e.text ?? "",
                                                                style:
                                                                    appTextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                )),
                                                            // margin: EdgeInsets.only(right: 10,bottom: 10),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  )
                                                : SizedBox();
                                          }
                                        }
                                        return SizedBox();
                                      }
                                      return const SizedBox();
                                    },
                                    listener: (context, state) {}),
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  const Positioned.fill(
                    child: Center(
                      child: AppProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /* Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10.0),
              child: BlocConsumer<CommentSuggestionCubit, CommentSuggestionState>(
                  builder: (context, state) {
                    if (state is CommentSuggestionLoading) {
                      return TabProgressIndicator();
                    }
                    if (state is CommentSuggestionLoaded) {
                      var model = state.model;
                      if (model.result == 1) {
                        if (model.data != null) {
                          var suggestionList = model.data;
                          // toast(msg: expensesList.msg.toString());
                          return suggestionList!.isNotEmpty?
                          Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            alignment: WrapAlignment.center,
                            children: suggestionList.map((e) {
                              return Padding(
                                padding: EdgeInsets.only(right: 10,bottom: 10),
                                child: InkWell(
                                  onTap: (){
                                    _commentController.text=e.text??"";
                                    _commentController.selection =
                                        TextSelection.collapsed(offset: _commentController.text.length);
                                    // _commentController.selection =
                                    //     TextSelection.fromPosition(TextPosition(offset: _commentController.text.length));
                                    //  _commentController.moveCursorToEnd();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: AppColor.primary),
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColor.white
                                    ),

                                    padding: EdgeInsets.symmetric(vertical: 4,
                                        horizontal: 15),
                                    child: Text(e.text??"",style: appTextStyle(
                                      fontWeight: FontWeight.w500,
                                    )),
                                    // margin: EdgeInsets.only(right: 10,bottom: 10),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                              : SizedBox();
                        }
                      } return  SizedBox();
                    }
                    return const SizedBox();
                  },
                  listener: (context, state) {}),
            ),*/

            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: CommonButtons(
                  buttonText: "Update",
                  buttonCall: () {
                    if (_commentController.text.trim().isEmpty) {
                      toast(msg: "Please enter your comment");
                      return;
                    }

                    if (dropdownvalue == "On" && !_seletedDate) {
                      toast(msg: "Please select date");
                      return;
                    }
                    if (dropdownvalue == "After" &&
                        _weekController.text.isEmpty) {
                      toast(msg: "Please enter week value");
                      return;
                    }

                    FocusScope.of(context).requestFocus(FocusNode());
                    Map<String, String> commentDetails = {};
                    if (widget.isCaseHistory == true) {
                      commentDetails['commentId'] = widget.commentId.toString();
                      commentDetails['caseId'] = widget.getCaseIdd.toString();
                      commentDetails['comment'] =
                          _commentController.text.trim();
                      commentDetails['commentDate'] =
                          widget.getDateOfListing != null &&
                                  widget.getDateOfListing.toString().isNotEmpty
                              ? getYYYYMMDD(widget.getDateOfListing.toString())
                              : "";
                      commentDetails['dateOfListing'] = dropdownvalue == "On"
                          ? getYYYYMMDDNew(date.toString())
                          : "";
                      commentDetails['weekOfListing'] =
                          dropdownvalue == "After" ? _weekController.text : "";
                      commentDetails['finalDate'] =
                          getYYYYMMDDNew(DateTime.now().toString());
                      commentDetails['dateType'] = dropdownvalue == "On"
                          ? "On"
                          : dropdownvalue == "After"
                              ? "After"
                              : "";
                    } else {
                      commentDetails['commentId'] = widget.commentId.toString();
                      commentDetails['caseId'] = widget.getCaseIdd.toString();
                      commentDetails['comment'] =
                          _commentController.text.trim();
                    }

                    // var commentDetailsOld = {
                    //   "caseId": widget.getCaseIdd.toString(),
                    //   "comment": _commentController.text,
                    //   "commentId": widget.commentId.toString(),
                    //   "dateOfListing": "",
                    //   "weekOfListing": _weekController.text,
                    // };
                    BlocProvider.of<UpdateCommentCubit>(context)
                        .fetchUpdateComment(commentDetails);
                  }),
            ),
          ],
        ));

    // floatingActionButton: Padding(
    //   padding: const EdgeInsets.only(left: 30),
    //   child: Column(mainAxisAlignment: MainAxisAlignment.end,
    //     children: [
    //       Padding(
    //         padding:  EdgeInsets.symmetric(horizontal: 10.0),
    //         child: BlocConsumer<CommentSuggestionCubit, CommentSuggestionState>(
    //             builder: (context, state) {
    //               if (state is CommentSuggestionLoading) {
    //                 return TabProgressIndicator();
    //               }
    //               if (state is CommentSuggestionLoaded) {
    //                 var model = state.model;
    //                 if (model.result == 1) {
    //                   if (model.data != null) {
    //                     var suggestionList = model.data;
    //                     // toast(msg: expensesList.msg.toString());
    //                     return suggestionList!.isNotEmpty?
    //                     Wrap(crossAxisAlignment: WrapCrossAlignment.center,
    //                       runAlignment: WrapAlignment.center,
    //                       alignment: WrapAlignment.center,
    //                       children: suggestionList.map((e) {
    //                         return Padding(
    //                           padding: EdgeInsets.only(right: 10,bottom: 10),
    //                           child: InkWell(
    //                             onTap: (){
    //                               _commentController.text=e.text??"";
    //                               //  _commentController.moveCursorToEnd();
    //                             },
    //                             child: Container(
    //                               decoration: BoxDecoration(
    //                                   border: Border.all(color: AppColor.primary),
    //                                   borderRadius: BorderRadius.circular(15),
    //                                   color: AppColor.white
    //                               ),
    //
    //                               padding: EdgeInsets.symmetric(vertical: 4,
    //                                   horizontal: 15),
    //                               child: Text(e.text??"",style: appTextStyle(
    //                                 fontWeight: FontWeight.w500,
    //                               )),
    //                               // margin: EdgeInsets.only(right: 10,bottom: 10),
    //                             ),
    //                           ),
    //                         );
    //                       }).toList(),
    //                     )
    //                         : SizedBox();
    //                   }
    //                 } return  SizedBox();
    //               }
    //               return const SizedBox();
    //             },
    //             listener: (context, state) {}),
    //       ),
    //       CommonButtons(
    //           buttonText: "Update",
    //           buttonCall: () {
    //             if (_commentController.text.trim().isEmpty) {
    //               toast(msg: "Please enter your comment");
    //               return;
    //             }
    //
    //             if(dropdownvalue == "On" && !_seletedDate){
    //               toast(msg: "Please select date");
    //               return;
    //             }
    //             if(dropdownvalue == "After" && _weekController.text.isEmpty){
    //               toast(msg: "Please enter week value");
    //               return;
    //             }
    //
    //             FocusScope.of(context).requestFocus(FocusNode());
    //             Map<String, String> commentDetails = {};
    //             if (widget.isCaseHistory == true) {
    //               commentDetails['commentId'] = widget.commentId.toString();
    //               commentDetails['caseId'] = widget.getCaseIdd.toString();
    //               commentDetails['comment'] = _commentController.text.trim();
    //               commentDetails['commentDate'] = widget.getDateOfListing!=null
    //                   && widget.getDateOfListing.toString().isNotEmpty
    //                   ? getYYYYMMDD(widget.getDateOfListing.toString())
    //                   : "";
    //               commentDetails['dateOfListing'] = dropdownvalue == "On"
    //                   ? getYYYYMMDDNew(date.toString())
    //                   : "";
    //               commentDetails['weekOfListing'] =
    //                   dropdownvalue == "After" ? _weekController.text : "";
    //               commentDetails['finalDate'] =
    //                   getYYYYMMDDNew(DateTime.now().toString());
    //               commentDetails['dateType'] = dropdownvalue== "On"?"On":
    //               dropdownvalue == "After" ?"After":"";
    //             } else {
    //               commentDetails['commentId'] = widget.commentId.toString();
    //               commentDetails['caseId'] = widget.getCaseIdd.toString();
    //               commentDetails['comment'] = _commentController.text.trim();
    //             }
    //
    //             // var commentDetailsOld = {
    //             //   "caseId": widget.getCaseIdd.toString(),
    //             //   "comment": _commentController.text,
    //             //   "commentId": widget.commentId.toString(),
    //             //   "dateOfListing": "",
    //             //   "weekOfListing": _weekController.text,
    //             // };
    //             BlocProvider.of<UpdateCommentCubit>(context)
    //                 .fetchUpdateComment(commentDetails);
    //           }),
    //     ],
    //   ),
    // ));
  }
}
