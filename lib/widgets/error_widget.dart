import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class AppMsgPopup extends StatelessWidget {
  final msg;
  final bool isError;
  final isCloseIcon;
  final btnCallback;

  AppMsgPopup(this.msg,
      {this.isError = true,
      this.isCloseIcon = true,
      this.btnCallback,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isError
                      ? AppColor.rejected_color_text
                      : AppColor.accepted_color_text,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Center(
                  child: isCloseIcon
                      ? Icon(Icons.error_outline,
                    color: AppColor.white,size:36)
                      :Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(isCloseIcon ? 20 : 5),
                        border: Border.all(color: AppColor.white, width: 2)),
                    padding: EdgeInsets.all(6),
                    child:  Icon(Icons.check_rounded,
                            color: AppColor.white, size: 15),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(msg,
                        style: appTextStyle(), textAlign: TextAlign.center),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: InkWell(
                        onTap: btnCallback ?? () {
                                Navigator.pop(context);
                              },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isError
                                  ? AppColor.rejected_color_text
                                  : AppColor.accepted_color_text,
                              border: Border.all(
                                  color: isError
                                      ? AppColor.rejected_color_text
                                      : AppColor.accepted_color_text)),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            "OK",
                            style: appTextStyle(
                                textColor: AppColor.white, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class AppMsgPopup extends StatefulWidget {
//   final msg;
//   final bool isError;
//   final isCloseIcon;
//   final VoidCallback? btnCallback;
//
//   AppMsgPopup(this.msg,
//       {this.isError = true,
//         this.isCloseIcon = true,
//         this.btnCallback ,
//         Key? key})
//       : super(key: key);
//
//   @override
//   State<AppMsgPopup> createState() => _AppMsgPopupState();
// }
//
// class _AppMsgPopupState extends State<AppMsgPopup> {
//
//   bool _isTapped = false;
//   late Timer _timer;
//   int time=5;
//
//
//   @override
//   void initState() {
//     print("init");
//     // Future.delayed(Duration(seconds: 5),(){
//     //   if(!_isTapped){
//     //
//     //     widget.btnCallback!.call?? toast(msg: "init");
//     //    // widget.btnCallback?? toast(msg: "init taost");
//     //     print("widget.btnCallback");
//     //   }
//     // });
//
//    Timer.periodic(const Duration(seconds: 3), (timer) {
//       _timer = timer;
//       if (time < 1) {
//         if(!_isTapped){
//           widget.btnCallback!();
//           timer.cancel();
//           //print("widget.btnCallback ${widget.btnCallback}");
//         }
//       } else {
//         setState(() {
//           time--;
//           print("time $time");
//         });
//       }
//
//       // setState(() {});
//     });
//     super.initState();
//
//
//     // _timer = Timer(Duration(seconds: 5), () {
//     //
//     //   if (!_isTapped) {
//     //
//     //
//     //     // if(widget.btnCallback.){
//     //     //   //Navigator.pop(context);
//     //     //   widget.btnCallback!();
//     //     // }else{
//     //     //   Navigator.pop(context);
//     //     // }
//     //     print('Auto-triggered event performed');
//     //   }
//     // });
//   }
//
//   @override
//   void dispose() {
//    _timer.cancel();
//     super.dispose();
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(10)),
//           margin: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   color: widget.isError
//                       ? AppColor.rejected_color_text
//                       : AppColor.accepted_color_text,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10)),
//                 ),
//                 child: Center(
//                   child: widget.isCloseIcon
//                       ? Icon(Icons.error_outline,
//                       color: AppColor.white,size:36)
//                       :Container(
//                     decoration: BoxDecoration(
//                         borderRadius:
//                         BorderRadius.circular(widget.isCloseIcon ? 20 : 5),
//                         border: Border.all(color: AppColor.white, width: 2)),
//                     padding: EdgeInsets.all(6),
//                     child:  Icon(Icons.check_rounded,
//                         color: AppColor.white, size: 15),
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Text(widget.msg,
//                         style: appTextStyle(), textAlign: TextAlign.center),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Center(
//                       child: InkWell(
//                         onTap: () {
//                           _isTapped = true;
//                           _timer.cancel();
//                           widget.btnCallback!();
//
//                           // if(widget.btnCallback!=null){
//                           //   Navigator.pop(context);
//                           //   widget.btnCallback;
//                           // }else{
//                           //   Navigator.pop(context);
//                           // }
//                           print('User-tapped event performed');
//                         },
//                         // onTap: widget.btnCallback ?? () {
//                         //   Navigator.pop(context);
//                         // },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: widget.isError
//                                   ? AppColor.rejected_color_text
//                                   : AppColor.accepted_color_text,
//                               border: Border.all(
//                                   color: widget.isError
//                                       ? AppColor.rejected_color_text
//                                       : AppColor.accepted_color_text)),
//                           padding:
//                           EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                           child: Text(
//                             "OK",
//                             style: appTextStyle(
//                                 textColor: AppColor.white, fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


