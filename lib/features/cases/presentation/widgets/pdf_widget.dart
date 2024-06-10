// import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:haelo_flutter/core/utils/ui_helper.dart';
//
// class AppPdf extends StatefulWidget {
//   String url;
//    AppPdf(this.url,{Key? key}) : super(key: key);
//
//   @override
//   _AppPdfState createState() => _AppPdfState();
// }
//
// class _AppPdfState extends State<AppPdf> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 1,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_back_ios_new_sharp,
//             size: 24,
//           ),
//         ),
//         backgroundColor: AppColor.white,
//         titleSpacing: -5,
//         title: Text(
//           "Document",
//           style: mpHeadLine16(fontWeight: FontWeight.w500,
//               textColor: AppColor.bold_text_color_dark_blue),
//         ),
//         actions: const [],
//       ),
//       body:  Container(
//         height: mediaQH(context),
//         width: mediaQW(context),
//         child: PDF(
//           swipeHorizontal: false,
//           fitEachPage: true,
//           fitPolicy: FitPolicy.BOTH,
//           pageFling: true,
//         ).fromUrl(
//           widget.url,
//           placeholder: (progress) =>
//           const Padding(
//             padding:
//             EdgeInsets.only(top: 50.0),
//             child: Center(
//               child:
//               CircularProgressIndicator(
//                 color: AppColor.primary,
//               ),
//             ),
//           ),
//           errorWidget: (error) => Center(
//               child: Text(error.toString())),
//         ),
//       ),
//     );
//   }
// }
