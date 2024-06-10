import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/profile_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/profile_state.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/profileupdate_cubit.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/profileupdate_state.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/delete_account.dart';
import 'package:haelo_flutter/locators.dart' as di;
import 'package:haelo_flutter/widgets/error_widget.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/ui_helper.dart';
import '../../../../widgets/commonButtons.dart';
import '../widgets/formvalidations.dart';
import '../widgets/textformfield_decoration.dart';

class ProfileDraw extends StatefulWidget {
  const ProfileDraw({Key? key}) : super(key: key);

  @override
  State<ProfileDraw> createState() => _ProfileDrawState();
}

class _ProfileDrawState extends State<ProfileDraw> {
  final formKeyProfile = GlobalKey<FormState>();
  var profileUpdateData;
  bool isUpdated = false;

  late SharedPreferences pref;

  TextEditingController _firmIdController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _firmNameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode firmNameFocus = FocusNode();
  bool isLoading = true;
  String userType = "";

  @override
  void initState() {
    pref = di.locator();
    userType = pref.getString(Constants.USER_TYPE) ?? "";
    //print("userType $userType");
    BlocProvider.of<ProfileCubit>(context).fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey_color,
      resizeToAvoidBottomInset: false,
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
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: AppColor.white,
        title: Text(
          "Profile",
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
                // color: AppColor.hint_color_grey,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: formKeyProfile,
        child: Stack(
          children: [
            BlocConsumer<ProfileUpdateCubit, ProfileUpdateState>(
                builder: (context, state) {
              return const SizedBox();
            }, listener: (context, state) {
              if (state is ProfileUpdateLoading) {
                setState(() {
                  isLoading = true;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
              }
              if (state is ProfileUpdateLoaded) {
                var profileUpdateList = state.profileUpdateModel;
                if (profileUpdateList.result == 1) {
                  if (isUpdated == true) {
                    isUpdated = false;
                    profileUpdateData = profileUpdateList.data;
                    toast(msg: profileUpdateList.msg.toString());
                    /*   showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(
                              profileUpdateList.msg.toString(),
                              isCloseIcon: false,
                              isError: false,
                              btnCallback: () {
                                // Navigator.pop(context);
                                // Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ));*/

                    BlocProvider.of<ProfileCubit>(context).fetchProfile();
                    // toast(msg: profileUpdateList.msg.toString());
                    // Navigator.pop(context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (ctx) => AppMsgPopup(
                              profileUpdateList.msg.toString(),
                            ));
                  }
                }
              }
            }),
            BlocConsumer<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  var profileList = state.profileModel;
                  if (profileList.result == 1) {
                    if (profileList.data != null) {
                      var profileData = profileList.data;
                      _firmIdController.text =
                          profileData!.userList!.firmId ?? "";
                      _nameController.text =
                          profileData!.userList!.userName ?? "";
                      _firmNameController.text =
                          profileData!.userList!.firmName ?? "";
                      _numberController.text =
                          profileData!.userList!.mobNo ?? "";
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 25),
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    color: AppColor.lyt_stroke_color,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: _firmIdController,
                                      cursorColor: AppColor.primary,
                                      cursorHeight: 25,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        labelText: "Firm-Id",
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black38),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        errorBorder: errorboarder,
                                        focusedBorder: focusboarder,
                                        border: boarder,
                                      ),
                                      // validator: FormValidation().validateFirmId,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: _nameController,
                                    cursorColor: AppColor.primary,
                                    cursorHeight: 25,
                                    focusNode: nameFocus,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      labelText: "Name",
                                      // labelStyle: appTextStyle(
                                      //     textColor: nameFocus.hasFocus?AppColor.primary:AppColor.black
                                      // ),
                                      disabledBorder: disableboarder,
                                      errorBorder: errorboarder,
                                      focusedBorder: focusboarder,
                                      border: boarder,
                                    ),
                                    validator: FormValidation().validatename,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    color: userType == "1"
                                        ? AppColor.grey_color
                                        : AppColor.lyt_stroke_color,
                                    child: TextFormField(
                                      controller: _firmNameController,

                                      cursorHeight: 25,
                                      enabled: userType == "1",
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                        labelText: "Firm Name",
                                        // labelStyle: appTextStyle(
                                        //   textColor: AppColor.primary
                                        // ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black38),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        errorBorder: errorboarder,
                                        focusedBorder: focusboarder,
                                        border: boarder,
                                      ),
                                      // validator:
                                      //     FormValidation().validateFirmname,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    color: AppColor.lyt_stroke_color,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: _numberController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]'))
                                      ],
                                      cursorColor: AppColor.primary,
                                      cursorHeight: 25,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        labelText: "Number",
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black38),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        errorBorder: errorboarder,
                                        focusedBorder: focusboarder,
                                        border: boarder,
                                      ),
                                      // validator: FormValidation().validatephonenumber,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: CommonButtons(
                                      buttonText: "Update",
                                      buttonCall: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        isUpdated = true;
                                        if (formKeyProfile.currentState!
                                            .validate()) {
                                          var updateList = {
                                            "userName": _nameController.text,
                                            "userPic": "",
                                            "firmName":
                                                _firmNameController.text,
                                          };
                                          BlocProvider.of<ProfileUpdateCubit>(
                                                  context)
                                              .fetchProfileUpdate(updateList);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isLoading = false;
                                });
                                showDialog(
                                    context: context,
                                    builder: (ctx) => DeleteAccount(
                                          pref: pref,
                                        ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Delete Account",
                                    style: appTextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        textColor: AppColor.rejected_color_text
                                            .withOpacity(0.8)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: AppColor.rejected_color_text
                                        .withOpacity(0.8),
                                    //Colors.black54,
                                    size: 20,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  } else {
                    toast(msg: profileList.msg.toString());
                  }
                }
                return const SizedBox();
              },
              listener: (context, state) {
                if (state is ProfileLoading) {
                  setState(() {
                    isLoading = true;
                  });
                } else {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            ),
            Visibility(
              visible: isLoading,
              child: const Center(child: AppProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
