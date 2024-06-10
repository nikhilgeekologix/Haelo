import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/drive_share_email_textfield.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:haelo_flutter/features/google_drive/g_drive_handler/gdrive_folder_screen.dart';
import 'package:haelo_flutter/widgets/progress_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '../../../../core/utils/file_pick.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/gallery_camera_dialog.dart';
import '../../../causeslist/cubit/addcase_cubit.dart';
import '../../../google_drive/g_drive_handler/gdrivehandler_function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haelo_flutter/locators.dart' as di;

import '../../cubit/drive_folder_creater_cubit.dart';
import '../../cubit/drive_folder_creater_state.dart';

class CaseDetailsDrivePage extends StatefulWidget {
  String folderId;
  final getUserDetail;
  final getCaseId;

  CaseDetailsDrivePage(this.getUserDetail, this.folderId, this.getCaseId,
      {super.key});

  @override
  State<CaseDetailsDrivePage> createState() => _CaseDetailsDrivePageState();
}

class _CaseDetailsDrivePageState extends State<CaseDetailsDrivePage> {
  bool isLoading = true;
  bool isNoData = false;
  var file1;
  Map<String, dynamic> map = {};
  Map<String, dynamic> driveIdMap = {};

  //
  drive.FileList? fileList;

  late SharedPreferences pref;
  List<drive.File> sharedFilesInFolder = [];
  bool folderExistsOnDrive = false;
  bool clickOnFolderButton = false;
  String folderId = "";
  @override
  void initState() {
    pref = di.locator();
    fetchData();
    print("caseId ==> ${widget.getCaseId}");
    super.initState();
  }

  fetchData() async {
    map = await GoogleDriveHandler().gmailAuthenticate(context);
    if (map["client"] != null) {
      try {
        if (pref.getString(Constants.USER_TYPE) != "2") {
          //for office user 1Kq72QW_SD4cIDxy40pcVqZVyqTU0y1Cg

          folderId = widget.folderId;

          print("inside if");
          print("widget.folderId ${widget.folderId}");
          fileList = await map["driveApi"].files.list(
              pageSize: 1000,
              q: "'${folderId}' in parents and trashed = false");
        } else {
          //for member user
          print("inside else");

          fileList = await map["driveApi"].files.list(
              pageSize: 1000,
              q: "'${folderId}' in parents and trashed = false");
        }
        // q: "sharedWithMe=true");
        print('cfiles ${fileList!.files!.length}');
      } catch (e) {
        // Handle errors
        if (e is drive.DetailedApiRequestError && e.status == 404) {
          // The folder with the given ID is not found
          print("Folder not found.");
        } else {
          print("Error fetching folder data: $e");
        }
      }
      isLoading = false;
      isNoData = false;
      setState(() {});
    } else {
      isLoading = false;
      isNoData = true;
      setState(() {});
    }
    checkFolderAlreadyExistFolderDrive();
  }

