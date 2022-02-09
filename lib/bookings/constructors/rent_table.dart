import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RentTable extends StatefulWidget {
  RentTable({required this.num,required this.month,required this.rent});
  final String num;
  final String month;
  final String rent;
  @override
  _RentTableState createState() => _RentTableState();
}

class _RentTableState extends State<RentTable> {
  double heights = 40.0;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: <Widget>[
          Container(

            margin:EdgeInsets.symmetric(horizontal: 70),
            child: Table(
              columnWidths: {0: FractionColumnWidth(.2), 1: FractionColumnWidth(.4), 2: FractionColumnWidth(.4)},

             // defaultColumnWidth: FixedColumnWidth(30.0),
              border: TableBorder.all(
                  color: kRadioColor,
                  style: BorderStyle.solid,
                  width: 1),
              children: [
                TableRow(
                    children: [

                  SizedBox(
                      height:heights,
                      child: TableText(title: 'Num',)),
                  SizedBox(
                      height:heights,
                      child: TableText(title: 'Month',)),
                  SizedBox(
                      height:heights,
                      child: TableText(title: 'Rent',)),
                ]),
                TableRow( children: [
                  SizedBox(
                      height:heights,
                      child: TableTextSecond(title: widget.num,)),
                  SizedBox(
                      height:heights,
                      child: TableTextSecond(title: widget.month,)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/imagesFolder/sy.svg',height: 15, width: 15,),
                      SizedBox(width: 2,),
                      SizedBox(
                          height:heights,
                          child: TableTextSecond(title: widget.rent,))]),


                ]),

              ],
            ),
          ),
        ])
    );

  }
}


class TableText extends StatelessWidget {
  TableText({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidget(
        name: title.toUpperCase(),
        // AdminConstants.bizName!.toUpperCase(),
        textColor: kDoneColor,
        textSize: kFontSize14,
        textWeight: FontWeight.normal,
      ),
    );

  }
}

class TableTextSecond extends StatelessWidget {
  TableTextSecond({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidget(
        name: title.toUpperCase(),
        // AdminConstants.bizName!.toUpperCase(),
        textColor: kTextColor,
        textSize: kFontSize14,
        textWeight: FontWeight.normal,
      ),
    );

  }
}
