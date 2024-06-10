import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/file_pick.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetailsbutton_cubit.dart';
import 'package:haelo_flutter/widgets/gallery_camera_dialog.dart';
import 'package:image_picker/image_picker.dart';

class TaskCompleted extends StatefulWidget {
  final data;
  final taskId;
  const TaskCompleted({Key? key, required this.data, required this.taskId}) : super(key: key);

  @override
  State<TaskCompleted> createState() => _DetailsStatusUnderReviewState();
}

class _DetailsStatusUnderReviewState extends State<TaskCompleted> {
  bool isOpen = false;
  bool isAddImg = true;
  List<File>? imageFileList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15, bottom: 35),
          child: InkWell(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Additional Data",
                  style: mpHeadLine16(textColor: AppColor.bold_text_color_dark_blue, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 10,
                ),
                isOpen
                    ? const Icon(
                  Icons.keyboard_arrow_up,
                  size: 25,
                  color: AppColor.bold_text_color_dark_blue,
                )
                    : const Icon(
                  Icons.keyboard_arrow_down,
                  size: 25,
                  color: AppColor.bold_text_color_dark_blue,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Visibility(
            visible: isOpen,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Team Reply",
                style: mpHeadLine16(textColor: AppColor.bold_text_color_dark_blue,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: new TextSpan(
                    text: "Answer : ",
                    style: mpHeadLine16(textColor: AppColor.bold_text_color_dark_blue, fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      new TextSpan(
                          text: widget.data!=null?widget.data.teamReply:"",
                          style:
                          mpHeadLine14()),
                    ]),
              ),
              const SizedBox(
                height: 15,
              ),
              widget.data!=null &&
                  widget.data!.teamFile!=null &&
                  widget.data!.teamFile!.isNotEmpty?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Documents",
                    style: mpHeadLine16(textColor: AppColor.bold_text_color_dark_blue,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [

                          SizedBox(//used for network
                            height: mediaQH(context) * 0.090,
                            // width: mediaQW(context) * 0.5,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.data!.teamFile!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12, top: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      widget.data!.teamFile![index],
                                      // height: 650,
                                      width: mediaQW(context) * 0.2,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ):SizedBox(),

            ]),
          ),
        ),
        SizedBox(height: 20,),
      ],
    );
  }

  void imgCallBack(XFile xfile, bool isDoc) {
    print("gstFile");
    File file=File(xfile.path);
    imageFileList!.add(file);
    if(widget.data!.teamFile!=null && imageFileList!.length + widget.data!.teamFile!.length >= 5){
      isAddImg = false;
    }
    else
    if (imageFileList!.length + widget.data!.teamFile!.length >= 5) {
      isAddImg = false;
    }
    setState(() {});
  }

}
