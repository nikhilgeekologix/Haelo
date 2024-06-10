import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:googleapis/drive/v3.dart';
import 'package:haelo_flutter/features/cases/presentation/widgets/no_data_widget.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/utils/ui_helper.dart';
import '../../cases/presentation/widgets/drive_file_option.dart';
import '../drive_file_card.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import '../pdf_viewer.dart';

class GDriveFolderScreen extends StatefulWidget {
  GDriveFolderScreen(
      {super.key,
      required this.fileList,
      required this.googleDriveApiKey,
      required this.authenticateClient,
      required this.userName,
      required this.driveApi,
      this.isAppBar = true,
      this.loadingCallback});

  FileList fileList;
  String userName;
  String googleDriveApiKey;
  var authenticateClient;
  var driveApi;
  bool isAppBar;
  final loadingCallback;

  @override
  State<GDriveFolderScreen> createState() => _GDriveFolderScreenState();
}

class _GDriveFolderScreenState extends State<GDriveFolderScreen> {
  //On every search input this function gets called, and the search value (searchVal gets updated).
  onSearchFieldChange(String val) {
    setState(() {
      searchVal = val;
    });
    // If the input value is null, set searchVal to null.
    // When the searchVal is set as null the listWill show all the elements.
    if (val.isEmpty) {
      setState(() {
        searchVal = null;
      });
    }
  }

  // Keeps a track of the search toogle.
  bool showSearchTextForm = false;

  // This is the search value based on which the search results are shown,
  String? searchVal;

  // This is the search text editing controller.
  // We wont be using this controller.
  TextEditingController searchController = TextEditingController();

  // Keeps a track on whether the UI is loading or not
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isAppBar
          ? AppBar(
              elevation: 3,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: Colors.black,
                ),
              ),

              // Title widget changes base on whether user toggles search on not.
              title: showSearchTextForm
                  ?
                  // when search has been toggled this title Widget will be shown.
                  // This is the text input field where users will input their search term
                  TextFormField(
                      controller: searchController,
                      // textAlignVertical: TextAlignVertical.center,
                      onChanged: (String value) {
                        onSearchFieldChange(value);
                      },
                      style: TextStyle(
                        // fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                      ),
                    )
                  :
                  //Default title widget
                  Text(
                      "Google Drive",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      showSearchTextForm = !showSearchTextForm;
                      searchVal = null;
                    });
                  },
                  icon: Icon(
                    showSearchTextForm ? Icons.close : Icons.search,
                    size: 18,
                    color: Colors.black,
                  ),
                )
              ],
            )
          : null,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Default top padding
                  const SizedBox(
                    height: 10,
                  ),
                  widget.fileList.files!.isNotEmpty
                      ? Wrap(
                          children: widget.fileList.files!.toList().map((e) {
                            int index =
                                widget.fileList.files!.toList().indexOf(e);
                            File file = widget.fileList.files!.toList()[index];
                            //  print("mymetype $index ${file.mimeType!} and name ${file.name}");

                            if (searchVal == null) {
                              // If searchVal is null, show all files and folders.
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: GestureDetector(
                                    onTap: () async {
                                      if (file.mimeType!.contains(".folder")) {
                                        openFolder(e.id!, context);
                                      } else {
                                        print("clicked file ${file.id}");
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => SafeArea(
                                                  child: DriveFileOption(
                                                      fileOptionCallback, file),
                                                ));
                                        // await _onItemTap(file,
                                        //     widget.authenticateClient, context);
                                      }
                                    },
                                    child:
                                        DriveFileCard(index, widget.fileList)),
                              );
                            } else {
                              // if the searchVal is not null return only the files that contains the searchVal in their name
                              if (file.name!
                                  .toLowerCase()
                                  .contains(searchVal!.toLowerCase())) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: GestureDetector(
                                      onTap: () async {
                                        if (file.mimeType!
                                            .contains(".folder")) {
                                          openFolder(e.id!, context);
                                        } else {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => SafeArea(
                                                    child: DriveFileOption(
                                                        fileOptionCallback,
                                                        file),
                                                  ));
                                          // await _onItemTap(
                                          //     file,
                                          //     widget.authenticateClient,
                                          //     context);
                                        }
                                      },
                                      child: DriveFileCard(
                                          index, widget.fileList)),
                                );
                              } else {
                                // Ignore if the file name does not contain the searchVal term.
                                return const SizedBox.shrink();
                              }
                            }
                          }).toList(),
                        )
                      : NoDataAvailable("No data found"),
                ],
              ),
            ),
          ),
          // If is loading show, circular progress indicator.
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightBlue,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Future<void> _onItemTap(
      File file, var authenticateClient, context, int type) async {
    // setState(() {
    //   isLoading = true;
    // });
    widget.loadingCallback(true);
    String fileName = file.name!;
    String fileId = file.id!;
    String fileMimeType = file.mimeType!;

    http.Response? response;

    if (fileMimeType.contains("spreadsheet") && !fileName.contains(".xlsx")) {
      //If the file is a google doc file, export the file as instructed by the google team.
      String url =
          "https://www.googleapis.com/drive/v3/files/${file.id}/export?mimeType=application/vnd.openxmlformats-officedocument.spreadsheetml.sheet&key=${widget.googleDriveApiKey} HTTP/1.1";

      response = await authenticateClient.get(
        Uri.parse(url),
      );
    } else if (!fileMimeType.contains(".folder")) {
      // If the file is uploaded from somewhere else or if the file is not a google doc file process it with the "Files: Get" process.
      String url =
          "https://www.googleapis.com/drive/v3/files/$fileId?includeLabels=alt%3Dmedia&alt=media&key=${widget.googleDriveApiKey} HTTP/1.1";

      response = await authenticateClient.get(
        Uri.parse(url),
      );
    }

    if (response != null) {
      // Get temporary application document directory
      final dir = await getApplicationDocumentsDirectory();
      // Create custom path, where the downloaded file will be saved. TEMPORARILY
      String path = "${dir.path}/${file.name}";
      print("path $path");
      io.File myFile = await io.File(path).writeAsBytes(response.bodyBytes);
      if (type == 2) {
        // 2 : open
        widget.loadingCallback(false);
        OpenFile.open(myFile.path);
      } else {
        await Share.shareFiles(
          [myFile.path],
          text: "",
        );
      }

      // Save the file

      // Navigator.pop(
      //   context,
      //   myFile,
      // );
    }
    // setState(() {
    //   isLoading = false;
    // });
    widget.loadingCallback(false);
  }

  Future openFolder(String folderId, context) async {
    print("folderId $folderId");
    drive.FileList fileList = await widget.driveApi.files
        .list(pageSize: 1000, q: "'$folderId' in parents and trashed = false");
    print('cfiles ${fileList.files!.length}');
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GDriveFolderScreen(
          fileList: fileList,
          googleDriveApiKey: widget.googleDriveApiKey.toString(),
          authenticateClient: widget.authenticateClient,
          userName: "Rahul",
          driveApi: widget.driveApi,
        ),
      ),
    );

    //
    // drive.FileList fileList = await widget.driveApi.files.list(
    //     pageSize: 1000,
    //     q: "'1kw5FLqDBarA2iVyklZNQQ9HXz98w-GKb' in parents");
  }

  Future<void> fileOptionCallback(int type, file) async {
    await _onItemTap(file, widget.authenticateClient, context, type);
  }
}
