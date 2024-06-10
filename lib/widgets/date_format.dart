import 'package:easy_localization/easy_localization.dart';

String getDDMMMYYYY(String inputDate) {
  // "2022-01-28 08:42:00"
  var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  var outputFormat = DateFormat('dd MMM yyyy');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getMMMMDDYYYY(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var outputFormat = DateFormat('MMMM dd, yyyy - hh:mm');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getDDMMMMYYYY(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("MMMM dd, yyyy");
  var outputFormat = DateFormat('dd MMMM, yyyy');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getMMMMDDYYYYhhmmss(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var outputFormat = DateFormat('MMM dd, yyyy - hh:mm');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getMMMMDDYYYYhhmm(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("yyyy-MM-dd HH:mm a");
  var outputFormat = DateFormat('MMM dd, yyyy - hh:mm');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getMMMMDDYYYYAM(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var outputFormat = DateFormat('MMMM dd, yyyy - hh:mm a');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getMMMMDYYYY(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var outputFormat = DateFormat('MMMM dd, yyyy');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getCaseMMMMDYYYY(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss");
  var outputFormat = DateFormat('MMMM dd, yyyy');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getHHMM(String inputDate) {
  // "2022-01-28 08:42:00"
  // 2022-01-28 14:10:00
  var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  var outputFormat = DateFormat('hh:mm a');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getMMMDDYYYY(String inputDate) {
  // "2022-01-28 08:42:00"
  var inputFormat = DateFormat('yyyy-MM-dd');
  var outputFormat = DateFormat('MMM dd, yyyy');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getYYYYMMDD(String inputDate) {
  // "2022-01-28 08:42:00"
  var inputFormat = DateFormat('dd/MM/yyyy');
  var outputFormat = DateFormat('yyyy-MM-dd');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getYYYYMMDDownload(String inputDate) {
  // "2022-01-28 08:42:00"
  var inputFormat = DateFormat('dd/MM/yyyy');
  var outputFormat = DateFormat('dd_MM_yyyy');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String dateTimeMMMDDYYYY(var inputDate) {
  String tempDate = inputDate.toString().substring(0, 8);
  String tempTime = inputDate
      .toString()
      .substring(inputDate.toString().length - 11, inputDate.toString().length);
  tempTime = tempTime.trim();

  var inputFormat = DateFormat("MM/dd/yy hh:mm:ss a");
  var outputFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');
  var outputDate =
      outputFormat.format(inputFormat.parse(tempDate + " " + tempTime));

  // var inputFormat = DateFormat("MM/dd/yy h:mm:ss a");
  // var outputFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');
  // var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String formatTimestampToDate(String timestampString) {
  final inputFormat = DateFormat('MM/dd/yy hh:mm:ss a');

  DateTime timestamp = inputFormat.parse(timestampString);

  String formattedDate = DateFormat('dd/MM/yyyy').format(timestamp);
  print("formattedDate $formattedDate");
  return formattedDate;
}

String getDDMMYYYY(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getYYYYMMDDNew(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var outputFormat = DateFormat('yyyy-MM-dd');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getCommentDDMMYYYY(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("dd/MM/yy hh:mm:ss a");
  var outputFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getddMMYYYY_with_splash(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("yyyy-MM-dd");
  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getTimeStamp(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("dd/MM/yyyy");
  var outputFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getEEEddMMMyyyy(String inputDateString) {
  DateTime inputDate =
      DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz').parse(inputDateString);
  String outputDate = DateFormat('dd-MM-yyyy').format(inputDate);
  return outputDate;
}

String getddMMyyyyhhmm(String inputString) {
  DateFormat inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');

  DateTime dateTime = inputFormat.parse(inputString);

  String formattedString = DateFormat('dd-MM-yyyy HH:mm').format(dateTime);

  return formattedString;
}

String getddMMYYYY(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("yyyy-MM-dd");
  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}

String getExpiryDate(String inputDate) {
  // 2022-01-28T08:55:43.000000Z
  var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var outputFormat = DateFormat('MMM d, y');
  var outputDate = outputFormat.format(inputFormat.parse(inputDate));
  return outputDate;
}
