import 'package:flutter/material.dart';
import 'package:haelo_flutter/core/utils/ui_helper.dart';

class CauseListCalendar extends StatefulWidget {
  final bool isToDate;
  final selectedDate;
  final currentDate;
  final setDate;
  final bool smallWidth;
  bool setDateFormat;
  final defaultValue;
  final fromDateForDisable;
  CauseListCalendar({
    Key? key,
    required this.selectedDate,
    required this.currentDate,
    this.isToDate = false,
    required this.setDate,
    this.smallWidth = false,
    this.setDateFormat = false,
    this.defaultValue,this.fromDateForDisable
  }) : super(key: key);

  @override
  State<CauseListCalendar> createState() => _CauseListCalendarState(this.selectedDate, this.currentDate);
}

class _CauseListCalendarState extends State<CauseListCalendar> {
  var selectedDate;
  var currentDate;
  _CauseListCalendarState(this.selectedDate, this.currentDate);

  bool isDateSelected=false;

  @override
  void initState() {
   // print("dateFrom ${widget.fromDateForDisable}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.defaultValue == null) {
      currentDate = DateTime.now();
    }
    return InkWell(
      onTap: () async {
        selectedDate = true;
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: widget.currentDate,
          firstDate: DateTime(1900),
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
        if (newDate == null) return;
        setState(() {
          widget.setDateFormat = true;
          isDateSelected = true;
          currentDate = newDate;
          widget.setDate(newDate, !widget.isToDate);
          print("new date ${currentDate.day}");
          print("new widget.setDateFormat ${widget.setDateFormat}");
        });
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: mediaQH(context) * 0.035,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        width: widget.smallWidth ? mediaQW(context) * 0.4 : mediaQW(context) * 0.45,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: widget.isToDate
              ? Text(
                  !isDateSelected && currentDate==null ? "DD/MM/YYYY" : "${currentDate.day}/${currentDate.month}/${currentDate.year}",
                  style: mpHeadLine16(fontWeight: FontWeight.w300, textColor: Colors.black87),
                )
              : Text(
                  "${currentDate.day}/${currentDate.month}/${currentDate.year}",
                  style: mpHeadLine16(fontWeight: FontWeight.w300),
                ),
        ),
      ),
    );
  }
}