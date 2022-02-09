

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:uuid/uuid.dart';

class BusinessRestKey extends StatefulWidget {
  BusinessRestKey({required this.userUid});
  final String userUid;

  @override
  _BusinessRestKeyState createState() => _BusinessRestKeyState();
}

class _BusinessRestKeyState extends State<BusinessRestKey> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }


  String? bizName;
  Color btnColor = kLightBrown;
  bool activateVisible = true;
  bool closeVisible = false;
  int i = 0;
  var v1 = '';
  bool progressbar = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
          child: Column(
            children: <Widget>[

              spacer(),
              Center(child: SvgPicture.asset('assets/imagesFolder/unlock.svg',
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.height * 0.08,
              )),
              spacer(),
              TextWidgetAlign(name: kGeneratePin,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w600,),
             spacer(),
              spacer(),

              Row(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ScreenUtil()
                          .setWidth(250),
                      minHeight: ScreenUtil()
                          .setHeight(10),
                    ),
                    child: ReadMoreText(
                      v1,
                      trimLines: 2,
                      colorClickableText:kDoneColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' ...',
                      trimExpandedText: 'show less',

                      style:GoogleFonts.oxanium(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(kFontSize, ),
                        color: kTextColor,
                      ),
                    ),
                  ),

                  v1 == ''?Text(''): GestureDetector(
                      onTap: (){Clipboard.setData( ClipboardData(
                          text:v1));

                      setState(() {
                        i++;
                      });
                      Fluttertoast.showToast(
                          msg: 'Copied',
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: kRadioColor,
                          textColor: kWhiteColor);
                      },

                      child: Icon(Icons.content_copy)),

                ],
              ),

              DividerLine(),



              v1 == ''? BtnThird(title: 'Generate Admin Pin', nextFunction: () {generate();}, bgColor: btnColor,):

              progressbar ==true?PlatformCircularProgressIndicator():Visibility(
                  visible: activateVisible,
                  child: BtnThird(title: 'Activate', nextFunction: () {save();}, bgColor: kDoneColor,)),

              Visibility(visible:closeVisible,child: BtnThird(title: 'Close', nextFunction: () {close();}, bgColor: kRedColor,)),

              spacer(),

            ],
          ),
        ),
      ),
    );
  }

  void generate() {
    var uuid = Uuid();
    v1 = uuid.v1();
    setState(() {
      btnColor = kTextFieldBorderColor;
    });
  }

  void save() {

    setState(() {
      progressbar = true;
    });
    /*saving the key to database*/

    try {
      /* int timestamp = 1586348737122;
        var date = DateTime.fromMillisecondsSinceEpoch(timestamp);*/
      var now = DateTime.now();
      FirebaseFirestore.instance.collection
('userReg')
          .doc(widget.userUid.trim())
          .set({
        'pi': v1.trim(),
      },SetOptions(merge: true));


      setState(() {
        progressbar = false;
        activateVisible = false;
        closeVisible = true;
      });

    }catch (e){
      setState(() {
        progressbar = false;
      });
      print(e.toString());
    VariablesOne.notifyFlutterToastError(title: kError);
    }
  }


  void close() {
    //check if the link have been copied
    if(i <= 0){
      Fluttertoast.showToast(
          msg: 'Please copy this code',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);
    }else{

      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Saved successfully',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);



    }


  }
}
