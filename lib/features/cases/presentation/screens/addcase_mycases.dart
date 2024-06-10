import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/file_pick.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/casetype_dialog.dart';
import 'package:haelo_flutter/features/causeslist/cubit/addcase_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/addcase_state.dart';
import 'package:haelo_flutter/features/causeslist/cubit/addcasetype_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/addcasetype_state.dart';
import 'package:haelo_flutter/features/causeslist/cubit/createcase_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/createcase_state.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/addcase_textfield.dart';
import 'package:haelo_flutter/features/google_drive/g_drive_handler/gdrivehandler_function.dart';
import 'package:haelo_flutter/features/task/presentation/screens/dynamic_field.dart';
import 'package:haelo_flutter/widgets/commonButtons.dart';
import 'package:haelo_flutter/widgets/gallery_camera_dialog.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:haelo_flutter/widgets/year_picker.dart';
import 'package:image_picker/image_picker.dart';

class AddCaseMyCases extends StatefulWidget {
  const AddCaseMyCases({
    Key? key,
  }) : super(key: key);

  @override
  State<AddCaseMyCases> createState() => _AddCaseMyCasesState();
}

class _AddCaseMyCasesState extends State<AddCaseMyCases> {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _caseTypeController = TextEditingController();
  TextEditingController _caseYearController = TextEditingController();
  TextEditingController _caseFillingNoController = TextEditingController();
  TextEditingController _caseNumberController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  List<TextEditingController> mobTextControllers = [];
  List<TextEditingController> emailTextControllers = [];

  var itemsCategory = ['Civil', 'Criminal', 'Writ'];
  var categoryId;
  var _caseId;

  bool dottedBox = true;
  var file;
  bool isLoading = true;
  String noteOneDocuments =
      "1.) If you are concerned with the Privacy of your case options, you can choose Google Drive option.";
  String noteTwoDocuments = "2.) Document's maximum allowed file size is 5 mb.";

  DateTime dateFrom = DateTime.now();
  bool _seletedDate = false;
  Map<String, dynamic> authMap = {};
  Map<String, dynamic> driveIdMap = {};
  bool isEnabled = false;

  @override
  void initState() {
    // pref = di.locator();
    BlocProvider.of<AddCaseTypeCubit>(context).fetchAddCaseType();
    gmailAuthenticate();

    // var createCaseList = {
    //   // "caseNo": widget.getCaseNum.toString(),
    // };
    // BlocProvider.of<CauseListCreateCaseCubit>(context).fetchCauseListCreateCase(createCaseList);
    super.initState();
    // _categoryController.text = itemsCategory[].toString();
  }

  final ImagePicker imagePicker = ImagePicker();
  List imageFileList = [];

