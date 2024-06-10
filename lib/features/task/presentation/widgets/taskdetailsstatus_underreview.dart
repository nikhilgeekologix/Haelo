import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/file_pick.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetailsbutton_cubit.dart';
import 'package:haelo_flutter/widgets/gallery_camera_dialog.dart';
import 'package:image_picker/image_picker.dart';

class DetailsStatusUnderReview extends StatefulWidget {
  final data;
  final taskId;

  const DetailsStatusUnderReview(
      {Key? key, required this.data, required this.taskId})
      : super(key: key);

  @override
  State<DetailsStatusUnderReview> createState() =>
      _DetailsStatusUnderReviewState();
}

class _DetailsStatusUnderReviewState extends State<DetailsStatusUnderReview> {
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
                  style: mpHeadLine16(
                      textColor: AppColor.bold_text_color_dark_blue,
                      fontWeight: FontWeight.w500),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Team Reply",
                style: mpHeadLine16(
                    textColor: AppColor.bold_text_color_dark_blue,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: new TextSpan(
                    text: "Answer : ",
                    style: mpHeadLine16(
                        textColor: AppColor.bold_text_color_dark_blue,
                        fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      new TextSpan(
                          text:
                              widget.data != null ? widget.data.teamReply : "",
                          style: mpHeadLine14()),
                    ]),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Documents",
                style: mpHeadLine16(
                    textColor: AppColor.bold_text_color_dark_blue,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 15,top: 8
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      widget.data != null &&
                              widget.data!.teamFile != null &&
                              widget.data!.teamFile!.isNotEmpty
                          ? SizedBox(
                              //used for network
                              height: mediaQH(context) * 0.090,
                              // width: mediaQW(context) * 0.5,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.data!.teamFile!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 12, top: 8),
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
                          : SizedBox(),
                      SizedBox(
                        height: mediaQH(context) * 0.090,
                        // width: mediaQW(context) * 0.5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: imageFileList!.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 12, top: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: imageFileList![index]
                                                .path
                                                .contains("png") ||
                                            imageFileList![index]
                                                .path
                                                .contains("jpg")
                                        ? Image.file(
                                            File(imageFileList![index].path),
                                            // height: 650,
                                            width: 60,
                                            fit: BoxFit.fill,
                                          )
                                        : Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color: Colors.grey.shade400,
                                            ),
                                            child: Icon(
                                              Icons.image,
                                              size: 35,
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                    right: 5,
                                    top: 1,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                    )),
                                Positioned(
                                    right: 5,
                                    top: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imageFileList!.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.red.shade800,
                                      ),
                                    )),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      widget.data != null &&
                              widget.data!.teamFile != null &&
                              widget.data!.teamFile!.length >= 5
                          ? SizedBox()
                          : GestureDetector(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                showDialog(
                                    context: context,
                                    builder: (ctx) => SafeArea(
                                          child: GalleryCameraDialog(
                                              isDoc: true,
                                              is_g_Drive: true,
                                              onClickValue: (isGallery) {
                                                if (isGallery == 4) {
                                                  pickFromGdrive(imgCallBack, context);
                                                } else
                                                if (isGallery == 3) {
                                                  pickDocument(imgCallBack);
                                                } else {
                                                  pickImage(isGallery, context,
                                                      imgCallBack);
                                                }
                                              }),
                                        ));
                              },
                              child: Visibility(
                                visible: isAddImg,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(6),
                                  dashPattern: [10, 10],
                                  color: Colors.grey,
                                  strokeWidth: 2,
                                  child: Container(
                                    height: 55,
                                    width: 55,
                                    child: Icon(
                                      Icons.add,
                                      color: AppColor.hint_color_grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            child: Text(
              "Mark Complete",
              style: mpHeadLine14(textColor: Colors.white),
            ),
            style: ButtonStyle(
                fixedSize:
                    MaterialStateProperty.all(Size(mediaQW(context), 40)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                backgroundColor:
                    MaterialStateProperty.all(AppColor.accepted_color_text)),
            onPressed: () {
              var body = {
                "taskId": widget.taskId.toString(),
                "status": "5",
              };
              if (imageFileList!.isNotEmpty) {
                List<File>? imageFileList1 = [];
                for (int i = 0; i < imageFileList!.length; i++) {
                  File file = File(imageFileList![i].path.toString());
                  imageFileList1.add(file);
                }
                BlocProvider.of<TaskDetailsButtonCubit>(context)
                    .fetchTaskDetailsButton(body, file: imageFileList1);
              } else {
                BlocProvider.of<TaskDetailsButtonCubit>(context)
                    .fetchTaskDetailsButton(body);
              }
            },
          ),
        )
      ],
    );
  }

  void imgCallBack(XFile xfile, bool isDoc) {
    print("gstFile");
    File file = File(xfile.path);
    imageFileList!.add(file);
    if (widget.data!.teamFile != null &&
        imageFileList!.length + widget.data!.teamFile!.length >= 5) {
      isAddImg = false;
    } else if (imageFileList!.length + widget.data!.teamFile!.length >= 5) {
      isAddImg = false;
    }
    setState(() {});
  }
}
