import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/file_pick.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/casedocuments_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/casedocuments_state.dart';
import 'package:haelo_flutter/features/cases/cubit/docdelete_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/docdelete_state.dart';
import 'package:haelo_flutter/features/cases/presentation/screens/view_doc_widget.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/tab_progress_indicator.dart';
import 'package:haelo_flutter/features/causeslist/cubit/addcase_cubit.dart';
import 'package:haelo_flutter/features/causeslist/cubit/addcase_state.dart';
import 'package:haelo_flutter/features/causeslist/presentation/widget/error_dialog.dart';
import 'package:haelo_flutter/widgets/gallery_camera_dialog.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:share_plus/share_plus.dart';

import '../../../google_drive/g_drive_handler/gdrivehandler_function.dart';
import 'cd_adddetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

class Documents extends StatefulWidget {
  final getCaseId;

  const Documents({Key? key, this.getCaseId}) : super(key: key);

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  String noteOneDocuments =
      "1.) If you are concerned with the Privacy of your case options, you can choose Google Drive option.";
  String noteTwoDocuments =
      "2.) Document's maximum allowed file size is 20 mb.";

  // var valuefirst = 0;
  var file;
  bool refreshDocs = false;
  String localPath = "";

  final ImagePicker imagePicker = ImagePicker();
  List imageFileList = [];

