import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class DriveFileCard extends StatelessWidget {
  final int index;
  final FileList fileList;
  const DriveFileCard(this.index, this.fileList, {super.key});

  @override
  Widget build(BuildContext context) {
    print("mimeType >> ${ fileList.files!.toList()[index].mimeType!}");
    return Container(
      height: mediaQH(context)/5,
      width: mediaQW(context)/2.5,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          fileList.files!.toList()[index].mimeType!.contains(".folder")?
              Icon(Icons.folder,
              size: mediaQH(context)/5-60,):
          Container(
            height: mediaQH(context)/5-60,
            width: mediaQW(context)/2.5,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.hint_color_grey,
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child:

            fileList.files!.toList()[index].mimeType=='image/jpeg'||
            fileList.files!.toList()[index].mimeType=='image/png'||
            fileList.files!.toList()[index].mimeType=='image/jpg'
                ?
            Icon(Icons.image, size: mediaQH(context)/5-80,
              color: AppColor.hint_color_grey,):
            fileList.files!.toList()[index].mimeType=='application/pdf'?
            Icon(Icons.picture_as_pdf, size: mediaQH(context)/5-80,
              color: AppColor.hint_color_grey,):
            Icon(Icons.description, size: mediaQH(context)/5-80,
              color: AppColor.hint_color_grey,),
          ),
          Text(
            fileList.files!.toList()[index].name!,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
