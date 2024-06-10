import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:dio/src/response.dart';
import 'package:dio/src/options.dart';
import 'package:dio/src/dio.dart';
import 'package:dio/src/form_data.dart';

import '../core/utils/exceptions.dart';
import 'package:http/src/streamed_response.dart';

class NetworkService {
  Map<String, String> defaultHeaders;
  http.Client httpService;
  String? baseUrl;

  //GlobalKey<NavigatorState>? navigationKey;
  BuildContext? context;

  NetworkService({
    this.baseUrl,
    required this.defaultHeaders,
    required this.httpService,
  });

  Future<Map<String, dynamic>> getRequest({
    required String url,
    Map<String, String>? headers,
    required bool isFullURL,
  }) async {
    try {
      http.Response response = await httpService.get(
        Uri.parse(
          isFullURL ? url : baseUrl! + url,
        ),
        headers: headers ?? defaultHeaders,
      );
      return _fetchResponse(response);
    } on UnauthorisedException catch (e) {
      throw e;
    } on ServerException catch (e) {
      // print('Server Exception in get request for url: ' + url);
      throw e;
    } on FormatException catch (e) {
      // print('Format Exception in get request for url: ' + url);
      // print('Format Exception:' + e.toString());
      throw ServerException('Error occured while Communication with Server');
    }
  }

  Future<Map<String, dynamic>> postMultipartRequest(
    String url, {
    CroppedFile? file,
    String versionName = "1.0",
    Map<String, String> headers = const {},
    Map<String, String> fields = const {},
    bool isAuth = false,
    String fileKey = 'media',
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl! + url),
      );
      // print("url ${baseUrl! + url}");

