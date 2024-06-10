import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/cubit/addcomment_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/addcomment_state.dart';
import 'package:haelo_flutter/features/cases/cubit/cmt_suggestion/cmt_suggestion_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/cmt_suggestion/cmt_suggestion_state.dart';
import 'package:haelo_flutter/features/cases/cubit/comments_cubit.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/tab_progress_indicator.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/widgets/commonButtons.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

class AddComment extends StatefulWidget {
  final getCaseIdd;
  final bool isCaseHistory;
  final getDateOfListing;
  final getCommentDate;

  const AddComment(
      {Key? key,
      this.getCaseIdd,
      this.isCaseHistory = false,
      this.getDateOfListing,
      this.getCommentDate})
      : super(key: key);

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  bool _seletedDate = false;
  DateTime? date;

  String dropdownvalue = 'Not Set';
  var items = ['Not Set', 'On', 'After'];

  TextEditingController _commentController = TextEditingController();
  TextEditingController _weekController = TextEditingController();
  bool isLoading = false;

  List<String> predifineCmts = [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten"
  ];
  FocusNode commentFocus = FocusNode();

  @override
  void initState() {
    Map<String, String> body = {};
    BlocProvider.of<CommentSuggestionCubit>(context)
        .fetchCommentSuggestion(body);
    print("getCaseIdd ${widget.getCaseIdd}");
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
            "Add Comment",
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      BlocConsumer<AddCommentCubit, AddCommentState>(
                        builder: (context, state) {
                          return const SizedBox();
                        },
                        listener: (context, state) {
                          if (state is AddCommentLoading) {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          if (state is AddCommentLoaded) {
                            var addCommentList = state.addCommentModel;
                            if (addCommentList.result == 1) {
                              setState(() {
                                isLoading = false;
                              });
                              print("comment added");
                              Navigator.pop(context, true);
                              toast(msg: addCommentList.msg.toString());
                              /*  showDialog(
                                  context: context,
                                  builder: (ctx) => AppMsgPopup(
                                        addCommentList.msg.toString(),
                                        isCloseIcon: false,
                                        isError: false,
                                        btnCallback: () {
                                          Navigator.pop(context);

                                        },
                                      ));*/
                              // var caseIdDetails = {
                              //   "caseId": widget.getCaseIdd.toString(),
                              // };
                              // BlocProvider.of<CasesCommentCubit>(context)
                              //     .fetchCasesComment(caseIdDetails);
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
                                focusNode: commentFocus,
                                cursorHeight: 25,
                                maxLines: 40,
                                minLines: 10,
                                decoration: InputDecoration(
                                  hintText: "Enter your comment",
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
                                                print(
                                                    "dropdownvalue $dropdownvalue");
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
                                              DateTime? newDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      colorScheme:
                                                          ColorScheme.light(
                                                        primary:
                                                            AppColor.primary,
                                                        // <-- SEE HERE
                                                        onPrimary: Colors.white,
                                                        // <-- SEE HERE
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
                                                child: date != null
                                                    ? Text(
                                                        "${date!.day.toString().length > 1 ? date!.day : "0${date!.day}"}/${date!.month.toString().length > 1 ? date!.month : "0${date!.month}"}/${date!.year}",
                                                        style: mpHeadLine16(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    : Text(
                                                        "Example: 25.05.2022",
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
                                                            print(
                                                                "_commentController ==>${_commentController.text}");
                                                            if (_commentController
                                                                .text
                                                                .isNotEmpty) {
                                                              _commentController
                                                                      .text =
                                                                  "${_commentController.text} ${e.text} ";
                                                            } else {
                                                              _commentController
                                                                      .text =
                                                                  "${e.text} ${_commentController.text}";
                                                            }
                                                            print(
                                                                "_commentController e.text ==>${_commentController.text}");
                                                            _commentController
                                                                    .selection =
                                                                TextSelection.collapsed(
                                                                    offset: _commentController
                                                                        .text
                                                                        .length);
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
                              height: 60,
                            ),
                          ],
                        ),
                      ),
                    ],
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /*Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child:
                  BlocConsumer<CommentSuggestionCubit, CommentSuggestionState>(
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
                                          WrapCrossAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: suggestionList.map((e) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right: 10, bottom: 10),
                                          child: InkWell(
                                            onTap: () {
                                              _commentController.text =
                                                  e.text ?? "";
                                              _commentController.selection =
                                                  TextSelection.collapsed(
                                                      offset: _commentController
                                                          .text.length);
                                              //  _commentController.moveCursorToEnd();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColor.primary),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: AppColor.white),

                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 15),
                                              child: Text(e.text ?? "",
                                                  style: appTextStyle(
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
                          }
                          return SizedBox();
                        }
                        return const SizedBox();
                      },
                      listener: (context, state) {}),
            ),*/
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: CommonButtons(
                  buttonText: "Add Comment",
                  buttonCall: () {
                    print("date ${widget.getDateOfListing.toString()}");
                    if (_commentController.text.isEmpty) {
                      toast(msg: "Please enter your comment");
                      return;
                    }

                    FocusScope.of(context).requestFocus(FocusNode());
                    if (dropdownvalue == "On" && date == null) {
                      toast(msg: "Please select date");
                      return;
                    }
                    if (dropdownvalue == "After" &&
                        _weekController.text.isEmpty) {
                      toast(msg: "Please enter week value");
                      return;
                    }

                    Map<String, String> commentDetails = {};
                    if (widget.isCaseHistory == true) {
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
                      commentDetails['caseId'] = widget.getCaseIdd.toString();
                      commentDetails['comment'] =
                          _commentController.text.trim();
                      // commentDetails['commentDate']=widget.isCaseHistory == true ? getYYYYMMDDNew(DateTime.now().toString()) : "";
                      // commentDetails['dateOfListing']=widget.isCaseHistory == true ? getYYYYMMDD(widget.getDateOfListing.toString()) : "";
                      // commentDetails['weekOfListing']= dropdownvalue == "After"?_weekController.text:"";
                    }
                    print("commentDetails $commentDetails");

                    BlocProvider.of<AddCommentCubit>(context)
                        .fetchAddComment(commentDetails);
                  }),
            ),
          ],
        ));
  }
}
