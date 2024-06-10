import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class AppYearPicker extends StatefulWidget {
  final callback;
  String lastSelectedYear;

  AppYearPicker({this.callback, this.lastSelectedYear = "", Key? key})
      : super(key: key);

  @override
  _AppYearPickerState createState() => _AppYearPickerState();
}

class _AppYearPickerState extends State<AppYearPicker> {
  int currentYear = DateTime.now().year;

  @override
  void initState() {
    if (widget.lastSelectedYear.isNotEmpty) {
      currentYear = int.parse(widget.lastSelectedYear);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(1)),
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.only(bottom: 20),
          constraints: BoxConstraints(maxHeight: mediaQH(context) * 0.5),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                      width: mediaQW(context),
                      decoration: BoxDecoration(color: AppColor.primary),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: Text(
                        '$currentYear',
                        style: appTextStyle(
                            fontSize: 25,
                            textColor: AppColor.white,
                            fontWeight: FontWeight.w600),
                      )),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(
                        123,
                        (index) => InkWell(
                          onTap: () {
                            setState(() {
                              currentYear = (DateTime.now().year - index);
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  (DateTime.now().year - index).toString(),
                                  style: appTextStyle(
                                      fontSize: 22,
                                      textColor: DateTime.now().year - index ==
                                              currentYear
                                          ? AppColor.primary
                                          : AppColor.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "CANCEL",
                      style: appTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: AppColor.primary),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      widget.callback(currentYear.toString());
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: appTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: AppColor.primary),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