  // void selectImages() async {
  //   final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
  //
  //   if (selectedImages!.isNotEmpty) {
  //     imageFileList!.addAll(selectedImages);
  //     if (imageFileList.length == 5) {}
  //   }
  //   setState(() {});
  // }
  //
  // File? _image;
  //
  // Future getImage() async {
  //   final image = await ImagePicker().pickImage(source: ImageSource.camera);
  //   if (image == null) return;
  //
  //   final imageTemporary = File(image.path);
  //   localPath = image.path;
  //   this._image = imageTemporary;
  //
  //   if (_image != null) {
  //     imageFileList.add(_image);
  //     showDialog(
  //         context: context,
  //         builder: (ctx) {
  //           return AlertDialog(
  //             // insetPadding: EdgeInsets.symmetric(vertical: 305),
  //             contentPadding: EdgeInsets.zero,
  //             content: SizedBox(
  //               // height: mediaQH(context) * 0.16,
  //               // width: mediaQW(context) * 0.8,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Padding(
  //                     padding:
  //                         const EdgeInsets.only(left: 20, right: 20, top: 25),
  //                     child: Text(
  //                       "Are you sure to upload this document/image?",
  //                       textAlign: TextAlign.center,
  //                       style: mpHeadLine14(fontWeight: FontWeight.w600),
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 25,
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: InkWell(
  //                           onTap: () {
  //                             // file = imageFileList[0];
  //                             var addCaseList = {
  //                               "caseId": widget.getCaseId.toString(),
  //                               "localDocPath": localPath,
  //                             };
  //                             BlocProvider.of<AddCaseCubit>(context)
  //                                 .fetchAddCase(addCaseList, imageFileList);
  //                             Navigator.pop(context);
  //                           },
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             height: mediaQH(context) * 0.05,
  //                             decoration: BoxDecoration(
  //                                 borderRadius: const BorderRadius.only(
  //                                     bottomLeft: Radius.circular(5)),
  //                                 border: Border.all(color: AppColor.primary)),
  //                             child: Text(
  //                               "Yes",
  //                               style:
  //                                   mpHeadLine16(textColor: AppColor.primary),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: InkWell(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                           },
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             height: mediaQH(context) * 0.05,
  //                             decoration: const BoxDecoration(
  //                               borderRadius: BorderRadius.only(
  //                                   bottomRight: Radius.circular(5)),
  //                               color: AppColor.primary,
  //                             ),
  //                             child: Text(
  //                               "No",
  //                               style: mpHeadLine16(textColor: AppColor.white),
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         });
  //     if (imageFileList.length == 5) {
  //       setState(() {});
  //     }
  //   }
  //   setState(() {});
  // }
  //
  // File? _imageGallery;
  //
  // Future getGalleryImage() async {
  //   final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (image == null) return;
  //
  //   final imageTemporary = File(image.path);
  //   localPath = image.path;
  //   this._imageGallery = imageTemporary;
  //
  //   if (_imageGallery != null) {
  //     imageFileList.add(_imageGallery);
  //     showDialog(
  //         context: context,
  //         builder: (ctx) {
  //           return AlertDialog(
  //             // insetPadding: EdgeInsets.symmetric(vertical: 305),
  //             contentPadding: EdgeInsets.zero,
  //             content: SizedBox(
  //               // height: mediaQH(context) * 0.16,
  //               // width: mediaQW(context) * 0.8,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Padding(
  //                     padding:
  //                         const EdgeInsets.only(left: 20, right: 20, top: 25),
  //                     child: Text(
  //                       "Are you sure to upload this document/image?",
  //                       textAlign: TextAlign.center,
  //                       style: mpHeadLine14(fontWeight: FontWeight.w600),
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 25,
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: InkWell(
  //                           onTap: () {
  //                             file = imageFileList[0];
  //                             var addCaseList = {
  //                               "caseId": widget.getCaseId.toString(),
  //                               "localDocPath": localPath,
  //                             };
  //                             BlocProvider.of<AddCaseCubit>(context)
  //                                 .fetchAddCase(addCaseList, file);
  //                             Navigator.pop(context);
  //                           },
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             height: mediaQH(context) * 0.05,
  //                             decoration: BoxDecoration(
  //                                 borderRadius: const BorderRadius.only(
  //                                     bottomLeft: Radius.circular(5)),
  //                                 border: Border.all(color: AppColor.primary)),
  //                             child: Text(
  //                               "Yes",
  //                               style:
  //                                   mpHeadLine16(textColor: AppColor.primary),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: InkWell(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                           },
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             height: mediaQH(context) * 0.05,
  //                             decoration: const BoxDecoration(
  //                               borderRadius: BorderRadius.only(
  //                                   bottomRight: Radius.circular(5)),
  //                               color: AppColor.primary,
  //                             ),
  //                             child: Text(
  //                               "No",
  //                               style: mpHeadLine16(textColor: AppColor.white),
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         });
  //     if (imageFileList.length == 5) {
  //       setState(() {});
  //     }
  //   }
  //   setState(() {});
  // }

  Future<bool> checkDoc(imgPath) async {
    var syncPath = await imgPath;
    print(io.File(syncPath).existsSync());
    return await io.File(syncPath).exists();
    // io.File(syncPath).existsSync();
    print(io.File(syncPath).existsSync());
  }

  List selectedList = [];
  bool isLoading = false;

  //for imgs only
  var file1;
  late SharedPreferences pref;

  @override
  void initState() {
    pref = di.locator();
    selectedList = [];
    var caseIdDetails = {
      "caseId": widget.getCaseId.toString(),
    };
    BlocProvider.of<CaseDocumentsCubit>(context)
        .fetchCaseDocuments(caseIdDetails);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    BlocConsumer<AddCaseCubit, AddCaseState>(
                      builder: (context, state) {
                        return const SizedBox();
                      },
                      listener: (context, state) {
                        if (state is AddCaseLoading) {
                          setState(() {
                            isLoading = true;
                          });
                        }
                        if (state is AddCaseLoaded) {
                          var addDocumentList = state.addCaseModel;
                          if (addDocumentList.result == 1) {
                            if (addDocumentList.data != null) {
                              // var addDocumentData = addDocumentList.data;

                              refreshDocs = true;
                              print("calling from addDoclist $refreshDocs");

                              var caseIdDetails = {
                                "caseId": widget.getCaseId.toString(),
                              };
                              BlocProvider.of<CaseDocumentsCubit>(context)
                                  .fetchCaseDocuments(caseIdDetails);
                            }
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            toast(msg: addDocumentList.msg.toString());
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                    BlocConsumer<DocDeleteCubit, DocDeleteState>(
                      builder: (context, state) {
                        if (state is DocDeleteLoaded) {
                          var docDeleteList = state.docDeleteModel;
                          if (docDeleteList.result == 1) {
                            docDeleteList.result = 2;
                            var caseIdDetails = {
                              "caseId": widget.getCaseId.toString(),
                            };
                            BlocProvider.of<CaseDocumentsCubit>(context)
                                .fetchCaseDocuments(caseIdDetails);
                            // var addDocumentData = addDocumentList.data;
                          } else if (docDeleteList.result == 0) {
                            toast(msg: docDeleteList.msg.toString());
                          }
                        }
                        return const SizedBox();
                      },
                      listener: (context, state) {},
                    ),
                    BlocConsumer<CaseDocumentsCubit, CaseDocumentsState>(
                        builder: (context, state) {
                      if (state is CaseDocumentsLoaded) {
                        var caseDocumentsList = state.caseDocumentsModel;
                        if (caseDocumentsList.result == 1) {
                          var caseDocumentsData = caseDocumentsList.data;

                          // for (int i = 0; i < caseDocumentsData!.uploadedDocx!.length; i++) {
                          //   final imageTemporary = File(caseDocumentsData.uploadedDocx![i].documentName.toString());
                          //   imageFileList.add(imageTemporary);
                          // }
                          // if (refreshDocs) {
                          //   Navigator.pop(context);
                          // }
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: caseDocumentsData!.uploadedDocx!.isNotEmpty
                                ? GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        caseDocumentsData!.uploadedDocx!.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .aspectRatio *
                                          15 /
                                          13,
                                    ),
                                    itemBuilder: (context, index) {
                                      String docName = caseDocumentsData
                                          .uploadedDocx![index].documentName
                                          .toString();
                                      var idx = docName.split('/');
                                      print(idx);

                                      var isExistLocally = checkDoc(
                                          caseDocumentsData.uploadedDocx![index]
                                              .localDocPath!);

                                      //
                                      // if (idx != -1) {
                                      //   Console.WriteLine(s.Substring(0, idx)); // "My. name. is Bond"
                                      //   Console.WriteLine(s.Substring(idx + 1)); // "_James Bond!"
                                      // }
                                      return InkWell(
                                        onTap: () {
                                          goToPage(
                                              context,
                                              ViewDocuments(
                                                  caseDocumentsData
                                                      .uploadedDocx!,
                                                  index,
                                                  widget.getCaseId.toString()));
                                        },
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: idx.last
                                                                  .split(".")
                                                                  .last ==
                                                              ("jpg") ||
                                                          idx.last
                                                                  .split(".")
                                                                  .last ==
                                                              ("png")
                                                      ? Image(
                                                          // height: mediaQH(context) * 0.26,
                                                          width:
                                                              mediaQW(context) *
                                                                  0.6,
                                                          image:
                                                              NetworkToFileImage(
                                                            url: caseDocumentsData
                                                                .uploadedDocx![
                                                                    index]
                                                                .documentName
                                                                .toString(),
                                                            // mediaType: 'image',
                                                          ),
                                                        )
                                                      : idx.last
                                                                  .split(".")
                                                                  .last ==
                                                              ("xlsx")
                                                          ? Image.asset(
                                                              ImageConstant
                                                                  .xlsx,
                                                              height: 100,
                                                            )
                                                          : Image.asset(
                                                              ImageConstant.pdf,
                                                              height: 100,
                                                            ),

                                                  // Image.file(
                                                  //   File(imageFileList[index].path),
                                                  //   height: mediaQH(context) * 0.26,
                                                  //   width: mediaQW(context) * 0.6,
                                                  //   fit: BoxFit.fill,
                                                  // ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  idx.last.toString(),
                                                  style: mpHeadLine10(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        var dataMap = {
                                                          "text1": caseDocumentsData
                                                                  .uploadedDocx![
                                                                      index]
                                                                  .documentDetails!
                                                                  .text1 ??
                                                              "",
                                                          "text2": caseDocumentsData
                                                                  .uploadedDocx![
                                                                      index]
                                                                  .documentDetails!
                                                                  .text2 ??
                                                              "",
                                                          "text3": caseDocumentsData
                                                                  .uploadedDocx![
                                                                      index]
                                                                  .documentDetails!
                                                                  .text3 ??
                                                              "",
                                                          "text4": caseDocumentsData
                                                                  .uploadedDocx![
                                                                      index]
                                                                  .documentDetails!
                                                                  .text4 ??
                                                              "",
                                                          "text5": caseDocumentsData
                                                                  .uploadedDocx![
                                                                      index]
                                                                  .documentDetails!
                                                                  .text5 ??
                                                              "",
                                                        };

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AddDetails(
                                                                          getDocId: caseDocumentsData
                                                                              .uploadedDocx![index]
                                                                              .documentId
                                                                              .toString(),
                                                                          dataMap:
                                                                              dataMap,
                                                                        ))).then(
                                                            (value) {
                                                          if (value != null &&
                                                              value) {
                                                            var caseIdDetails =
                                                                {
                                                              "caseId": widget
                                                                  .getCaseId
                                                                  .toString(),
                                                            };
                                                            BlocProvider.of<
                                                                        CaseDocumentsCubit>(
                                                                    context)
                                                                .fetchCaseDocuments(
                                                                    caseIdDetails);
                                                          }
                                                        });
                                                      },
                                                      child: const Icon(
                                                          Icons.edit,
                                                          color: AppColor
                                                              .text_grey_color)),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  pref.getString(Constants
                                                              .USER_TYPE) !=
                                                          "2"
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (ctx) {
                                                                  return AlertDialog(
                                                                    // insetPadding: EdgeInsets.symmetric(vertical: 305),
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    content:
                                                                        SizedBox(
                                                                      height: mediaQH(
                                                                              context) *
                                                                          0.19,
                                                                      // width: mediaQW(context) * 0.8,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 18,
                                                                                right: 18,
                                                                                top: 15),
                                                                            child:
                                                                                Text(
                                                                              "Are you sure, you want to delete ${idx.last.toString()}?",
                                                                              textAlign: TextAlign.center,
                                                                              style: mpHeadLine14(fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                25,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    var addCaseList = {
                                                                                      "docId": caseDocumentsData.uploadedDocx![index].documentId.toString(),
                                                                                    };
                                                                                    BlocProvider.of<DocDeleteCubit>(context).fetchDocDelete(addCaseList);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(
                                                                                    alignment: Alignment.center,
                                                                                    height: mediaQH(context) * 0.05,
                                                                                    decoration: BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5)), border: Border.all(color: AppColor.primary)),
                                                                                    child: Text(
                                                                                      "Yes",
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
                                                                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(5)),
                                                                                      color: AppColor.primary,
                                                                                    ),
                                                                                    child: Text(
                                                                                      "No",
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
                                                                  );
                                                                });
                                                          },
                                                          child: Icon(
                                                              Icons.delete,
                                                              color: Colors.red
                                                                  .shade800))
                                                      : SizedBox(),
                                                  isExistLocally == true
                                                      ? const Icon(
                                                          Icons.download,
                                                          size: 25,
                                                          color: AppColor
                                                              .bold_text_color_dark_blue,
                                                        )
                                                      : Checkbox(
                                                          materialTapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                          shape:
                                                              const CircleBorder(),
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .all(AppColor
                                                                      .primary),
                                                          activeColor:
                                                              AppColor.primary,
                                                          value: selectedList.contains(
                                                              caseDocumentsData
                                                                  .uploadedDocx![
                                                                      index]
                                                                  .documentName!),
                                                          onChanged: (value) {
                                                            checkDoc(caseDocumentsData
                                                                .uploadedDocx![
                                                                    index]
                                                                .localDocPath!);
                                                            // print(
                                                            //     "selectedList ${selectedList.any((element) => element.url == caseDocumentsData.uploadedDocx![index].documentName!)}");
                                                            setState(() {
                                                              if (value!) {
                                                                selectedList.add(
                                                                    caseDocumentsData
                                                                        .uploadedDocx![
                                                                            index]
                                                                        .documentName!);
                                                              } else {
                                                                selectedList.remove(
                                                                    caseDocumentsData
                                                                        .uploadedDocx![
                                                                            index]
                                                                        .documentName!);
                                                                // selectedList
                                                                //     .remove(caseDocumentsData.uploadedDocx![index].documentId!);
                                                              }
                                                              // When we have to select single item we use below line...
                                                              // valuefirst = caseDocumentsData.uploadedDocx![index].documentId!;
                                                            });
                                                          },
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : NoDataAvailable(
                                    "Documents will be shown here."),
                          );
                        }
                        return NoDataAvailable("Documents will be shown here.");
                      }
                      return const SizedBox();
                    }, listener: (context, state) {
                      if (state is CaseDocumentsLoading) {
                        setState(() {
                          isLoading = true;
                        });
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }),
                  ],
                ),
              ),
              Visibility(
                visible: isLoading,
                child: const Center(child: AppProgressIndicator()),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: selectedList.isEmpty
            ? pref.getString(Constants.USER_TYPE) != "2"
                ? FloatingActionButton(
                    // isExtended: true,
                    child: Icon(Icons.add),
                    backgroundColor: AppColor.primary,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showDialog(
                          context: context,
                          builder: (ctx) => SafeArea(
                                child: GalleryCameraDialog(
                                    isDoc: true,
                                    is_g_Drive: true,
                                    onClickValue: (isGallery) async {
                                      if (isGallery == 4) {
                                        pickFromGdrive(imgCallBack, context);
                                      } else if (isGallery == 3) {
                                        pickDocument(imgCallBack);
                                      } else {
                                        pickImage(
                                            isGallery, context, imgCallBack);
                                      }
                                    }),
                              ));
                    })
                : SizedBox()
            : FloatingActionButton(
                // isExtended: true,
                child: Icon(Icons.share),
                backgroundColor: AppColor.primary,
                onPressed: () async {
                  await generatePath().then((value) async {
                    print("hello value $value");
                    if (value.isNotEmpty) {
                      await Share.shareFiles(
                        value,
                        text: "",
                      );
                    }
                  });
                }));
  }

  Future generatePath() async {
    List<String> dirPaths = [];
    for (int i = 0; i < selectedList.length; i++) {
      await shareFilePath(
              selectedList[i], selectedList[i].toString().split("/").last)
          .then((value) async {
        print("value of index $i $value");
        if (value != null && value.isNotEmpty) {
          // File file=File(value);

          final imageFile = await File(value).create(recursive: true);
          imageFile.writeAsBytesSync(imageFile.readAsBytesSync());

          XFile xfile = XFile(imageFile.path);
          dirPaths.add(imageFile.path);
        }
      });
    }
    return dirPaths;
  }

  void imgCallBack(XFile xfile, bool isDoc) {
    print("gstFile");
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            // insetPadding: EdgeInsets.symmetric(vertical: 305),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              // height: mediaQH(context) * 0.16,
              // width: mediaQW(context) * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: Text(
                      "Are you sure to upload this document/image?",
                      textAlign: TextAlign.center,
                      style: mpHeadLine14(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (isDoc) {
                              file1 = xfile;
                            } else {
                              file1 = xfile;
                            }

                            File tempFile = File(xfile.path);
                            List<File>? tempFileList = [];
                            tempFileList.add(tempFile);
                            var addCaseList = {
                              "caseId": widget.getCaseId.toString(),
                              "localDocPath": file1.path.toString(),
                            };
                            BlocProvider.of<AddCaseCubit>(context)
                                .fetchAddCase(addCaseList, tempFileList);
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(5)),
                                border: Border.all(color: AppColor.primary)),
                            child: Text(
                              "Yes",
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
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5)),
                              color: AppColor.primary,
                            ),
                            child: Text(
                              "No",
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
          );
        });

    // print("Filefile1 $file1");
    // setState(() {});
  }
}
