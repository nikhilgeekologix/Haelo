import 'package:flutter/material.dart';
import 'package:haelo_flutter/constants.dart';
import 'package:haelo_flutter/core/utils/functions.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

class ViewDocuments extends StatefulWidget {
  final imgData;
  int index;
  String caseNo;

  ViewDocuments(this.imgData, this.index,this.caseNo, {Key? key}) : super(key: key);

  @override
  _ViewDocumentsState createState() => _ViewDocumentsState();
}

class _ViewDocumentsState extends State<ViewDocuments> {
  int index = 0;

  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 24,
          ),
        ),
        titleSpacing: -5,
        title: Text(
          widget.imgData![index].documentName.toString().split("/").last,
          style: mpHeadLine14(
              fontWeight: FontWeight.w500,
              textColor: AppColor.bold_text_color_dark_blue),
        ),
        actions: [
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () async {
              DateTime now=DateTime.now();
              var fileName = "HAeLO_Case${widget.caseNo}${widget.imgData![index].caseYear}${now.millisecondsSinceEpoch}.${widget.imgData![index].documentName.toString()
                  .split(".").last}";
              await downloadFiles(
                  widget.imgData![index].documentName.toString(),
                  fileName);
            },
            child: const Icon(
              Icons.download,
              size: 25,
              color: AppColor.bold_text_color_dark_blue,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              goToHomePage(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.home_outlined,
                size: 30,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: widget.imgData![index].documentName.split(".").last ==
                        ("jpg") ||
                    widget.imgData![index].documentName.split(".").last ==
                        ("png")
                ? Image(
                    fit: BoxFit.fill,
                    image: NetworkToFileImage(
                      url: widget.imgData![index].documentName.toString(),
                      // mediaType: 'image',
                    ),
                  )
                : widget.imgData![index].documentName.split(".").last ==
                        ("xlsx")
                    ? Image.asset(
              ImageConstant.xlsx,
                        height: 100,
                      )
                    : Image.asset(
              ImageConstant.pdf,
                        height: 100,
                      ),
          )),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            width: mediaQW(context),
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (index > 0) {
                      setState(() {
                        index--;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Text(
                  "${index + 1} / " + widget.imgData!.length.toString(),
                  style: mpHeadLine16(),
                ),
                SizedBox(
                  width: 50,
                ),
                InkWell(
                  onTap: () {
                    if (index < widget.imgData.length - 1) {
                      setState(() {
                        index++;
                      });
                    }
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.arrow_forward_ios)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
