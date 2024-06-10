import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:http/http.dart' as http;


class DriveScreen extends StatefulWidget {
  @override
  _DriveScreenState createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  // final _storage = FlutterSecureStorage();
  GoogleSignIn? _googleSignIn;
  auth.AuthClient? _client;
  drive.DriveApi? _driveApi;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveScope]);
  }

  Future<void> _signIn() async {
    try {
      await _googleSignIn!.signIn();

      if (_googleSignIn!.currentUser != null) {
        final authHeaders = await _googleSignIn!.currentUser!.authHeaders;
        final accessToken = authHeaders['Authorization']!.split(' ').last;
        final token = authHeaders['Authorization']!;

        _listFiles(token);

        // print("authHeaders// $authHeaders");
        // final credentials = auth.AccessCredentials(
        //   auth.AccessToken(accessToken,
        //     "", DateTime.now().toUtc(),),
        //   null,
        //   [drive.DriveApi.driveFileScope],// Replace with the user's email address
        // );
        // print("credentials// ${credentials.accessToken}");
        // print("credentials?? ${credentials.refreshToken}");
        // final client = auth.authenticatedClient(http.Client(), credentials);
        // print("client// $client");
        // _driveApi = drive.DriveApi(client);
        // _listPhotos();
      }
    } catch (e) {
      print("Error signing in: $e");
    }
  }


  Future<void> _listFiles(String token) async {
    print("token $token");
    try {
      final url = Uri.parse('https://www.googleapis.com/drive/v3/files');
      final headers = {'Authorization': '$token'};

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Handle the JSON response with the list of files here
        print(jsonResponse);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error listing files: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await _googleSignIn!.signOut();
      _driveApi = null;
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> _listPhotos() async {
    print("inside listphotos");
    try {
      if (_driveApi != null) {
        final fileList = await _driveApi!.files.list(q: "mimeType='image/jpeg'");
        print("Photos found: ${fileList.files!.length}");
      }
    } catch (e) {
      print("Error listing photos: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Drive Access'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                if (_client == null) {
                  await _signIn();
                } else {
                  await _signOut();
                }
              },
              child: Text(_client == null ? 'Sign In' : 'Sign Out'),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                goToPage(context, MyHomePage());
              },
              child: Text('Goto Drive'),
            ),
          ],
        ),
      ),
    );
  }
}



class MyHomePage extends StatefulWidget {
  // MyHomePage({Key? key}) : super(key: key);

  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GoogleSignIn? _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveScope]);
  }


  Future<void> readFile() async {
    print(' read file');

    // await _googleSignIn!.signIn();

    final googleSignIn = GoogleSignIn(scopes: [
      drive.DriveApi.driveFileScope,
    ]);
    final  account = await googleSignIn.signIn();
    print("User account $account");

    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    drive.DriveList driveList = drive.DriveList();
    // drive.FileList fileList = drive.FileList( kind: 'appDataFolder');
    drive.FileList fileList = drive.FileList( );
    var driveFiles = await driveApi.files.list(q: 'mimeType=\'image/jpeg\'');
    List<File>? files = driveFiles.files!.cast<File>();
    for (File file in files!) {
      print("\nrahul index ");
      print(file.id);
      print(file.name);
    }

    if (driveList == null ) {
      print(' driveList is null');
    } else {
      print(' driveList is not NULL ');
    }

    if ( fileList == null ) {
      print(' fileList is null');
    } else {
      print(' fileList is NOT null');

      List<drive.File>? allFiles =     fileList.files;

      if ( allFiles == null || allFiles.isEmpty ) {
        print(' allFiles is empty ');
      }
      Map<String, dynamic> fileListJson = fileList.toJson();

      if ( fileListJson == null || fileListJson.isEmpty) {
        print(' fileList toJson is null');
      }

    }
  }


  Future<void> folderName() async {

    final googleSignIn = GoogleSignIn(scopes: [
      drive.DriveApi.driveFileScope,
    ]);
    final  account = await googleSignIn.signIn();
    print("User account $account");

    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    final Stream<List<int>> mediaStream = Future.value([104, 105]).asStream();
    var media = new drive.Media(mediaStream, 2);
    var driveFile = new drive.File();

    var folder = drive.File()
      ..name = "New sonata folder"
      ..mimeType = "application/vnd.google-apps.folder";

    //driveFile.name = 'hello.txt';
    final result = await driveApi.files.create(folder,);
    print("Upload result: $result");
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
        //
        title: Text("title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello2',
            ),

          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: (){},
            tooltip: 'Folder Name create',
            child: Icon(Icons.save),
          ),

          FloatingActionButton(
            onPressed: readFile,
            tooltip: 'show The file listing and contents',
            child: Icon(Icons.open_in_new),
          ),
          //there would be a method which is return a folder path
          // if that folder not present in drive it will create and then pass that folder path
          // and if already have will return that folder path
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }





}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}