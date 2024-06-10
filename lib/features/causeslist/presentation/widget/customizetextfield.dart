import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class CustomContainer extends StatefulWidget {
  final displayData;
  final width;
  final isDropDown;
  final isClose;
  final closeIconCallback;
  final closeState;
  const CustomContainer({Key? key, this.displayData, this.width,
    this.isDropDown=true, this.isClose=false,
  this.closeIconCallback, this.closeState}) : super(key: key);

  @override
  State<CustomContainer> createState() => _CustomContainerState(this.displayData);
}

class _CustomContainerState extends State<CustomContainer> {
  String displayData = "Select";
  _CustomContainerState(this.displayData);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: mediaQH(context) * 0.045),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      width: widget.width??mediaQW(context) * 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 5, top: 4, bottom: 4),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
             // width: mediaQW(context) * 0.8,
              child: Text(
                widget.displayData,
                style: mpHeadLine14(textColor: Colors.black),
              ),
            ),
            widget.isDropDown?const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: AppColor.primary,
              size: 18,
            ):SizedBox() ,
            widget.isClose?InkWell(
              onTap: (){
                widget.closeIconCallback(widget.closeState);
              },
              child: const Icon(
                Icons.close,
                color: AppColor.rejected_color_text,
                size: 18,
              ),
            ):SizedBox()
          ],
        ),
      ),
    );
  }
}
