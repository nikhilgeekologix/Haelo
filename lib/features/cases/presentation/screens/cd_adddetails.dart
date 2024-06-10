import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/cubit/adddetails_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/addetails_state.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/widgets/commonButtons.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

class AddDetails extends StatefulWidget {
  final getDocId;
  final dataMap;
  const AddDetails({Key? key, this.getDocId, this.dataMap}) : super(key: key);

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  TextEditingController _textOneController = TextEditingController();
  TextEditingController _textTwoController = TextEditingController();
  TextEditingController _textThreeController = TextEditingController();
  TextEditingController _textFourController = TextEditingController();
  TextEditingController _textFiveController = TextEditingController();

  bool isLoading = false;
  @override
  void initState() {
    _textOneController.text = widget.dataMap["text1"];
    _textTwoController.text = widget.dataMap["text2"];
    _textThreeController.text = widget.dataMap["text3"];
    _textFourController.text = widget.dataMap["text4"];
    _textFiveController.text = widget.dataMap["text5"];
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
          "Add Details",
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
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Stack(
            children: [
              Column(
                children: [
                  BlocConsumer<AddDetailsCubit, AddDetailsState>(
                      builder: (context, state) {
                    return const SizedBox();
                  }, listener: (context, state) {
                    if (state is AddDetailsLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                    if (state is AddDetailsLoaded) {
                      var addDetailsList = state.addDetailsModel;
                      if (addDetailsList.result == 1) {
                        setState(() {
                          isLoading = false;
                        });
                        toast(msg: addDetailsList.msg.toString());
                        Navigator.pop(context, true);
                        /* showDialog(
                            context: context,
                            builder: (ctx) => AppMsgPopup(addDetailsList.msg.toString(),
                              isCloseIcon: false,isError: false,
                              btnCallback: (){
                                Navigator.pop(context);
                                Navigator.pop(context, true);
                              },));*/
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        showDialog(
                            context: context,
                            builder: (ctx) => AppMsgPopup(
                                  addDetailsList.msg.toString(),
                                ));
                      }
                    }
                  }),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _textOneController,
                    cursorColor: AppColor.primary,
                    cursorHeight: 25,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      labelText: "Text 1 (Optional)",
                      disabledBorder: disableboarder,
                      errorBorder: errorboarder,
                      focusedBorder: focusboarder,
                      border: boarder,
                    ),
                    // validator: FormValidation().validatename,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _textTwoController,
                    cursorColor: AppColor.primary,
                    cursorHeight: 25,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      labelText: "Text 2 (Optional)",
                      disabledBorder: disableboarder,
                      errorBorder: errorboarder,
                      focusedBorder: focusboarder,
                      border: boarder,
                    ),
                    // validator: FormValidation().validatename,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _textThreeController,
                    cursorColor: AppColor.primary,
                    cursorHeight: 25,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      labelText: "Text 3 (Optional)",
                      disabledBorder: disableboarder,
                      errorBorder: errorboarder,
                      focusedBorder: focusboarder,
                      border: boarder,
                    ),
                    // validator: FormValidation().validatename,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _textFourController,
                    cursorColor: AppColor.primary,
                    cursorHeight: 25,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      labelText: "Text 4 (Optional)",
                      disabledBorder: disableboarder,
                      errorBorder: errorboarder,
                      focusedBorder: focusboarder,
                      border: boarder,
                    ),
                    // validator: FormValidation().validatename,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _textFiveController,
                    cursorColor: AppColor.primary,
                    cursorHeight: 25,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      labelText: "Text 5 (Optional)",
                      disabledBorder: disableboarder,
                      errorBorder: errorboarder,
                      focusedBorder: focusboarder,
                      border: boarder,
                    ),
                    // validator: FormValidation().validatename,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CommonButtons(
                      buttonText: "Add",
                      buttonCall: () {
                        if (_textOneController.text.isEmpty &&
                            _textTwoController.text.isEmpty &&
                            _textThreeController.text.isEmpty &&
                            _textFourController.text.isEmpty &&
                            _textFiveController.text.isEmpty) {
                          toast(msg: "Please enter any one details");
                          return;
                        }
                        FocusScope.of(context).requestFocus(FocusNode());
                        var caseIdDetails = {
                          "docId": widget.getDocId.toString(),
                          "text1": _textOneController.text,
                          "text2": _textTwoController.text,
                          "text3": _textThreeController.text,
                          "text4": _textFourController.text,
                          "text5": _textFiveController.text,
                        };
                        BlocProvider.of<AddDetailsCubit>(context)
                            .fetchAddDetails(caseIdDetails);
                      },
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isLoading,
                child: const Center(child: AppProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
