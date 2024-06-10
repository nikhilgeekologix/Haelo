// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:haelo_flutter/core/utils/ui_helper.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
//
// import '../../widgets/app_button.dart';
//
// class LedgerWebView extends StatefulWidget {
//   String? url;
//   LedgerWebView({this.url, Key? key}) : super(key: key);
//
//   @override
//   State<LedgerWebView> createState() => _LedgerWebViewState();
// }
//
// class _LedgerWebViewState extends State<LedgerWebView> {
//   WebViewController _controller = WebViewController();
//
//   bool isExpanded = false;
//   bool isLoading = false;
//   String selectedValue = "month";
//   List<String> sortList = [
//     "year",
//     "quarter",
//     "month",
//     "week",
//     "today",
//   ];
//   // String selectedValue = "month";
//   String htmlString = "<html><text>hey</text></html>";
//   @override
//   void initState() {
//     super.initState();
//     //BlocProvider.of<LedgerCubit>(context).getLedger(selectedValue);
//     getLedger(selectedValue);
//     // setHtml();
//   }
//
//   void getLedger(type) async {
//
//     Future.delayed(const Duration(milliseconds: 500), () {
//        _loadLocalHTML();
//
//       isLoading = false;
//       setState(() {});
//     });
//   }
//
//   Future<String> _loadLocalHTML() async {
//     String htmlContent= await rootBundle.loadString('assets/html/drive_picker.html');
//     print(htmlContent);
//     _controller.loadHtmlString(htmlContent);
//
//     return htmlContent;
//   }
//
//   WebViewController setHtml() {
//     WebViewController _newcontroller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadHtmlString(htmlString);
//     // ..loadRequest(Uri.parse("http://13.232.235.32/terms"));
//     _newcontroller.loadHtmlString(htmlString);
//     return _newcontroller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColor.white,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: AppColor.white,
//           body: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5.0),
//                     child: Row(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.chevron_left_outlined,
//                               size: 30,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           ///TO do Bilingual
//                           "Web view",
//                           // commonStringsDecoded != null
//                           //     ? commonStringsDecoded!.mISTRYFAQ.toString()
//                           //     : "",
//                           style: appTextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: "Lato",
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   isLoading
//                       ? const Center(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 40.0),
//                       child: CircularProgressIndicator(
//                         strokeWidth: 4,
//                         valueColor:
//                         AlwaysStoppedAnimation(AppColor.primary),
//                       ),
//                     ),
//                   )
//                       : Expanded(
//                     child: WebViewWidget(
//                       controller: _controller,
//                     ),
//                   ),
//                   const SizedBox(height: 75)
//                 ],
//               ),
//             ],
//           ),
//           // : Container(
//           //     padding: EdgeInsets.all(16),
//           //     child: Column(
//           //       children: [
//           //         Expanded(child: Text("Html content appear here")),
//           //         bottomBtn(context)
//           //       ],
//           //     ),
//           //   ),
//           ///
//           // floatingActionButton: FloatingActionButton.extended(
//           //     elevation: 0,
//           //     shape: RoundedRectangleBorder(
//           //         borderRadius: BorderRadius.circular(16)),
//           //     backgroundColor: AppColor.primary,
//           //     onPressed: () {
//           //       FocusScope.of(context).requestFocus(FocusNode());
//           //
//           //       BottomSheetDialog(context, const TalkToExpert(),
//           //               radius: 20,
//           //               bgColor: Colors.transparent,
//           //               barrierCol: Colors.transparent.withAlpha(150),
//           //               elevation: 0)
//           //           .showScreen();
//           //     },
//           //     label: Text(
//           //       "Email",
//           //
//           //       ///To DO Bilingual
//           //       // commonStringsDecoded != null
//           //       //     ? commonStringsDecoded!.oRDERS.toString()
//           //       //     : "",
//           //       style: appTextStyle(
//           //         fontSize: 14,
//           //         fontFamily: "Lato",
//           //         fontWeight: FontWeight.w600,
//           //         textColor: AppColor.white,
//           //       ),
//           //     )),
//
//         ),
//       ),
//     );
//   }
// }
