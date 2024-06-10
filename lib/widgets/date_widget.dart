import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class DateWidget extends StatefulWidget {
  final isFromDate;
  final callback;
  final isToDateSelected;
  DateWidget(this.isFromDate, this.callback,
      {this.isToDateSelected = false, Key? key})
      : super(key: key);

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  var currentDate = DateTime.now();
  bool isSecond = false;

  @override
  void initState() {
    print("widget.isToDateSelected ${widget.isToDateSelected}");
    if (widget.isToDateSelected) {
      isSecond = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColor.primary, // <-- SEE HERE
                  onPrimary: Colors.white, // <-- SEE HERE
                  onSurface: Colors.black, // <-- SEE HERE
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                      // primary: AppColor.primary,
                      // button text color
                      ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (newDate != null) {
          currentDate = newDate!;
          widget.callback(newDate, widget.isFromDate);
          if (!widget.isFromDate) {
            isSecond = true;
          }
          setState(() {});
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: mediaQH(context) * 0.035,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        width: mediaQW(context) * 0.45,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: widget.isFromDate
              ? Text(
                  "${currentDate.day}/${currentDate.month}/${currentDate.year}",
                  style: mpHeadLine16(
                      fontWeight: FontWeight.w300, textColor: Colors.black87),
                )
              : Text(
                  !isSecond
                      ? "DD/MM/YYYY"
                      : "${currentDate.day}/${currentDate.month}/${currentDate.year}",
                  style: mpHeadLine16(
                      fontWeight: FontWeight.w300,
                      textColor:
                          isSecond ? AppColor.black : AppColor.hint_color_grey),
                ),
        ),
      ),
    );
  }
}

class AppDatePicker {
  Future<DateTime?> pickDate(
      context, DateTime initDate, DateTime firstDt, DateTime lastDate) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: firstDt,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(),
            ),
          ),
          child: child!,
        );
      },
    );
    return newDate;
  }
}

class AppFromDatePicker {
  Future<DateTime?> pickDate(
      context, DateTime initDate, DateTime firstDt, DateTime lastDate) async {
    DateTime currentDate = DateTime.now();
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: firstDt,
      lastDate: currentDate,
      selectableDayPredicate: (DateTime day) {
        return !day.isAfter(currentDate);
      },
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(),
            ),
          ),
          child: child!,
        );
      },
    );
    return newDate;
  }
}