  gmailAuthenticate() async {
    authMap = await GoogleDriveHandler().gmailAuthenticate(context);
  }

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
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                content: Container(
                                  width: double.maxFinite,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                        ),
                                        child: ListView.builder(
                                          itemCount: 3,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _categoryController.text =
                                                          itemsCategory[index]
                                                              .toString();
                                                      categoryId = (index + 1)
                                                          .toString();
                                                      print(
                                                          "categoryId---------$categoryId");
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      itemsCategory[index]
                                                          .toString(),
                                                    ),
                                                  ),
                                                  index != 2
                                                      ? Divider(
                                                          color:
                                                              Colors.grey[300],
                                                          thickness: 1.5,
                                                        )
                                                      : SizedBox()
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                actions: [],
                              );
                            },
                          );
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: AddCaseField(
                              addCaseController: _categoryController,
                              addCaseLabel: "Category",
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocConsumer<AddCaseTypeCubit, AddCaseTypeState>(
                          builder: (context, state) {
                        if (state is AddCaseTypeLoaded) {
                          var causeListAddCaseType = state.addCaseTypeModel;
                          if (causeListAddCaseType.result == 1) {
                            if (causeListAddCaseType.data != null) {
                              var addCaseTypeData = causeListAddCaseType.data;
                              return InkWell(
                                onTap: () {
                                  List caseTypeList = _categoryController
                                              .text ==
                                          "Civil"
                                      ? addCaseTypeData!.civil!
                                      : _categoryController.text == "Criminal"
                                          ? addCaseTypeData!.criminal!
                                          : addCaseTypeData!.writ!;

                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (caseTypeList.isNotEmpty) {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => CaseTypeDialog(
                                            caseTypeList,
                                            _categoryController.text == "Civil"
                                                ? 1
                                                : _categoryController.text ==
                                                        "Criminal"
                                                    ? 2
                                                    : 3,
                                            setValueData));
                                  }
                                },
                                child: AddCaseField(
                                  addCaseController: _caseTypeController,
                                  addCaseLabel: "Case Type",
                                ),
                                // child: CustomContainer(
                                //   displayData: _caseTypeController.text.isNotEmpty
                                //       ? _caseTypeController.text
                                //       : "Case Type",
                                // ),
                              );
                            }
                          } else {
                            toast(msg: causeListAddCaseType.msg.toString());
                          }
                        }
                        return const SizedBox();
                      }, listener: (context, state) {
                        if (state is AddCaseTypeLoading) {
                          setState(() {
                            isLoading = true;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocConsumer<CauseListCreateCaseCubit,
                          CauseListCreateCaseState>(builder: (context, state) {
                        return const SizedBox();
                      }, listener: (context, state) {
                        if (state is CauseListCreateCaseLoaded) {
                          var createCaseModel = state.causeListCreateCaseModel;
                          if (createCaseModel.result == 1) {
                            if (createCaseModel.data != null) {
                              _caseNumberController.text = createCaseModel
                                  .data.dataCase.caseNo
                                  .toString();
                              _caseYearController.text = createCaseModel
                                  .data.dataCase.caseYear
                                  .toString();
                            }
                          } else {
                            toast(msg: createCaseModel.msg.toString());
                          }
                        }
                      }),
                      AddCaseField(
                        addCaseController: _caseNumberController,
                        addCaseLabel: "Case Number",
                        isCaseNo: true,
                        isNumaric: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AppYearPicker(
                                    callback: setYear,
                                    lastSelectedYear: _caseYearController.text,
                                  ));
                          //flutterYearPicker(context);
                        },
                        child: AddCaseField(
                          addCaseController: _caseYearController,
                          addCaseLabel: "Case Year",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AddCaseField(
                        addCaseController: _caseFillingNoController,
                        addCaseLabel: "Filling No.(Optional)",
                        isCaseNo: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DynamicFields(
                          mobileEmailController: _mobileController,
                          isMobile: true,
                          textControllers: mobTextControllers),
                      const SizedBox(
                        height: 12,
                      ),
                      DynamicFields(
                          mobileEmailController: _emailController,
                          textControllers: emailTextControllers),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Add documents.Maximum allowed file size is 5 mb.",
                        style:
                            mpHeadLine12(textColor: AppColor.hint_color_grey),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                height: mediaQH(context) * 0.090,
                                // width: mediaQW(context) * 0.5,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageFileList.length,
                                  itemBuilder: (context, index) {
                                    print("${imageFileList[index]}");
                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, top: 8),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: imageFileList![index]
                                                        .path
                                                        .contains("png") ||
                                                    imageFileList![index]
                                                        .path
                                                        .contains("jpg")
                                                ? Image.file(
                                                    File(imageFileList![index]
                                                        .path),
                                                    // height: 650,
                                                    width: 60,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                    child: Icon(
                                                      Icons.image,
                                                      size: 35,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Positioned(
                                            right: 5,
                                            top: 1,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                            )),
                                        Positioned(
                                            right: 5,
                                            top: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  imageFileList.removeAt(index);
                                                  if (imageFileList.isEmpty) {
                                                    dottedBox = true;
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.cancel,
                                                color: Colors.red.shade800,
                                              ),
                                            )),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              // selectImages();
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => SafeArea(
                                            child: GalleryCameraDialog(
                                                isDoc: true,
                                                is_g_Drive: true,
                                                onClickValue: (isGallery) {
                                                  if (isGallery == 4) {
                                                    pickFromGdrive(
                                                        imgCallBack, context);
                                                  } else if (isGallery == 3) {
                                                    pickDocument(imgCallBack);
                                                  } else {
                                                    pickImage(isGallery,
                                                        context, imgCallBack);
                                                  }
                                                }),
                                          ));
                                },
                                child: Visibility(
                                  visible: dottedBox,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(6),
                                    dashPattern: [10, 10],
                                    color: Colors.grey,
                                    strokeWidth: 2,
                                    child: Container(
                                      height: 65,
                                      width: 65,
                                      child: const Icon(
                                        Icons.add,
                                        color: AppColor.hint_color_grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        child: SwitchListTile(
                          activeColor: Colors.red,
                          title: Text(
                            'Case only for you',
                            style: mpHeadLine12(
                                textColor: AppColor.hint_color_grey),
                          ),
                          value: isEnabled,
                          onChanged: (bool? value) {
                            setState(() {
                              isEnabled = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      BlocConsumer<AddCaseCubit, AddCaseState>(
                          builder: (context, state) {
                        return const SizedBox();
                      }, listener: (context, state) {
                        if (state is AddCaseLoading) {
                          setState(() {
                            isLoading = true;
                          });
                        }
                        if (state is AddCaseLoaded) {
                          var addCauseListCaseModel = state.addCaseModel;
                          if (addCauseListCaseModel.result == 1) {
                            if (addCauseListCaseModel.data != null) {
                              createCaseFolderDrive();
                              setState(() {
                                isLoading = false;
                              });
                              toast(msg: addCauseListCaseModel.msg.toString());
                              Navigator.pop(context, true);
                              /*  showDialog(
                                  context: context,
                                  builder: (ctx) => AppMsgPopup(
                                        addCauseListCaseModel.msg.toString(),
                                        isCloseIcon: false,
                                        isError: false,
                                        btnCallback: () {
                                          Navigator.pop(context);

                                        },
                                      ));*/
                              //Navigator.pop(context, addCauseListCaseModel.data!.caseId.toString());
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCauseList()));
                            }
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      }),
                      CommonButtons(
                          buttonText: "Add Case",
                          buttonCall: () async {
                            if (_categoryController.text.isEmpty) {
                              toast(msg: "Please select case category.");
                              return;
                            }
                            if (_caseTypeController.text.isEmpty) {
                              toast(msg: "Please select case type.");
                              return;
                            }
                            if (_caseNumberController.text.isEmpty) {
                              toast(msg: "Please enter case number.");
                              return;
                            }
                            if (_caseYearController.text.isEmpty) {
                              toast(msg: "Please select case year.");
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

                            // if (imageFileList.isNotEmpty) {
                            //   file = imageFileList[0];
                            // }

                            String mobNos = _mobileController.text;
                            // print("other mob lenght ${mobTextControllers.length}");
                            for (int i = 0;
                                i < mobTextControllers.length;
                                i++) {
                              if (mobTextControllers[i].text.isNotEmpty) {
                                mobNos =
                                    "${mobNos},${mobTextControllers[i].text}";
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

                            List<File>? imageFileList1 = [];
                            for (int i = 0; i < imageFileList.length; i++) {
                              File file =
                                  File(imageFileList[i].path.toString());
                              imageFileList1.add(file);
                            }
                            driveIdMap = await GoogleDriveHandler()
                                .folderCreate(authMap["driveApi"], "My Cases",
                                    "Case_${_caseNumberController.text}_${_caseYearController.text}_${_caseTypeController.text}_${_categoryController.text}")
                                .then((value) {
                              var addCaseList = {
                                "caseName": "",
                                "caseNo": _caseNumberController.text,
                                "caseYear": _caseYearController.text,
                                "caseType": _caseTypeController.text,
                                "caseCat": _categoryController.text,
                                "mobNo": mobNos,
                                "email": emails,
                                "filingNo": _caseFillingNoController.text,
                                "filingYear": "",
                                "seniorCounsel": "",
                                "interimStay": "",
                                "is_privet": isEnabled.toString(),
                                "drive_path": value['sub_folder_id'].toString(),
                              };
                              BlocProvider.of<AddCaseCubit>(context)
                                  .fetchAddCase(addCaseList, imageFileList1);
                              return value;
                            });

                            print("drive ids map $driveIdMap");
                          }),
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
      ),
    );
  }

  Future flutterYearPicker(BuildContext context) async {
    int currentYear = DateTime.now().year;
    return showDialog(
      context: context,
      builder: (context) {
        // final Size size = MediaQuery.of(context).size;
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: Column(
            children: [
              Container(
                  width: mediaQW(context),
                  decoration: BoxDecoration(color: AppColor.primary),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '$currentYear',
                    style: appTextStyle(
                        fontSize: 20,
                        textColor: AppColor.white,
                        fontWeight: FontWeight.w600),
                  )),
            ],
          ),
          // contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            height: mediaQH(context) / 4,
            width: mediaQW(context),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                    123,
                    (index) => InkWell(
                      onTap: () {
                        print(
                            "Selected Year ==> ${(DateTime.now().year - index).toString()}");
                        _caseYearController.text =
                            (DateTime.now().year - index).toString();
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              (DateTime.now().year - index).toString(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void setValueData(selectedValue) {
    setState(() {
      _caseTypeController.text = selectedValue;
    });
  }

  void setYear(selectedValue) {
    setState(() {
      _caseYearController.text = selectedValue;
    });
  }

  void imgCallBack(XFile xfile, bool isDoc) {
    print("gstFile");
    File file = File(xfile.path);
    imageFileList!.add(file);

    if (imageFileList!.length >= 5) {
      dottedBox = false;
    }
    setState(() {});
  }

  void createCaseFolderDrive() async {
    for (int i = 0; i < imageFileList.length; i++) {
      print("upload for index $i");
      File file = File(imageFileList[i].path.toString());
      await GoogleDriveHandler().fileUploadToDrive(
          authMap["driveApi"], driveIdMap['sub_folder_id'], file);
    }
  }
}
