import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/cases/cubit/casedetail_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/casedetail_state.dart';
import 'package:haelo_flutter/features/cases/cubit/mobileemailupdate_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/mobileemailupdate_state.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/formvalidations.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/features/task/presentation/screens/dynamic_field.dart';
import 'package:haelo_flutter/widgets/commonButtons.dart';
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';

class EditAddCase extends StatefulWidget {
  final getCaseIdBack;
  final mobileNo;
  final email;
  final itmo;
  const EditAddCase(
      {Key? key, this.getCaseIdBack, this.mobileNo, this.email, this.itmo})
      : super(key: key);

  @override
  State<EditAddCase> createState() => _EditAddCaseState();
}

class _EditAddCaseState extends State<EditAddCase> {
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _itmoController = TextEditingController();

  final formKeyEditAddCase = GlobalKey<FormState>();

  bool isLoading = false;

  List<TextEditingController> mobTextControllers = [];
  List<TextEditingController> emailTextControllers = [];

  @override
  void initState() {
    //for mobile only
    if (widget.mobileNo != null && widget.mobileNo.toString().isNotEmpty) {
      List datalist = widget.mobileNo.toString().split(",");
      for (int i = 1; i < datalist.length; i++) {
        mobTextControllers.add(TextEditingController(text: datalist[i]));
      }
      _mobileController.text = datalist[0];
      print("datalist ${datalist}");
    }

    // for email only
    if (widget.email != null && widget.email.toString().isNotEmpty) {
      List emailList = widget.email.toString().split(",");
      for (int i = 1; i < emailList.length; i++) {
        emailTextControllers.add(TextEditingController(text: emailList[i]));
      }
      _emailController.text = emailList[0];
    }
    _itmoController.text = widget.itmo;
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
          "Add Case",
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
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocConsumer<MobileEmailUpdateCubit,
                        MobileEmailUpdateState>(builder: (context, state) {
                      return const SizedBox();
                    }, listener: (context, state) {
                      if (state is MobileEmailUpdateLoading) {
                        setState(() {
                          isLoading = true;
                        });
                      }
                      if (state is MobileEmailUpdateLoaded) {
                        var mobileEmailItmoUpdate =
                            state.mobileEmailUpdateModel;
                        if (mobileEmailItmoUpdate.result == 1) {
                          // var caseIdDetails = {
                          //   "caseId": widget.getCaseIdBack.toString(),
                          // };
                          // BlocProvider.of<CaseDetailCubit>(context).fetchCaseDetail(caseIdDetails);
                          setState(() {
                            isLoading = false;
                          });
                          toast(msg: mobileEmailItmoUpdate.msg.toString());
                          Navigator.pop(context, true);
                          /*    showDialog(
                              context: context,
                              builder: (ctx) => AppMsgPopup(mobileEmailItmoUpdate.msg.toString(),
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
                                    mobileEmailItmoUpdate.msg.toString(),
                                  ));
                        }
                      }
                    }),
                    BlocConsumer<CaseDetailCubit, CaseDetailState>(
                        builder: (context, state) {
                          return const SizedBox();
                        },
                        listener: (context, state) {}),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: TextFormField(
                        controller: _itmoController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: "ITMO",
                          labelStyle: const TextStyle(color: Colors.black38),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          disabledBorder: disableboarder,
                          errorBorder: errorboarder,
                          focusedBorder: focusboarder,
                          border: boarder,
                        ),
                        validator: FormValidation().validateitmo,
                      ),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    DynamicFields(
                        mobileEmailController: _mobileController,
                        isMobile: true,
                        textControllers: mobTextControllers),
                    const SizedBox(
                      height: 5,
                    ),
                    DynamicFields(
                        mobileEmailController: _emailController,
                        textControllers: emailTextControllers),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CommonButtons(
                        buttonText: "Update",
                        buttonCall: () {
                          // print("mobile text ${_mobileController.text}");
                          // print("mobile 22 ${mobTextControllers}");

                          if (_itmoController.text.isEmpty) {
                            toast(msg: "Please enter ITMO.");
                            return;
                          }

                          if (_mobileController.text.isNotEmpty &&
                              _mobileController.text.length < 10) {
                            toast(msg: "Please enter correct number.");
                            return;
                          }

                          if (mobTextControllers.isNotEmpty) {
                            for (var element in mobTextControllers) {
                              if (element.text.isNotEmpty &&
                                  element.text.length < 10) {
                                toast(msg: "Please enter correct number.");
                                return;
                              }
                            }
                          }

                          if (_emailController.text.isNotEmpty &&
                              !isEmailValid(_emailController.text)) {
                            toast(msg: "Please enter correct email.");
                            return;
                          }

                          if (emailTextControllers.isNotEmpty) {
                            for (var element in emailTextControllers) {
                              if (element.text.isNotEmpty &&
                                  !isEmailValid(element.text)) {
                                toast(msg: "Please enter correct email.");
                                return;
                              }
                            }
                          }

                          String mobs = _mobileController.text;
                          for (int i = 0; i < mobTextControllers.length; i++) {
                            if (mobTextControllers[i].text.isNotEmpty) {
                              mobs = "${mobs},${mobTextControllers[i].text}";
                            }
                          }
                          String emails = _emailController.text;

                          for (int i = 0;
                              i < emailTextControllers.length;
                              i++) {
                            if (emailTextControllers[i].text.isNotEmpty) {
                              emails =
                                  "${emails},${emailTextControllers[i].text}";
                            }
                          }

                          FocusScope.of(context).requestFocus(FocusNode());
                          var updatedList = {
                            "caseId": widget.getCaseIdBack.toString(),
                            "email": emails,
                            "mobNo": mobs,
                            "itmo": _itmoController.text,
                          };
                          print("updatedList ${updatedList}");

                          BlocProvider.of<MobileEmailUpdateCubit>(context)
                              .fetchMobileEmailUpdate(updatedList);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const Center(child: AppProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
