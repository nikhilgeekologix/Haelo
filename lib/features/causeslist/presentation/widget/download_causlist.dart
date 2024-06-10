import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/save_file.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_cubit.dart';
import 'package:haelo_flutter/features/cases/cubit/mycases_state.dart';
import 'package:haelo_flutter/features/causeslist/cubit/viewcauselist_cubit.dart';
import 'package:haelo_flutter/widgets/date_format.dart';
import 'package:haelo_flutter/locators.dart' as di;

class DownloadCauselist extends StatefulWidget {
  final param;
  BuildContext? ctx;
  DownloadCauselist(this.param, this.ctx, {Key? key}) : super(key: key);

  @override
  State<DownloadCauselist> createState() => _DownloadCauselistState();
}

class _DownloadCauselistState extends State<DownloadCauselist> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ViewCauseListCubit>(
            create: (BuildContext context) => ViewCauseListCubit(di.locator())),
      ],
      child: Builder(builder: (context) {
        return DownloadCauseList(widget.param, context);
      }),
    );
  }
}

class DownloadCauseList extends StatelessWidget {
  final param;
  BuildContext? ctx;
  bool isOnlyExcel;
  final VoidCallback? onPDFPressed;
  final VoidCallback? onGoogleDrivePressed;
  final VoidCallback? onExcelPressed;
  // final dateSelectCallback;
  DownloadCauseList(this.param, this.ctx,
      {this.isOnlyExcel = false,
      this.onPDFPressed,
      this.onGoogleDrivePressed,
      this.onExcelPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3),
              bottomLeft: Radius.circular(3),
            ),
          ),
          margin: EdgeInsets.fromLTRB(20, 40, 0, 5),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          width: mediaQW(context) * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !isOnlyExcel
                  ? InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onPDFPressed?.call();
                        // showPdfOptionDialog(context, ctx!, "PDF");
                      },
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "PDF",
                          style: mpHeadLine14(),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: !isOnlyExcel ? 2 : 1,
              ),
              !isOnlyExcel
                  ? SizedBox(
                      width: mediaQW(context) * 0.45,
                      child: const Divider(
                        thickness: 1,
                        color: AppColor.grey_color,
                      ),
                    )
                  : SizedBox(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onGoogleDrivePressed?.call();
                  // showPdfOptionDialog(context, ctx!, "GoogleDrive");
                },
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Google Drive",
                        style: mpHeadLine14(),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Save PDF to Google Drive",
                        style: TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              !isOnlyExcel
                  ? SizedBox(
                      width: mediaQW(context) * 0.45,
                      child: const Divider(
                        thickness: 1,
                        color: AppColor.grey_color,
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 2,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onExcelPressed?.call();
                  // var body = {
                  //   "downloadFile": "excel"
                  // };
                  /*  param['downloadFile'] = "excel";
                  Navigator.pop(context);
                  ctx!
                      .read<ViewCauseListCubit>()
                      .fetchViewCauseList(param, "3.2");*/
                },
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Excel",
                    style: mpHeadLine14(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
/*void showPdfOptionDialog(
      BuildContext context, BuildContext cont, String type) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            // insetPadding: EdgeInsets.symmetric(vertical: 305),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              // height: mediaQH(context) * 0.16,
              // width: mediaQW(context) * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: Text(
                      "You want to download pdf with with Petitioner",
                      textAlign: TextAlign.center,
                      style: mpHeadLine14(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            print("ok");
                            param['downloadFile'] = "pdf";
                            param['isLawyer'] = "false";

                            // Navigator.pop(context);
                            Navigator.pop(ctx, type);
                            cont
                                .read<ViewCauseListCubit>()
                                .fetchViewCauseList(param, "3.1");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(5)),
                                border: Border.all(color: AppColor.primary)),
                            child: Text(
                              "Yes",
                              style: mpHeadLine16(textColor: AppColor.primary),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            print("ok");
                            param['downloadFile'] = "pdf";
                            // Navigator.pop(context);
                            Navigator.pop(ctx, type);
                            cont
                                .read<ViewCauseListCubit>()
                                .fetchViewCauseList(param, "3.1");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: mediaQH(context) * 0.05,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5)),
                              color: AppColor.primary,
                            ),
                            child: Text(
                              "No",
                              style: mpHeadLine16(textColor: AppColor.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }).then((value) {
      if (value != null) {
        print("Type value: $value");
      }
    });
  }*/