  List<drive.File> _getSharedFilesInFolder(
      List<drive.File> sharedFiles, List<drive.File> filesInFolder) {
    if (sharedFiles == null || filesInFolder == null) {
      return []; // Return an empty list if either of the input lists is null
    }

    for (int i = 0; i < sharedFiles.length; i++) {
      print("ok ${sharedFiles[i].parents}");
      print("ok?? ${sharedFiles[i].id}");
    }

    for (int i = 0; i < filesInFolder.length; i++) {
      print("pk ${filesInFolder[i].driveId}");
      print("pk?? ${filesInFolder[i].name}");
    }

    final sharedFilesMap = Map.fromIterable(sharedFiles,
        key: (file) => file.parents.id, value: (file) => file);
    print("sharedFilesMap $sharedFilesMap");
    final sharedFilesInFolder = filesInFolder.where((file) {
      print("file:l ${file.id}");
      print("file// ${sharedFilesMap.containsKey(file.id)}");
      return sharedFilesMap.containsKey(file.id);
    }).toList();
    print("sharedFilesInFolder $sharedFilesInFolder");
    return sharedFilesInFolder;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        body: isLoading
            ? const AppProgressIndicator()
            : fileList != null && fileList!.files!.isNotEmpty
                ? GDriveFolderScreen(
                    fileList: fileList!,
                    googleDriveApiKey: map["gdrive_api_key"],
                    authenticateClient: map["client"],
                    driveApi: map["driveApi"],
                    userName: 'Drive',
                    isAppBar: false,
                    loadingCallback: loadingCallback,
                  )
                : folderExistsOnDrive
                    ? NoDataAvailable("No data found")
                    : Center(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 100,
                                color: AppColor.primary,
                              ),
                              SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: !clickOnFolderButton
                                    ? () async {
                                        setState(() {
                                          clickOnFolderButton = true;
                                        });
                                        await checkFolderAlreadyExistFolderDrive();
                                        if (clickOnFolderButton) {
                                          await createCaseFolderDrive();
                                          fetchData();
                                        }
                                        setState(() {
                                          clickOnFolderButton = false;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                child: Text(
                                  "Create Folder on Google Drive",
                                  style: appTextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    textColor: AppColor.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
        // NoDataAvailable("No data found"),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*  FloatingActionButton(
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
                                is_g_Drive: false,
                                onClickValue: (isGallery) async {
                                  if (isGallery == 4) {
                                    pickFromGdrive(imgCallBack, context);
                                  } else if (isGallery == 3) {
                                    pickDocument(imgCallBack);
                                  } else {
                                    pickImage(isGallery, context, imgCallBack);
                                  }
                                }),
                          ));
                }),*/
            SizedBox(
              height: 10,
            ),
            if (pref.getString(Constants.USER_TYPE) != "2" &&
                fileList != null &&
                fileList!.files!.isNotEmpty)
              FloatingActionButton(
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showDialog(
                      context: context,
                      builder: (ctx) => SafeArea(
                            child: ShareToEmailWidget(shareCallback),
                          ));
                },
                child: Icon(Icons.share_outlined),
                backgroundColor: AppColor.primary.withOpacity(0.8),
              ),
          ],
        ),
      ),
      BlocConsumer<DriveFolderCreatorCubit, DriveFolderCreatorState>(
        builder: (context, state) {
          return const SizedBox();
        },
        listener: (context, state) {
          if (state is DriveFolderCreatorLoading) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is DriveFolderCreatorLoaded) {
            var addCommentList = state.addCommentModel;
            if (addCommentList.result == 1) {
              toast(msg: addCommentList.msg.toString());
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context, true);
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
    ]);
  }

  shareCallback(String emailId) async {
    setState(() {
      isLoading = true;
    });
    map = await GoogleDriveHandler().gmailAuthenticate(context);
    try {
      final permission = drive.Permission()
        ..type = 'user'
        ..role = 'writer'
        ..emailAddress = "$emailId";

      final newPermission = await map["driveApi"].permissions.create(
            permission,
            "${folderId}",
            sendNotificationEmail:
                true, // Set this to true if you want to notify the user via email
          );
      // Fetch the list of permissions for the folder
      final permissionsList = await map["driveApi"].permissions.list(
            folderId,
            // fields: "permissions(emailAddress)",
          );
      print("permissionsList ${permissionsList}");

      bool matched = false;
      final permissions = permissionsList.permissions;
      for (int i = 0; i < permissions.length; i++) {
        print("google:: ${permissions[i].id}");
        if (permissions[i].id == newPermission.id) {
          matched = true;
          break;
        }
      }

      print("newPermission.id:: ${newPermission.id}");

      // List data=[];
      // data.firstWhere((element) => element.id==newPermission.id,
      // orElse: );
      // final sharedUser = permissions.firstWhere((permission) =>
      // permission.id == newPermission.id, orElse: () => null);
      //
      // final sharedUser = permissions.firstWhere((perm) => perm.id == newPermission.id, orElse: () => null);
      // print("sha/redUser ${sharedUser}");

      if (matched) {
        // final userEmail = sharedUser.emailAddress;
        // print("User email address: $userEmail");
        toast(msg: "Permission granted to user");
      } else {
        print("User email address not found.");
        toast(msg: "Failed to grant permission to the user.");
      }
    } catch (e) {
      if (e is drive.DetailedApiRequestError && e.status == 404) {
        // The folder with the given ID is not found
        toast(msg: "Something went wrong");
      } else {
        print("Error fetching folder data: $e");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  loadingCallback(bool load) {
    isLoading = load;
    setState(() {});
  }

  void imgCallBack(XFile xfile, bool isDoc) {
    print("gstFile ");
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
                      "Are you sure to upload this document/image? to google drive",
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
                            Navigator.pop(context);
                            downloadData(file1.path, file1.name);
                            /* File tempFile = File(xfile.path);
                            List<File>? tempFileList = [];
                            tempFileList.add(tempFile);*/
                            /*   var addCaseList = {
                              "caseId": widget.getCaseId.toString(),
                              "localDocPath": file1.path.toString(),
                            };
                            BlocProvider.of<AddCaseCubit>(context)
                                .fetchAddCase(addCaseList, tempFileList);
                            Navigator.pop(context);*/
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

  downloadData(String file, String fileName) async {
    print("file ==> $file");
    print("filePdfName ==> $fileName");
    try {
      await createCaseFolderDrive();

      toast(msg: "Downloading started");
      await GoogleDriveHandler().uploadToDrive(
          map["driveApi"], driveIdMap['sub_folder_id'], file, fileName);

      // All three tasks completed successfully
      toast(msg: "Downloading completed");
      print("All tasks completed successfully!");
    } catch (error) {
      // Handle errors
      print("An error occurred: $error");
    }
  }

  createCaseFolderDrive() async {
    driveIdMap = await GoogleDriveHandler()
        .folderCreate(map["driveApi"], "My Cases",
            "Case_${widget.getUserDetail!.userDetail!.caseNo}_${widget.getUserDetail!.userDetail!.caseYear}_${widget.getUserDetail!.userDetail!.caseType}_${widget.getUserDetail!.userDetail!.caseCategory}")
        .then((value) {
      Map<String, String> commentDetails = {};
      commentDetails['caseId'] = widget.getCaseId.toString();
      commentDetails['drive_path'] = value['sub_folder_id'].toString();
      BlocProvider.of<DriveFolderCreatorCubit>(context)
          .fetchAddComment(commentDetails);
      print("drive_path ${value['sub_folder_id'].toString()}");
      return value;
    });
  }

  checkDriveFolderAlreadyExists() async {
    var haeloQuery =
        "name = 'Case_${widget.getUserDetail!.userDetail!.caseNo}_${widget.getUserDetail!.userDetail!.caseYear}_${widget.getUserDetail!.userDetail!.caseType}_${widget.getUserDetail!.userDetail!.caseCategory}' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
    final haeloResponse = await map["driveApi"].files.list(q: haeloQuery);
    return haeloResponse.files!.isNotEmpty;
  }

  checkFolderAlreadyExistFolderDrive() async {
    // Check if the folder already exists
    bool folderExists = await checkDriveFolderAlreadyExists();
    setState(() {
      folderExistsOnDrive = folderExists;
    });
    if (!folderExistsOnDrive) {
      print("Folder doesn't exist, proceed with creating it");
      print("folderExistsOnDrive $folderExistsOnDrive");
      // Folder doesn't exist, proceed with creating it
      /* driveIdMap = await GoogleDriveHandler()
          .folderCreateWithoutSub(map["driveApi"], "Drive Data", "");*/
    } else {
      print("folderExistsOnDrive $folderExistsOnDrive");
      print("Folder already exists, no need to create it again.");
    }
  }
}
