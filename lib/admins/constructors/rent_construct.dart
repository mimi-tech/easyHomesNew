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

class RentConstruct extends StatefulWidget {
  RentConstruct({required this.items, required this.re, required this.index});
  final List <dynamic> items;
  final List <dynamic> re;
  final int index;
  @override
  _RentConstructState createState() => _RentConstructState();
}

class _RentConstructState extends State<RentConstruct> {
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
              header:AdminHeader(title: '${widget.items[widget.index]['fn']} ${widget.items[widget.index]['ln']} cylinder Rent',),


   content: ListView.builder(
    physics: BouncingScrollPhysics(),
    shrinkWrap: true,
    itemCount: widget.re.length,
    itemBuilder: (context, int index) {
      var diffDt = DateTime.parse(widget.re[index]['dt']).difference(DateTime.now()); // 249:59:59.999000

      print(diffDt.inDays);
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
                      VendorPix(pix:widget.re[index]['vpi'] ,pixColor: Colors.transparent,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                            name: widget.re[index]['vfn'],
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.w500,
                          ),

                          TextWidget(
                            name: widget.re[index]['vln'],
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.w500,
                          ),



                          GestureDetector(
                            onTap:() async {
                              var url = "tel:${widget.re[index]['vph']}";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },

                            child: TextWidget(
                              name: widget.re[index]['vph'],
                              textColor: kDoneColor,
                              textSize: kFontSize,
                              textWeight: FontWeight.w500,
                            ),
                          ),

                           TextWidget(
                            name: DateFormat('EEEE d MMM, yyyy').format(DateTime.parse(widget.re[index]['dt'])),
                            textColor: kDarkRedColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.w500,
                          ),
                        ],
                      ),


                      Spacer(),

                      // ignore: unrelated_type_equality_checks
                     diffDt.inDays >= 31?


                           Column(
                    children: [
                      NewBtn(nextFunction: (){}, bgColor: kYellow, title: 'Exp'),

                      IconButton(icon: Icon(Icons.verified,color: kGreenColor,), onPressed: (){})


                    ],
                  ):
                      IconButton(icon: Icon(Icons.verified,color: kGreenColor,), onPressed: (){_verifyReturn(index);})

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

  void _verifyReturn(int index) {

    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'Verify Cylinder Return'.toUpperCase(),

          contentText: 'Are you sure that ${widget.items[0]['fn']} ${widget.items[0]['ln']} have returned your cylinder?',
          actions: [
            NewBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kRadioColor, title: 'No'),

            NewBtn(nextFunction: (){_returnCylinder(index);}, bgColor: kDoneColor, title: 'Yes')

          ],

          onPositiveClick: () {
            Navigator.of(context).pop();
          },
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
        );
      },
      animationType: DialogTransitionType.slideFromRightFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  void _returnCylinder(int index) {
     Navigator.pop(context);

try{
  BotToast.showLoading(duration: Duration(seconds: 4));
setState(() {
  widget.re.removeAt(index);

});
  FirebaseFirestore.instance.collection
('rent').doc(widget.items[0]['ud']).set({
  're':widget.re,
  }, SetOptions(merge: true)).whenComplete((){
    BotToast.showSimpleNotification(title: "verified successfully",
        duration: Duration(seconds: 5),
        titleStyle:TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil()
              .setSp(kFontSize, ),
          color: kGreenColor,
        )

    );
  });


}catch(e){
VariablesOne.notifyFlutterToastError(title: kError);
}
  }
}