      if (isAuth) {
        headers = {
          'Authorization': 'Bearer ${prefs.getString(Constants.ACCESS_TOKEN)}',
          'Content-Type': 'application/json; charset=UTF-8',
          'Version': versionName
        };
        request.headers.addAll(headers);
      } else {
        headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Version': versionName
        };
      }
      if (file != null) {
        // request.files.add(
        //   http.MultipartFile(
        //     fileKey,
        //     file.readAsBytes().asStream(),
        //     file.readAsBytes().hashCode,
        //     filename: file.path.split("/").last,
        //   ),
        // );

        request.files.add(await http.MultipartFile.fromPath(
          fileKey,
          file.path,
        ));
      }
      /*var multipartFile = await http.MultipartFile.fromPath(fileKey, file.path);
      request.files.add(multipartFile);*/

      // request.fields.addAll(fields);
      // print("request ${request.fields}");
      // print("request file ${request.files.length}");
      // print("request filename ${request.files.first.field}");
      var response = await request.send();
      // print("multi response ${response.statusCode}");
      final data = await http.Response.fromStream(response);
      // var data = await response.stream.bytesToString();
      // success case
      return _fetchResponse(data);
    } catch (e) {
      final data = jsonDecode(e as String);
      throw ServerException(data['message']);
    }
  }

  Future<Map<String, dynamic>> postRequest2({
    required String url,
    String versionName = "1.0",
    Map<String, String>? headers,
    Map<String, dynamic>? body = const {},
    required bool isFullURL,
    bool isAuth = false,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    try {
      var headers = {
        'Authorization': 'Bearer ${prefs.getString(Constants.ACCESS_TOKEN)}',
        'Version': versionName
      };

      Response response;
      var options = BaseOptions(
          baseUrl: isFullURL ? url : baseUrl! + url,
          headers: headers,
          extra: body,
          method: 'POST');
      dio = Dio(options);
      print("post2 body $body");

      response = await dio.post(
        isFullURL ? url : baseUrl! + url,
        data: body,
      );
      print("post2 body// ${response.extra}");
      print("post2 response $response");

      return _fetchMultiResponse(response);
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          // Handle 401 error
          FBroadcast.instance().broadcast("unauthorized");
        }
      }
      return {};
    }
  }

  Future<Map<String, dynamic>> postRequestNew({
    List<File>? file,
    String versionName = "1.0",
    required String url,
    Map<String, String>? headers,
    // Map<String, String>? body = const {},
    Map<String, String>? body = const {},
    required bool isFullURL,
    bool isAuth = false,
    String fileKey = 'media',
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("token ${prefs.getString(Constants.ACCESS_TOKEN)}");
    try {
      // if (isAuth) {
      //   headers = {
      //     'Authorization': 'Bearer ${prefs.getString(Constants.ACCESS_TOKEN)}',
      //     'Content-Type': 'application/json; charset=UTF-8',
      //     'Version': "1.0"
      //   };
      // } else {
      //   headers = {'Content-Type': 'application/json; charset=UTF-8', 'Version': "1.0"};
      // }
      print("url ${baseUrl! + url}");
      print("body  ${body}");
      // http.Response response = await httpService.post(
      //   Uri.parse(
      //     isFullURL ? url : baseUrl! + url,
      //   ),
      //   headers: headers ?? defaultHeaders,
      //   body: json.encode(body),
      //   encoding: Encoding.getByName("utf-8"),
      // );

      //////////////////////////////
      var headers = {
        'Authorization': 'Bearer ${prefs.getString(Constants.ACCESS_TOKEN)}',
        'Version': versionName
      };
      print("header $headers");
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
            baseUrl! + url,
          ));

      request.fields.addAll(body!);

      request.headers.addAll(headers);
      //////////////////////////////////
      if (file != null && file.isNotEmpty) {
        // request.files.add(
        //   http.MultipartFile(
        //     fileKey,
        //     file.readAsBytes().asStream(),
        //     file.readAsBytes().hashCode,
        //     filename: file.path.split("/").last,
        //   ),
        // );

        for (int i = 0; i < file.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            fileKey,
            file[i].path,
          ));
        }
      }

      http.StreamedResponse response = await request.send();

      var responseData = await response.stream.bytesToString();
      print("network response ${responseData}");
      if (response.statusCode == 401 || response.statusCode == 403) {
        FBroadcast.instance().broadcast("unauthorized");
      }
      // else{
      //   print("network response ${responseData}");
      return json.decode(responseData); // hasmap;
      // }

      // return _fetchResponse_Stream(response);
    } on UnauthorisedException catch (e) {
      print("status code??? unauthorized");

      // navigationKey!.currentState!.pushNamed('/login');
      print(e.message + url);
      throw e;
    } on ServerException catch (e) {
      // print('Server Exception in get request for url: ' + url + e.toString());
      throw e;
    } on FormatException catch (e) {
      // print('Format Exception in get request for url: ' + url);
      // print('Format Exception:' + e.toString());
      throw ServerException('Error occured while Communication with Server');
    }
  }

  Future<Map<String, dynamic>> postMultiMultipartRequest(String url,
      {Map<String, String> headers = const {},
      Map<String, File> files = const {},
      bool isAuth = false,
      String fileKey = 'media',
      String documentID = "",
      String userDocumentID = "",
      String documentName = "",
      var formData = FormData}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("token ${prefs.getString(Constants.ACCESS_TOKEN)}");
    try {
      if (isAuth) {
        headers = {
          'Authorization': 'Bearer ${prefs.getString(Constants.ACCESS_TOKEN)}'
        };
        //to guest login k bad agr m Constants.ACCESS_TOKEN
        // isse khi access krta hu to value
      } else {}

      Response response;
      var options =
          BaseOptions(baseUrl: this.baseUrl!, headers: headers, method: 'POST');
      var dio = Dio(options);

      // var formData = FormData.fromMap({
      //   'document_id': documentID,
      //   'document_file': filesData,
      //   'user_document_id': userDocumentID,
      //   'document_name': documentName,
      //   'document_type_id': documentTypeID
      // });
      // print("url $url");
      // print("formData $formData");
      response = await dio.post(url, data: formData);

      // var data = await response.stream.bytesToString();
      // success case
      //print("multiple img upload response $response");
      return _fetchMultiResponse(response);
    } catch (e) {
      final data = jsonDecode(e as String);
      throw ServerException(data['message']);
    }
  }
}

dynamic _fetchMultiResponse(Response response) {
  // var responseJson;
  // if (response.stream.bytesToString() != null)
  //   responseJson = response.stream.bytesToString();
  // else
  //   responseJson = <dynamic, String>{};
  switch (response.statusCode) {
    case 200:
    case 201:
      return response.data;
    case 400:
      throw BadRequestException(response.data.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.data.toString());
    case 404:
    case 500:
    default:
      throw ServerException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

dynamic _fetchResponse(http.Response response) {
  var responseJson;
  // print("status code??? ${response.statusCode}");
  if (response.body.isNotEmpty)
    responseJson = json.decode(response.body);
  else
    responseJson = <dynamic, String>{};
  switch (response.statusCode) {
    case 200:
    case 201:
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 404:
    case 422:
      return responseJson;
    case 500:
    default:
      throw ServerException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

dynamic _fetchResponse_Stream(StreamedResponse response) async {
  var responseJson;
  var responseData = await response.stream.bytesToString();
  if (responseData.isNotEmpty)
    responseJson = json.decode(responseData);
  else
    responseJson = <dynamic, String>{};

  print("response.statusCode ${response.statusCode}");
  print("responseJson ${responseJson}");
  switch (response.statusCode) {
    case 200:
    case 201:
      return responseJson;
    case 400:
      throw BadRequestException(responseData.toString());
    case 401:
    case 403:
      throw UnauthorisedException(responseData.toString());
    case 404:
    case 422:
      return responseJson;
    case 500:
    default:
      throw ServerException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
