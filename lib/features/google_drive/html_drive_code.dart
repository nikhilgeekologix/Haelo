// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:haelo_flutter/core/utils/ui_helper.dart';
// import 'ui_platform.dart' if (dart.library.html) 'dart:ui' as ui;
//
// class GoogleDrivePicker extends StatefulWidget {
//   const GoogleDrivePicker({super.key});
//
//   @override
//   State<GoogleDrivePicker> createState() => _GoogleDrivePickerState();
// }
//
// class _GoogleDrivePickerState extends State<GoogleDrivePicker> {
//
//   String htmlContent="";
//   @override
//   void initState() {
//     //_loadLocalHTML();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ui.platformViewRegistry.registerViewFactory("drive_html_channel", (int viewId) {
//
//       html.IFrameElement element = html.IFrameElement();
//       //print("after IFrameElement init");
//       //Event Listener
//       html.window.onMessage.forEach((element) {
//         print('Event Received in callback: ${element.data}');
//         if (element.data == 'CLOSED') {
//           print(" Closed");
//
//         }
//         else if (element.data == 'SUCCESS') {
//           print(' SUCCESSFULL!!!!!!!');
//         }
//       });
//
//       // element.requestFullscreen();
//       element.src ='assets/html/drive_picker.html';
//       element.style.border = 'none';
//       return element;
//     });
//     return Scaffold(body: Builder(builder: (BuildContext context) {
//       return Container(
//         child: HtmlElementView(viewType: 'drive_html_channel'),
//       );
//     }));
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('WebView Example'),
//       ),
//       body:  Column(
//         children: [
//           HtmlElementView(viewType: '',),
//           // FutureBuilder<String>(
//           //   future: _loadLocalHTML(),
//           //   builder: (context, snapshot) {
//           //     if (snapshot.hasData) {
//           //       return InAppWebView(
//           //         initialUrlRequest: URLRequest(
//           //           url: Uri.dataFromString(
//           //             snapshot.data!,
//           //             mimeType: 'text/html',
//           //             encoding: Encoding.getByName('utf-8'),
//           //           ),
//           //         ),
//           //         initialOptions: InAppWebViewGroupOptions(
//           //           crossPlatform: InAppWebViewOptions(
//           //             javaScriptEnabled: true, // Enable JavaScript
//           //           ),
//           //         ),
//           //         onWebViewCreated: (controller) {
//           //         //  _webViewController = controller;
//           //         },
//           //       );
//           //     } else {
//           //       return Center(child: CircularProgressIndicator());
//           //     }
//           //   },
//           // ),
//         ],
//       ),
//     );
//   }
//
//   Future<String> _loadLocalHTML() async {
//     htmlContent= await rootBundle.loadString('assets/html/drive_picker.html');
//     print(htmlContent);
//     return htmlContent;
//   }
//
// }
