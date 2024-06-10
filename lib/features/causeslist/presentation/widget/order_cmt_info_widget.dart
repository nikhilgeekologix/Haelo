import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/order_comment_history/data/model/WatchlistDataType.dart';
import 'package:haelo_flutter/features/order_comment_history/presentation/screen/orderCommentHistory.dart';
import 'package:haelo_flutter/features/order_comment_history/presentation/screen/order_cmt_history_test.dart';

class OrderCmtInfo extends StatelessWidget {
  WatchListDataType? selectedLawyer;
  bool isFromCmt;
  OrderCmtInfo({this.selectedLawyer,this.isFromCmt=false,super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){
            // Navigator.pop(context);// for dialog closing
            // print("isFromCmt $isFromCmt");
            //
            // if(isFromCmt){
            //   // Navigator.pop(context);
            //   Navigator.pop(context);
            //   Navigator.pop(context);
            // }else{
            //  // Navigator.pop(context);
            //
            // }
            // Navigator.pop(context);


            goToPage(context,
                OrderCmtHistory4(selectedLawyer: selectedLawyer,));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.primary,),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primary.withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 3,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            margin: EdgeInsets.only(left: 12,bottom: 23),
            child: Row(mainAxisSize: MainAxisSize.min,
              children: [
                Text("View Order Comment History",
                style: appTextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13
                )),
                SizedBox(width: 15,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cancel_outlined,
                  size: 18,color: AppColor.rejected_color_text),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
