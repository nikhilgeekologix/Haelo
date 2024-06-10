import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/file_pick.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/drawer_content/presentation/widgets/textformfield_decoration.dart';
import 'package:haelo_flutter/features/task/cubit/taskdetailsbutton_cubit.dart';
import 'package:haelo_flutter/widgets/gallery_camera_dialog.dart';
import 'package:image_picker/image_picker.dart';

class DetailsStatusAccepted extends StatefulWidget {
  final taskId;
  final reviewImage;
  // final reviewImageCount;
  const DetailsStatusAccepted({
    Key? key,
    this.reviewImage,
    required this.taskId,
  }) : super(key: key);

  @override
  State<DetailsStatusAccepted> createState() => _DetailsStatusAcceptedState();
}

class _DetailsStatusAcceptedState extends State<DetailsStatusAccepted> {
  String noteOneDocuments =
      "1.) If you are concerned with the Privacy of your case options, you can choose Google Drive option.";
  String noteTwoDocuments =
      "2.) Document's maximum allowed file size is 20 mb.";

  bool dottedBox = true;
  var imageUpload;

  final ImagePicker imagePicker = ImagePicker();
  List<File>? imageFileList = [];

  TextEditingController _descriptionController = TextEditingController();
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    ? Icon(
                        Icons.keyboard_arrow_up,
                        size: 25,
                        color: AppColor.bold_text_color_dark_blue,
                      )
                    : Icon(
                        Icons.keyboard_arrow_down,
                        size: 25,
                        color: AppColor.bold_text_color_dark_blue,
                      )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                height: 10,
              ),
              TextFormField(
                controller: _descriptionController,
                textAlignVertical: TextAlignVertical.top,
                minLines: 5,
                maxLines: 10,
                cursorColor: AppColor.primary,
                cursorHeight: 25,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  labelText: "Reply (Optional)",
                  labelStyle: TextStyle(color: Colors.black45),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(width: 1, color: Colors.black),
                  ),
                  disabledBorder: disableboarder,
                  errorBorder: errorboarder,
                  focusedBorder: focusboarder,
                  border: boarder,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Add upto 5 images in jpeg or png format.Maximum allowed file size is 20 mb.",
                style: mpHeadLine12(textColor: AppColor.hint_color_grey),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
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
                                              borderRadius:
                                                  BorderRadius.circular(4),
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
                      // selectImages();
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          showDialog(
                              context: context,
                              builder: (ctx) => SafeArea(
                                    child: GalleryCameraDialog(
                                        isDoc: true,
                                        is_g_Drive: true,
                                        onClickValue: (isGallery) {
                                          if (isGallery == 4) {
                                            pickFromGdrive(
                                                imgCallBack, context);
                                          } else if (isGallery == 3) {
                                            pickDocument(imgCallBack);
                                          } else {
                                            pickImage(isGallery, context,
                                                imgCallBack);
                                          }
                                        }),
                                  ));
                        },
                        child: Visibility(
                          visible: dottedBox,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(6),
                            dashPattern: [10, 10],
                            color: Colors.grey,
                            strokeWidth: 2,
                            child: Container(
                              height: 65,
                              width: 65,
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
              const SizedBox(
                height: 30,
              ),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            child: Text(
              "Submit for Review",
              style: mpHeadLine16(textColor: Colors.white),
            ),
            style: ButtonStyle(
                fixedSize:
                    MaterialStateProperty.all(Size(mediaQW(context), 40)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                backgroundColor:
                    MaterialStateProperty.all(AppColor.hint_color_grey)),
            onPressed: () {
              // if (imageFileList.isNotEmpty) {
              //   imageUpload = imageFileList[0];
              // }

              var body = {
                "taskId": widget.taskId.toString(),
                "status": "4",
                "reply": _descriptionController.text.trim(),
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

    if (imageFileList!.length >= 5) {
      dottedBox = false;
    }
    setState(() {});
  }
}
