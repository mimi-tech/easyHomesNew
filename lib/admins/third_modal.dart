import 'dart:io';
import 'package:easy_homes/reg/constants/services.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
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

class ThirdModal extends StatefulWidget {
  ThirdModal({required this.userUid, required this.doc});

  final String userUid;
  final DocumentSnapshot doc;

  @override
  _ThirdModalState createState() => _ThirdModalState();
}

class _ThirdModalState extends State<ThirdModal> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  TextEditingController _bizName = TextEditingController();
  String? bizName;
  Color btnColor = kTextFieldBorderColor;

  bool activateVisible = true;
  bool closeVisible = false;
  int i = 0;
  var v1 = '';
  bool sends = false;
  int? selectedRadio;
  bool soSure = true;
  bool progressbar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      sends = false;
    });
    selectedRadio = 1;

    if (widget.doc['biz'] == null) {
    } else {
      setState(() {
        _bizName.text = widget.doc['biz'];
      });
    }
  }

  bool _publishModal = false;
  Color radioColor1 = kBlackColor;
  Color radioColor2 = kRadioColor;

//bool _moveToNext = false;
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

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
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                      child: SvgPicture.asset(
                    'assets/imagesFolder/unlock.svg',
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: MediaQuery.of(context).size.height * 0.08,
                  )),
                ],
              ),
              spacer(),

              AnimationSlide(
                title: TextWidgetAlign(
                  name: kGeneratePin,
                  textColor: kTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w600,
                ),
              ),
              spacer(),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: selectedRadio,
                        activeColor: kBlackColor,
                        onChanged: (dynamic val) {
                          setSelectedRadio(val);

                          setState(() {
                            radioColor1 = kBlackColor;
                            radioColor2 = kRadioColor;
                            soSure = true;
                          });
                        },
                      ),
                      TextWidget(
                        name: 'For me',
                        textColor: radioColor1,
                        textSize: kFontSize,
                        textWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 2,
                        groupValue: selectedRadio,
                        activeColor: kBlackColor,
                        onChanged: (dynamic val) {
                          setSelectedRadio(val);

                          setState(() {
                            radioColor2 = kBlackColor;
                            radioColor1 = kRadioColor;
                            soSure = false;
                          });
                        },
                      ),
                      TextWidget(
                        name: 'For other',
                        textColor: radioColor2,
                        textSize: kFontSize,
                        textWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),

              spacer(),

              Container(
                child: Platform.isIOS
                    ? CupertinoTextField(
                        controller: _bizName,
                        autocorrect: true,
                        keyboardType: TextInputType.text,
                        cursorColor: (kTextFieldBorderColor),
                        style: Fonts.textSize,
                        placeholderStyle: GoogleFonts.oxanium(
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kHintColor,
                        ),
                        placeholder: kFName,
                        onChanged: (String value) {
                          bizName = value;
                        },
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorder),
                            border: Border.all(color: kLightBrown)),
                      )
                    : TextField(
                        controller: _bizName,
                        autocorrect: true,
                        readOnly:
                            widget.doc['biz'] == null ? false : true,
                        cursorColor: (kTextFieldBorderColor),
                        keyboardType: TextInputType.text,
                        style: Fonts.textSize,
                        decoration: AdminConstants.bizInput,
                        onChanged: (String value) {
                          bizName = value;
                        },
                      ),
              ),

              spacer(),

              Row(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setWidth(250),
                      minHeight: ScreenUtil().setHeight(10),
                    ),
                    child: ReadMoreText(
                      v1,
                      trimLines: 2,
                      colorClickableText: kDoneColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' ...',
                      trimExpandedText: 'show less',
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil()
                            .setSp(kFontSize, ),
                        color: kTextColor,
                      ),
                    ),
                  ),
                  v1 != '' && sends
                      ?
                       GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: v1));
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
                          child: Icon(Icons.content_copy)):Text(''),
                ],
              ),

              DividerLine(),

              // spacer(),
              sends
                  ? _publishModal
                      ? PlatformCircularProgressIndicator()
                      : NewBtn(
                          nextFunction: () {
                            _sendMessage();
                          },
                          bgColor: kGreenColor,
                          title: 'Send pin')
                  : Text(''),

              v1 == ''
                  ? BtnThird(
                      title: 'Generate admin Pin',
                      nextFunction: () {
                        generate();
                      },
                      bgColor: kLightBrown,
                    )
                  : progressbar == true
                      ? PlatformCircularProgressIndicator()
                      : Visibility(
                          visible: activateVisible,
                          child: BtnThird(
                            title: 'Activate',
                            nextFunction: () {
                              save();
                            },
                            bgColor: kDoneColor,
                          )),

              Visibility(
                  visible: closeVisible,
                  child: BtnThird(
                    title: 'Close',
                    nextFunction: () {
                      close();
                    },
                    bgColor: kRedColor,
                  )),

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
    if (_bizName.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please enter the business name',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else if (_bizName.text.length > 10) {
      Fluttertoast.showToast(
          msg: 'Sorry business name should not exceed 10 characters',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      setState(() {
        progressbar = true;
      });
      /*saving the key to database*/

      try {
        /* int timestamp = 1586348737122;
        var date = DateTime.fromMillisecondsSinceEpoch(timestamp);*/
        var now = DateTime.now();
        FirebaseFirestore.instance
            .collection('userReg')
            .doc(widget.userUid.trim())
            .set({
          'pi': v1,
          'cat': AdminConstants.businessType,
          'ts': now.toString(),
          'biz': _bizName.text.trim(),
          'create': false,
          'ouid': AdminConstants.currentUserUid,
          'so': soSure ? true : false,
          'cot': widget.doc['cot'] == null
              ? 1
              : widget.doc['cot'] + 1,
          'ano': 1,
        }, SetOptions(merge: true));
        Fluttertoast.showToast(
            gravity: ToastGravity.CENTER,
            msg: 'Activated',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: kBlackColor,
            textColor: kGreenColor);

        setState(() {
          sends = true;

          progressbar = false;
          activateVisible = false;
          closeVisible = true;
        });
      } catch (e) {
        setState(() {
          progressbar = false;
        });
        print(e.toString());
        VariablesOne.notifyFlutterToastError(title: kError);
      }
    }
  }

  void close() {
    //check if the link have been copied
    if (i <= 0) {
      Fluttertoast.showToast(
          msg: 'Please copy this code',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Saved successfully',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
    }
  }

  void _sendMessage() async {
    setState(() {
      _publishModal = true;
    });

      // Create our message.


      //send the pin to the user email
      Services.sendMail(
          email: widget.doc['email'],
          message: "<h3 style='color:orange;'>$kCompanyNames</h3>\n<p style='colors:Gray;font-size:12px;'>Hello <strong style='colors:darkBlue;font-size:14px;'>${widget.doc['fn']} ${widget.doc['ln']},</strong> This is your admin pin <b style='colors:darkBlue;font-size:14px;'>$v1</b></p>",
          subject: '${'admin pin'.toUpperCase()}:: 😀'
      );
      setState(() {
        _publishModal = false;
      });

  }
}
