

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/services.dart';
import 'package:easy_homes/reg/constants/variables.dart';
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

class SecGenerateKey extends StatefulWidget {
  SecGenerateKey({required this.userUid,required this.firstName,required this.lastName,required this.email});
  final String userUid;
  final String firstName;
  final String lastName;
  final String email;

  @override
  _SecGenerateKeyState createState() => _SecGenerateKeyState();
}

class _SecGenerateKeyState extends State<SecGenerateKey> {
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
          height: MediaQuery.of(context).size.height * 0.45,
          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
          child: Column(
            children: <Widget>[

              spacer(),
              Center(child: SvgPicture.asset('assets/imagesFolder/unlock.svg',
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.height * 0.08,
              )),
              spacer(),
              TextWidgetAlign(name: closeVisible?"$kGeneratePin2 ${widget.firstName} ${widget.lastName}":kGeneratePin,
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
print(AdminConstants.bizName!.trim());

      try {
        /* int timestamp = 1586348737122;
        var date = DateTime.fromMillisecondsSinceEpoch(timestamp);*/

        var now = DateTime.now();
        FirebaseFirestore.instance.collection('userReg')
            .doc(widget.userUid.trim())
            .set({
          'pi': v1.trim(),
          'create':false,
          'biz':  AdminConstants.bizName!.trim(),
          'cat': AdminConstants.businessType,
          'ts': now.toString(),
          'ouid':Variables.userUid,
          'ct':AdminConstants.category,//admin category type
          'outId':AdminConstants.companyCollection[0]['id']


        },SetOptions(merge: true));
        /*update the user no of admin created by adding 1*/


        FirebaseFirestore.instance.collection('userReg')
            .doc(Variables.userUid)
            .set({
          'ano': AdminConstants.noAdminCreated  + 1,

        },SetOptions(merge: true));
          setState(() {
            progressbar = false;
            activateVisible = false;
            closeVisible = true;
          });

          //send the pin to the user email
        Services.sendMail(
            email: widget.email,
            message: "<h2 style='color:orange;'>$kCompanyNames</h2>\n<p style='colors:LightGray;font-size:12px;'>You have been made an admin to ${Variables.currentUser[0]['biz']}. Please use this key to unlock your new role. Thank you. </p><p><strong style='color:darkBlue;'><h3>${v1.trim()}</h3></strong></p>",
            subject: "${Variables.currentUser[0]['biz']} Admin"
        );

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
