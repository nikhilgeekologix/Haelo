import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_sign_in;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/google_drive/g_drive_handler/gdrive_folder_screen.dart';
import 'package:haelo_flutter/features/google_drive/g_drive_handler/gdrivehandler_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class GoogleDriveHandler {
  GoogleDriveHandler._internal();

  static final GoogleDriveHandler _googleDriveHandler =
      GoogleDriveHandler._internal();

  factory GoogleDriveHandler() => _googleDriveHandler;

  google_sign_in.GoogleSignInAccount? account;

  String? _googlDriveApiKey;
  bool? isSignIn;

  setAPIKey({required String apiKey}) {
    _googlDriveApiKey = apiKey;
  }

  Future<Map<String, dynamic>> gmailAuthenticate(BuildContext context) async {
    Map<String, dynamic> map = {};
    final googleSignIn = google_sign_in.GoogleSignIn.standard(
        scopes: [drive.DriveApi.driveScope]);
    // if(!await googleSignIn.isSignedIn()) {
    await _signinUser();
    // }else{
    //   print("already signedIn");
    //   account = await googleSignIn!.signInSilently(reAuthenticate: true);
    // }
    if (account != null) {
      final authHeaders = await account!.authHeaders;
      final authenticateClient = _GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);
      map['client'] = authenticateClient;
      map['driveApi'] = driveApi;
      map['gdrive_api_key'] = _googlDriveApiKey.toString();
    }
    return map;
  }

  Future loginWithGmail({
    required BuildContext context,
    int signInFor = 0,
    String parentFolerName = "",
    String subFolerName = "",
    String folderId = "",
    File? file,
  }) async {
    if (_googlDriveApiKey != null) {
      await _signinUser();
      if (account != null) {
        final authHeaders = await account!.authHeaders;

        log(account!.displayName.toString());
        final authenticateClient = _GoogleAuthClient(authHeaders);
        final driveApi = drive.DriveApi(authenticateClient);
        if (signInFor == 0) {
          // picking file
          return await _openGoogleDriveScreen(
              context, driveApi, authenticateClient);
        } else if (signInFor == 1) {
          // create folder if exist or not
          return folderCreate(
            driveApi,
            parentFolerName,
            subFolerName,
          );
        } else if (signInFor == 2) {
          // create folder if exist or not
          return fileUploadToDrive(driveApi, folderId, file);
        }
      } else {
        log("Google Signin was declined!");
      }
    } else {
      log('GOOGLEDRIVEAPIKEY has not yet been set. Please follow the documentation and call GoogleDriveHandler().setApiKey(YourAPIKey); to set your own API key');
    }
  }

  Future<Map<String, String>> folderCreate(
      driveApi, parentFolerName, subFolderName) async {
    String folderName = "HAeLO";

    try {
      // Check if the folder already exists
      final query =
          "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
      final response = await driveApi.files.list(q: query);

      if (response.files!.isNotEmpty) {
        final existingFolder = response.files!.first;
        print(
            "Folder '${existingFolder.name}' already exists with ID: ${existingFolder.id}");
        // Create the subfolder within the existing folder
        String subFolderId = "";
        String parentFolderId = "";
        await subfolderCreate(driveApi, existingFolder.id, parentFolerName)
            .then((value) async {
          parentFolderId = value;
          subFolderId = await subfolderCreate(driveApi, value, subFolderName);
          return "";
        });

        Map<String, String> map = {
          "haelo_folder_id": existingFolder.id.toString(),
          "parent_folder_id": parentFolderId.toString(),
          "sub_folder_id": subFolderId,
        };
        return map;
      } else {
        // Create the folder
        final folder = drive.File()
          ..name = folderName
          ..mimeType = "application/vnd.google-apps.folder";

        final haeloFolder = await driveApi.files.create(folder);
        print(
            "Folder '${haeloFolder.name}' created with ID: ${haeloFolder.id}");

        // Create the subfolder within the existing folder

        // String subFolderId =
        //         //     await subfolderCreate(driveApi, haeloFolder.id, parentFolerName);
        //         // Map<String, String> map = {
        //         //   "parent_folder_id": haeloFolder.id.toString(),
        //         //   "sub_folder_id": subFolderId,
        //         // };

        String parentFolderId = "";
        String subFolderId = "";
        await subfolderCreate(driveApi, haeloFolder.id, parentFolerName)
            .then((value) async {
          parentFolderId = value;
          subFolderId = await subfolderCreate(driveApi, value, subFolderName);
          return "";
        });
        toast(msg: "Folder created");
        Map<String, String> map = {
          "haelo_folder_id": haeloFolder.id.toString(),
          "parent_folder_id": parentFolderId.toString(),
          "sub_folder_id": subFolderId,
        };

        return map;
      }
    } catch (e) {
      print("Error checking/creating folder: $e");
    }
    return {};
  }

  Future<String> subfolderCreate(
      driveApi, parentFolderId, subFolderName) async {
    try {
      final subfolderQuery =
          "name = '$subFolderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false and '${parentFolderId}' in parents";
      final subfolderResponse = await driveApi.files.list(q: subfolderQuery);

      // print("subfolderResponse ${subfolderResponse}");
      // print("subfolderResponse files ${subfolderResponse.files!}");

      if (subfolderResponse.files!.isNotEmpty) {
        final subfolder = subfolderResponse.files!.first;
        // print(
        //     "Subfolder '${subfolder.name}' already exists with ID: ${subfolder.id}");
        return subfolder.id.toString();
      } else {
        // Create subfolder within the existing parent folder
        final subfolder = drive.File()
          ..name = subFolderName
          ..mimeType = "application/vnd.google-apps.folder"
          ..parents = [parentFolderId!]; // Set the parent folder ID

        final newSubfolder = await driveApi.files.create(subfolder);
        // print(
        //     "Subfolder '${newSubfolder.name}' created with ID: ${newSubfolder.id}");
        return newSubfolder.id.toString();
      }
    } catch (e) {
      print("Error checking/creating folder: $e");
    }
    return "";
  }

  Future<Map<String, String>> folderCreateWithoutSub(
      driveApi, haeloFolderName, subFolderName) async {
    try {
      // Check if the HAeLO folder already exists
      final haeloQuery =
          "name = '$haeloFolderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
      final haeloResponse = await driveApi.files.list(q: haeloQuery);

      String haeloFolderId;
      String subFolderId;

      if (haeloResponse.files!.isNotEmpty) {
        // HAeLO folder already exists
        final existingHaeloFolder = haeloResponse.files!.first;
        print(
            "HAeLO Folder '${existingHaeloFolder.name}' already exists with ID: ${existingHaeloFolder.id}");
        haeloFolderId = existingHaeloFolder.id!;
      } else {
        // HAeLO folder doesn't exist, create it
        final haeloFolder = drive.File()
          ..name = haeloFolderName
          ..mimeType = "application/vnd.google-apps.folder";

        final createdHaeloFolder = await driveApi.files.create(haeloFolder);
        print(
            "HAeLO Folder '${createdHaeloFolder.name}' created with ID: ${createdHaeloFolder.id}");
        toast(msg: "Folder created");
        haeloFolderId = createdHaeloFolder.id!;
      }

      // Check if the subfolder already exists within HAeLO folder
      final subFolderQuery =
          "name = '$subFolderName' and mimeType = 'application/vnd.google-apps.folder' and '$haeloFolderId' in parents and trashed = false";
      final subFolderResponse = await driveApi.files.list(q: subFolderQuery);

      if (subFolderResponse.files!.isNotEmpty) {
        // Subfolder already exists within HAeLO folder
        final existingSubFolder = subFolderResponse.files!.first;
        print(
            "Subfolder '${existingSubFolder.name}' already exists within HAeLO Folder with ID: ${existingSubFolder.id}");
        subFolderId = existingSubFolder.id!;
      } else {
        // Subfolder doesn't exist, create it within HAeLO folder
        final subFolder = drive.File()
          ..name = subFolderName
          ..mimeType = "application/vnd.google-apps.folder"
          ..parents = [haeloFolderId];

        final createdSubFolder = await driveApi.files.create(subFolder);
        print(
            "Subfolder '${createdSubFolder.name}' created within HAeLO Folder with ID: ${createdSubFolder.id}");
        subFolderId = createdSubFolder.id!;
      }

      // Return the IDs of HAeLO folder and subfolder
      return {
        "haelo_folder_id": haeloFolderId,
        "sub_folder_id": subFolderId,
      };
    } catch (e) {
      print("Error checking/creating folder: $e");
      return {};
    }
  }

  Future<bool> isFolderAlreadyCreated(driveApi, String folderName) async {
    try {
      final query =
          "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
      final response = await driveApi.files.list(q: query);

      // Check if the response contains any files
      return response.files != null && response.files!.isNotEmpty;
    } catch (e) {
      // Handle any errors
      print("Error checking folder: $e");
      return false;
    }
  }

  Future fileUploadToDrive(driveApi, folderId, filex) async {
    print("folderId $folderId");
    // Choose the file to upload

    File fileToUpload = File(filex.path);

    final file = drive.File()
      ..name = path.basename(fileToUpload.path)
      ..parents = ['$folderId'];
    // Upload the file
    final media =
        drive.Media(fileToUpload.openRead(), fileToUpload.lengthSync());
    final uploadedFile = await driveApi.files.create(file, uploadMedia: media);

    print("File '${uploadedFile.name}' uploaded with ID: ${uploadedFile.id}");
  }

  Future fileUploadToDrivePdf(driveApi, folderId, url, String fileName) async {
    print("folderId $folderId");

    // Download the file from the URL
    http.Response response = await http.get(Uri.parse(url));
    Uint8List bytes = response.bodyBytes;

    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();

    // Create a temporary file to store the downloaded content
    File tempFile = File('${tempDir.path}/$fileName.pdf');

    // Write the downloaded content to the temporary file
    await tempFile.writeAsBytes(bytes);

    // Create the file metadata
    final file = drive.File()
      ..name = path.basename(tempFile.path)
      ..parents = [
        '$folderId'
      ]; // Replace with the ID of the folder where you want to upload the file

    // Upload the file
    final media = drive.Media(tempFile.openRead(), tempFile.lengthSync());
    final uploadedFile = await driveApi.files.create(file, uploadMedia: media);

    print("File '${uploadedFile.name}' uploaded with ID: ${uploadedFile.id}");

    // Optionally, you can delete the temporary file after uploading
    await tempFile.delete();
  }

  Future<void> uploadToDrive(
      driveApi, folderId, String filePath, String fileName) async {
    print("folderId $folderId");

    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();

    // Create the file metadata
    final file = drive.File()
      ..name = fileName
      ..parents = [folderId];

    File localFile = File(filePath);

    // Upload the file
    final media = drive.Media(localFile.openRead(), localFile.lengthSync());
    final uploadedFile = await driveApi.files.create(file, uploadMedia: media);

    print("File '${uploadedFile.name}' uploaded with ID: ${uploadedFile.id}");
  }

  _openGoogleDriveScreen(
      BuildContext context, driveApi, authenticateClient) async {
    // final authHeaders = await account!.authHeaders;
    //
    // log(account!.displayName.toString());
    // final authenticateClient = _GoogleAuthClient(authHeaders);
    // final driveApi = drive.DriveApi(authenticateClient);

    drive.FileList fileList = await driveApi.files.list(
        pageSize: 1000,
        q: "mimeType='image/jpeg' or mimeType = 'image/png'"
            " or mimeType = 'image/jpg' or mimeType = 'application/vnd.google-apps.spreadsheet' or "
            "mimeType = 'application/vnd.ms-excel' or "
            "mimeType = 'application/pdf'");
    print('cfiles ${fileList.files!.length}');
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GoogleDriveScreen(
          fileList: fileList,
          googleDriveApiKey: _googlDriveApiKey.toString(),
          authenticateClient: authenticateClient,
          userName: "Drive",
          // userName: account!.displayName!.substring(
          //   0,
          //   account!.displayName!.indexOf(" "),
          // ),
        ),
      ),
    );
  }

  openGoogleDriveFolder(
      BuildContext context, driveApi, authenticateClient) async {
    drive.FileList fileList = await driveApi.files.list(
        pageSize: 1000, q: "'1kw5FLqDBarA2iVyklZNQQ9HXz98w-GKb' in parents");
    print('cfiles ${fileList.files!.length}');
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GDriveFolderScreen(
          fileList: fileList,
          googleDriveApiKey: _googlDriveApiKey.toString(),
          authenticateClient: authenticateClient,
          userName: "Drive",
          driveApi: driveApi,
        ),
      ),
    );
  }

  Future _signinUser() async {
    print("signin now");
    final googleSignIn = google_sign_in.GoogleSignIn.standard(
        scopes: [drive.DriveApi.driveScope]);
    //googleSignIn.signOut(); //rahul
    account = await googleSignIn.signIn();

    return;
  }
}

class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
