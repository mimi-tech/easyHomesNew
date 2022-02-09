import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/utils/read_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';

class AllRentConstruct extends StatefulWidget {
  AllRentConstruct({required this.re,});
  final List <dynamic> re;

  @override
  _AllRentConstructState createState() => _AllRentConstructState();
}

class _AllRentConstructState extends State<AllRentConstruct> {
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                space(),
                space(),
                StickyHeader(
                    header:AdminHeader(title: 'cylinder(s) Rent',),


                    content: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.re.length,
                        itemBuilder: (context, int index) {
                          var diffDt = DateTime.parse(widget.re[index]['dt']).difference(DateTime.now()); // 249:59:59.999000

                          return Card(
                            elevation: kEle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  AnimationSlide(title:Text('Customer Address',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.oxanium(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil()
                                          .setSp(kFontSize, ),
                                      color: kDoneColor,
                                    ),
                                  )),
                                  ReadMoreTextConstruct(title: widget.re[index]['ad'], colorText: kLightBrown),

                                  Row(

                                    children: <Widget>[
                                      TextWidget(
                                        name: DateFormat('EEEE d MMM, yyyy').format(DateTime.parse(widget.re[index]['dt'])),
                                        textColor: kDarkRedColor,
                                        textSize: kFontSize,
                                        textWeight: FontWeight.w500,
                                      ),


                                      Spacer(),

                                      // ignore: unrelated_type_equality_checks
                                      diffDt.inDays >= 31?
                                      NewBtn(nextFunction: (){}, bgColor: kYellow, title: 'Exp')

                          :   NewBtn(nextFunction: (){}, bgColor: kGreen, title: 'Active'),


                          ],
                                  ),
                                  Divider(),
                                  AnimationSlide(title:Text('Gas station',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.oxanium(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil()
                                          .setSp(kFontSize, ),
                                      color: kDoneColor,
                                    ),
                                  )),
                                  ReadMoreTextConstruct(title: widget.re[index]['cm'], colorText: kLightDoneColor),

                                  space(),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          TextWidget(
                                            name: 'Cylinder(s)',
                                            textColor: kRadioColor,
                                            textSize: kFontSize14,
                                            textWeight: FontWeight.w500,
                                          ),

                                          TextWidget(
                                            name: '${widget.re[index]['cKG']} kg'.toString(),
                                            textColor: kTextColor,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.w500,
                                          ),

                                        ],
                                      ),


                                      Column(
                                        children: [
                                          TextWidget(
                                            name: 'Amount',
                                            textColor: kRadioColor,
                                            textSize: kFontSize14,
                                            textWeight: FontWeight.w500,
                                          ),

                                          MoneyFormatColors(title: TextWidget(
                                            name: VariablesOne.numberFormat.format(widget.re[index]['pz']).toString(),
                                            textColor: kSeaGreen,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.w500,
                                          ),  color: kSeaGreen)

                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          );

                        })),

                space(),
                space(),

                NewBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kDoneColor,title: 'Close',)

              ],
            ),
          ),
        ),
      ),
    );
  }


}
