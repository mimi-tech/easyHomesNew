import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<TimeOfDay> ?_selectTime(BuildContext context,
    {required DateTime initialDate}) {
  final now = DateTime.now();

   showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: initialDate.hour, minute: initialDate.minute),
  );
}

_selectDateTime(BuildContext context,
    {required DateTime initialDate}) {
  final now = DateTime.now();
  final newestDate = initialDate.isAfter(now) ? initialDate : now;

  return showDatePicker(
    context: context,
    initialDate: newestDate.add(Duration(seconds: 1)),
    firstDate: now,
    lastDate: DateTime(2100),
  );
}

Dialog? showDateTimeDialog(
    BuildContext context, {
      required ValueChanged<DateTime> onSelectedDate,
      required DateTime initialDate,
    }) {
  final dialog = Platform.isIOS?
  CupertinoAlertDialog(
      //title: Text("Warning"),
      content:DateTimeDialog(
          onSelectedDate: onSelectedDate, initialDate: initialDate),

    actions: <Widget>[
      CupertinoDialogAction(
        child: TextWidget(
          name: kCancel,
          textColor: kRedColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w600,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      CupertinoDialogAction(
        child: TextWidget(
          name: 'Schedule',
          textColor: kDarkBlue,
          textSize: kFontSize14,
          textWeight: FontWeight.w600,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        isDestructiveAction: true,
      ),
    ],
  )
      :Dialog(
    child: DateTimeDialog(
        onSelectedDate: onSelectedDate, initialDate: initialDate),
  );

  Platform.isIOS?
  showCupertinoDialog(context: context, builder: (BuildContext context) => dialog)
      :showDialog(context: context, builder: (BuildContext context) => dialog);
}

class DateTimeDialog extends StatefulWidget {
  final ValueChanged<DateTime> onSelectedDate;
  final DateTime initialDate;

  const DateTimeDialog({
    required this.onSelectedDate,
    required this.initialDate,
    /*for the time*/


  }) ;
  @override
  _DateTimeDialogState createState() => _DateTimeDialogState();
}

class _DateTimeDialogState extends State<DateTimeDialog> {
 late  DateTime selectedDate;
  @override
  void initState() {
    super.initState();

    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(2),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextWidget(
          name: 'Select date & time',
          textColor: kTextColor,
          textSize: kFontSize,
          textWeight: FontWeight.w600,
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ElevatedButton(
              child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
              onPressed: () async {


                var date = await _selectDateTime(context, initialDate: selectedDate);

                if (date == null) return;

                setState(() {
                  selectedDate = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    selectedDate.hour,
                    selectedDate.minute,
                  );

                });

                widget.onSelectedDate(selectedDate);
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(

              child: Text(DateFormat('hh:mm:a').format(selectedDate)),
              onPressed: () async {

                final time =
                await _selectTime(context, initialDate: selectedDate);
                if (time == null) return;

                setState(() {
                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    time.hour,
                    time.minute,

                  );


                });

                widget.onSelectedDate(selectedDate);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Platform.isIOS? Text('')
            // CupertinoButton(
            //     color: kDarkBlue,
            //     child: TextWidget(
            //       name: 'Schedule',
            //       textColor: kWhiteColor,
            //       textSize: kFontSize14,
            //       textWeight: FontWeight.w600,
            //     ),
            //
            //     onPressed:() => Navigator.of(context).pop())
            :ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kDarkBlue)
          ),
          child: TextWidget(
            name: 'Schedule',
            textColor: kWhiteColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w600,
          ),
          onPressed: () {

            Navigator.of(context).pop();
          },

        ),
      ],
    ),
  );
}