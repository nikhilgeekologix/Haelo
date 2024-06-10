import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/alert/data/model/add_event_model.dart';
import 'package:haelo_flutter/features/alert/data/model/auto_download_model.dart';
import 'package:haelo_flutter/features/alert/data/model/delete_alert_model.dart';
import 'package:haelo_flutter/features/alert/data/model/my_alert_model.dart';
import 'package:haelo_flutter/services/network_service.dart';
import 'package:haelo_flutter/urls.dart';

class MyAlertDataSource {
  final NetworkService networkService;
  final NetworkInfo networkInfo;

  MyAlertDataSource(this.networkService, this.networkInfo);

  Future<MyAlertModel> fetchMyAlert() async {
    try {
      final response = await networkService.postRequestNew(
        isFullURL: false,
        url: Urls.VIEW_ALERT,
        isAuth: true,
        versionName: "2.0",
      );
      MyAlertModel model = MyAlertModel();
      return MyAlertModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }

  Future<DeleteAlertModel> deleteAlert(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false,
          url: Urls.DELETE_ALERT,
          isAuth: true,
          versionName: "1.0",
          body: body);
      return DeleteAlertModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }

  Future<AddEventModel> addEventToCalendar(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false,
          url: Urls.SET_CALENDAR_EVENT,
          isAuth: true,
          versionName: "1.0",
          body: body);
      return AddEventModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }

  Future<DeleteWatchlistModel> deleteWatchlist(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false,
          url: Urls.DELETE_WATCHLIST,
          isAuth: true,
          versionName: "1.0",
          body: body);
      return DeleteWatchlistModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }

  Future<EditWatchlistModel> editWatchlist(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false,
          url: Urls.EDIT_WATCHLIST,
          isAuth: true,
          versionName: "3.0",
          body: body);
      return EditWatchlistModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }

  Future<AutoDownloadModel> autoDownload(Map<String, String> body) async {
    try {
      final response = await networkService.postRequestNew(
          isFullURL: false,
          url: Urls.PDF_DOWNLOAD,
          isAuth: true,
          versionName: "1.0",
          body: body);
      return AutoDownloadModel.fromJson(response);
    } catch (e) {
      print("hello $e");
      throw ServerException('Failed to get data');
    }
  }
}
