import 'package:flutter/material.dart';

import '../core/utils/ui_helper.dart';

typedef ChildCustomCallback = void Function(int docNum);

class GalleryCameraDialog extends StatefulWidget {
  final ChildCustomCallback onClickValue;
  bool isDoc;
  bool is_g_Drive;

  GalleryCameraDialog(
      {required this.onClickValue,
      this.isDoc = false,
      this.is_g_Drive = false});

  @override
  _GalleryCameraDialogState createState() => _GalleryCameraDialogState();
}

class _GalleryCameraDialogState extends State<GalleryCameraDialog> {
  String noteTwoDocuments =
      "2.) If you are concerned with the Privacy of your case options, you can choose Google Drive option.";
  String noteOneDocuments = "1.) Document's maximum allowed file size is 5 mb.";

  var style = mpHeadLine16(
      textColor: AppColor.bold_text_color_dark_blue,
      fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            // constraints: BoxConstraints(maxHeight: mediaQH(context) * 0.5),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // _pickImage(true);
                    widget.onClickValue(1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      'Camera',
                      style: style,
                    ),
                  ),
                ),
                const Divider(
                  height: 1.5,
                  thickness: 1.5,
                  color: AppColor.grey_color,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onClickValue(2);
                      // _pickImage(false);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Gallery',
                        style: style,
                      ),
                    )),
                Visibility(
                  visible: widget.isDoc,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // _pickImage(true);
                      widget.onClickValue(3);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          height: 1.5,
                          thickness: 1.5,
                          color: AppColor.grey_color,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            'Document',
                            style: style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.is_g_Drive,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        height: 1.5,
                        thickness: 1.5,
                        color: AppColor.grey_color,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          // _pickImage(true);
                          widget.onClickValue(4);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            'Google Drive',
                            style: style,
                          ),
                        ),
                      ),

                      // const SizedBox(
                      //   height: 8,
                      // ),
                      // Padding(
                      //   padding:
                      //   const EdgeInsets.only(left: 10, right: 5),
                      //   child: Text(
                      //     noteTwoDocuments,
                      //     style: mpHeadLine12(
                      //         textColor: Colors.red.shade800,
                      //     fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1.5,
                  thickness: 1.5,
                  color: AppColor.grey_color,
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Note:",
                    style: mpHeadLine10(
                        textColor: Colors.red.shade800,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    child: Text(
                      noteOneDocuments,
                      style: mpHeadLine12(
                          textColor: Colors.red.shade800,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Visibility(
                  visible: widget.is_g_Drive,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    child: Text(
                      noteTwoDocuments,
                      style: mpHeadLine12(
                          textColor: Colors.red.shade800,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
