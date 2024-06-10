import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

// class CourtNote extends StatelessWidget {
//   final userData;
//   const CourtNote(this.userData,{Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//           color: AppColor.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         margin: EdgeInsets.all(20),
//         child: Column(children: [
//           Container(
//             padding: EdgeInsets.zero,
//             height: mediaQH(context) * 0.06,
//             // width: mediaQW(context) * 0.9,
//             decoration: BoxDecoration(
//               color: AppColor.primary,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//             ),
//
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Spacer(),
//                 Text(
//                   "Note",
//                   style: mpHeadLine14(textColor: Colors.white),
//                 ),
//                 const Spacer(),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 15),
//                     child: Image.asset(
//                       "assets/images/close.png",
//                       color: Colors.white,
//                       height: 15,
//                       width: 15,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment
//                       .start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(
//                       height:
//                       10,
//                     ),
//                     RichText(
//                         text: TextSpan(
//                             text:
//                             "Daily: ",
//                             style:
//                             mpHeadLine16(textColor: AppColor.primary, fontWeight: FontWeight.w500),
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text:
//                                 userData.notice!.daily.toString(),
//                                 style:
//                                 mpHeadLine14(
//                                   textColor: Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               )
//                             ])),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     RichText(
//                         text: TextSpan(
//                             text:
//                             "Supplimentary: ",
//                             style:
//                             mpHeadLine16(textColor: AppColor.primary, fontWeight: FontWeight.w500),
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text:
//                                 userData!.notice!.supplimentary.toString(),
//                                 style:
//                                 mpHeadLine14(textColor: Colors.black, fontWeight: FontWeight.w500),
//                               )
//                             ])),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     RichText(
//                         text: TextSpan(
//                             text:
//                             "Display Board: ",
//                             style:
//                             mpHeadLine16(textColor: AppColor.primary, fontWeight: FontWeight.w500),
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text:
//                                 userData.notice!.display.toString(),
//                                 style:
//                                 mpHeadLine14(textColor: Colors.black, fontWeight: FontWeight.w500),
//                               )
//                             ])),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ]));
//   }
// }

AlertDialog courtNoteDialog( final userData, BuildContext context){
  return  AlertDialog(
      contentPadding:
      const EdgeInsets
          .symmetric(
          horizontal:
          10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      titlePadding:
      EdgeInsets
          .zero,
      insetPadding:
      const EdgeInsets
          .symmetric(
          horizontal:
          25,
          vertical:
          15),
      title: Container(
        padding:
        EdgeInsets
            .zero,
        height: mediaQH(
            context) *
            0.06,
        // width: mediaQW(context) * 0.9,
        decoration: BoxDecoration(
          color: AppColor
              .primary,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(5),
              topRight: Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            SizedBox(width: 30,),
            const Spacer(),
            Text(
              "Note",
              style: mpHeadLine14(
                  textColor:
                  Colors.white),
            ),
            const Spacer(),
            InkWell(
              onTap:
                  () {
                Navigator.pop(
                    context);
              },
              child:
              Padding(
                padding:
                const EdgeInsets.only(right: 15),
                child: Image
                    .asset(
                  ImageConstant.close,
                  color:
                  Colors.white,
                  height:
                  15,
                  width:
                  15,
                ),
              ),
            )
          ],
        ),
      ),
      content:
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .start,
          children: [
            const SizedBox(
              height:
              10,
            ),
            RichText(textAlign: TextAlign.start,
                text: TextSpan(
                    text:
                    "Daily: ",
                    style:
                    mpHeadLine16(textColor: AppColor.primary, fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                        userData.notice!.daily.toString(),//.replaceAll("\n", "").replaceAll("\t", " "),
                        style:
                        mpHeadLine14(
                          textColor: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ])),
            const SizedBox(
              height: 8,
            ),
            // Wrap( direction: Axis.horizontal, //default
            //   alignment: WrapAlignment.start,
            //   children: [
            //     Text("Supplimentary: ",
            //       style:
            //       mpHeadLine16(textColor: AppColor.primary, fontWeight: FontWeight.w500),),
            //     HtmlWidget(
            //       userData!.notice!.supplimentary.toString(),
            //       textStyle:
            //       mpHeadLine14(fontWeight: FontWeight.w500),
            //     ),
            //   ],
            // ),
            RichText(textAlign: TextAlign.start,
                text: TextSpan(
                    text:
                    "Supplimentary: ",
                    style:
                    mpHeadLine16(textColor: AppColor.primary, fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                        userData!.notice!.supplimentary.toString(),
                        style:
                        mpHeadLine14(textColor: Colors.black, fontWeight: FontWeight.w500),
                      )
                    ])),
            const SizedBox(
              height: 8,
            ),
            RichText(textAlign: TextAlign.start,
                text: TextSpan(
                    text:
                    "Display Board: ",
                    style:
                    mpHeadLine16(textColor: AppColor.primary, fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                        userData.notice!.display.toString(),//.replaceAll("\n", "").replaceAll("\t", " "),
                        style:
                        mpHeadLine14(textColor: Colors.black, fontWeight: FontWeight.w500),
                      )
                    ])),
          ],
        ),
      ),
      actions: <
          Widget>[]);
}
