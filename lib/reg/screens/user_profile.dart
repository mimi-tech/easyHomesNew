import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/reset_trans_pin.dart';
import 'package:easy_homes/dashboard/trans_pin.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/services.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/change_phone/second_screen.dart';
import 'package:easy_homes/reg/screens/home2.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/profile_pix.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';


class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.03);
  }

  String get filePath => 'profilePix/${DateTime.now()}';
  UploadTask? uploadTask;
  TextEditingController _fName = TextEditingController();
  TextEditingController _lName = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _email = TextEditingController();
  String _countryCode = '';
  bool _publishModal = false;
  bool _checkMobileNumber = false;
   String url = "";
  //final Telephony telephony = Telephony.instance;
  late int randomNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fName.text = Variables.userFN!;
    _lName.text = Variables.userLN!;
    _mobile.text = Variables.currentUser[0]['p2'];
    _email.text = Variables.userEmail!;


    //check if the user changed his phone number
       print( _checkMobileNumber);
    _mobile.addListener(() {
      if (_mobile.text == Variables.currentUser[0]['p2']) {
        setState(() {
          _checkMobileNumber = false;
        });
        print(_checkMobileNumber);
      } else {
        setState(() {
          _checkMobileNumber = true;
        });
        print(_checkMobileNumber);
      }
    });
  }

  File? imageURI;

  Future getImageFromGallery() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
 File file;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
 if (result != null) {
   file = File(result.files.single.path!);
   int fileSize = file.lengthSync();
   if (fileSize <= kSFileSize) {
     setState(() {
       imageURI = file;
     });
   } else {
     Fluttertoast.showToast(
         msg: kProfilePixError,
         toastLength: Toast.LENGTH_LONG,
         backgroundColor: kBlackColor,
         textColor: kRedColor);
   }
 }



  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(
        appBar: PlatformAppBar(
          backgroundColor: kWhiteColor,
          leading: PlatformIconButton(
              icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: LogoDesign(),


        ),

        body: ProgressHUDFunction(
            inAsyncCall: _publishModal,
            child: SingleChildScrollView(
                child: Container(

                    child: Column(
                        children: <Widget>[
                        spacer(),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.01),
                    imageURI == null ?

                    ProfilePicture() :
                    InkWell(
                      onTap: () {
                        if (Variables.currentUser[0]['ven'] != true) {
                          getImageFromGallery();
                        } else {
                          VariablesOne.notifyErrorBot(
                              title: 'Sorry, as a vendor you can not change your profile picture');
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 32,
                        child: ClipOval(
                          child: Image.file(imageURI!,
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.12,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        GestureDetector(
                        onTap: () {
                if(Variables.currentUser[0]['ven'] != true){
                getImageFromGallery();

                }else{
                VariablesOne.notifyErrorBot(title: 'Sorry, as a vendor you can not change your profile picture. Come to our office for a new capture. Thanks');
                }},
                child: TextWidget(name: kChangeProfile.toUpperCase(),
                textColor: kDoneColor,
                textSize: kFontSize14,
                textWeight: FontWeight.normal,),
                ),
                imageURI == null?Text(''):GestureDetector(
                onTap: (){
                setState(() {
                imageURI = null;
                });
                },
                child: Icon(Icons.delete,color: kRedColor,size: 25,)),

                ],
                ),


                spacer(),
                GestureDetector(
                onTap: (){

                if(Variables.currentUser[0]['tx'] == null) {
                Navigator.push(
                context,
                PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: TransactionPin()));
                }else{
                Navigator.push(
                context,
                PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: ResetTransactionPin()));
                }
                },


                child: TextWidget(
                name: Variables.currentUser[0]['tx'] == null?kTxtPing:kRestPin.toUpperCase(),
                textColor: kDoneColor,
                textSize: 16,
                textWeight: FontWeight.bold,
                ),
                ),

                spacer(),


                GestureDetector(
                onTap: (){
                Clipboard.setData( ClipboardData(
                text: Variables.currentUser[0]['ref']));
                Fluttertoast.showToast(
                msg: 'Copied',
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: kRadioColor,
                textColor: kWhiteColor);

                },
                child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                TextWidget(name: 'Copy your referral link',
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),

                SizedBox(width: MediaQuery.of(context).size.width * 0.02,),

                Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                alignment: Alignment.topRight,
                child: Icon(Icons.content_copy))
                ],
                ),
                ),
                spacer(),
                Container(

                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Column(

                children: <Widget>[

                Container(
                alignment: Alignment.topLeft,

                child: TextWidget(name: kFName.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,),
                ),
                Platform.isIOS
                ? CupertinoTextField(
                controller: _fName,
                autocorrect: true,
                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                cursorColor: (kTextFieldBorderColor),
                style: Fonts.textSize,
                placeholderStyle: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                kFontSize, ),
                color: kHintColor,
                ),
                placeholder: kFName,
                onChanged: (String value) {
                Variables.fName = value;
                },
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorder),
                border: Border.all(color: kLightBrown)),
                )
                    : TextField(
                controller: _fName,
                autocorrect: true,
                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: (kTextFieldBorderColor),
                keyboardType: TextInputType.text,
                style: Fonts.textSize,
                decoration: Variables.fNameInput,
                onChanged: (String value) {
                Variables.fName = value;
                },
                ),

                spacer(),
                Container(
                alignment: Alignment.topLeft,

                child: TextWidget(name: kLName.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,),
                ),
                Platform.isIOS
                ? CupertinoTextField(
                controller: _lName,
                autocorrect: true,
                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                cursorColor: (kTextFieldBorderColor),
                style: Fonts.textSize,
                placeholderStyle: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                kFontSize, ),
                color: kHintColor,
                ),
                placeholder: kFName,
                onChanged: (String value) {
                Variables.lName = value;
                },
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorder),
                border: Border.all(color: kLightBrown)),
                )
                    : TextField(
                controller: _lName,
                autocorrect: true,
                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: (kTextFieldBorderColor),
                keyboardType: TextInputType.text,
                style: Fonts.textSize,
                decoration: Variables.lNameInput,
                onChanged: (String value) {
                Variables.lName = value;
                },
                ),
                spacer(),
                Container(
                alignment: Alignment.topLeft,

                child: TextWidget(name: kMobileHint.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,),
                ),

                Platform.isIOS
                ? CupertinoTextField(
                controller: _mobile,
                autocorrect: true,
                autofocus: false,

                prefix: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CountryCodePicker(
                textStyle: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                kFontSize, ),
                fontWeight: FontWeight.bold,

                color: kTextColor,
                ),
                onInit: (code) {
                _countryCode = code.toString();
                },
                onChanged: (code) {
                _countryCode = code.toString();
                },
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: 'NG',
                favorite: [Variables.mobile == null?'${Variables.currentUser[0]['cc']}':Variables.ctyCode!, 'NG'],
                // optional. Shows only country name and flag
                showCountryOnly: false,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
                ),
                ),
                keyboardType: TextInputType.number,
                cursorColor: (kTextFieldBorderColor),
                style: Fonts.textSize,
                placeholderStyle: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                kFontSize, ),
                color: kHintColor,
                ),
                inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
                ],
                placeholder: '+234' + kMobileHint,
                onChanged: (String value) {
                Variables.mobile = value;
                },
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorder),
                border: Border.all(color: kLightBrown)),
                )
                    : TextField(
                controller: _mobile,
                autocorrect: true,
                autofocus: false,

                cursorColor: (kTextFieldBorderColor),
                keyboardType: TextInputType.number,
                style: Fonts.textSize,
                decoration: InputDecoration(
                prefixIcon: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CountryCodePicker(
                textStyle: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                kFontSize, ),
                fontWeight: FontWeight.bold,

                color: kTextColor,
                ),
                onInit: (code) {
                _countryCode = code.toString();
                },
                onChanged: (code) {
                _countryCode = code.toString();
                },
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: 'NG',
                // favorite: [Variables.mobile == null?'${Variables.currentUser[0]['cc']}':Variables.ctyCode, 'NG'],
                // optional. Shows only country name and flag
                showCountryOnly: false,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
                ),
                ),
                hintText: kMobileHint,
                hintStyle: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                kFontSize, ),
                color: kHintColor,
                ),
                contentPadding: EdgeInsets.fromLTRB(
                20.0, 18.0, 20.0, 18.0),
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                kBorder)),
                focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                color: kLightBrown))


                ),


                inputFormatters: <TextInputFormatter>[

                FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (String value) {
                Variables.mobile = value;
                },
                ),


                spacer(),
                Container(
                alignment: Alignment.topLeft,

                child: TextWidget(name: 'Email Address'.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,),
                ),

                Platform.isIOS
                ? CupertinoTextField(
                controller: _email,
                autocorrect: true,
                autofocus: false,
                readOnly: true,
                keyboardType: TextInputType.emailAddress,
                cursorColor: (kTextFieldBorderColor),
                style: Fonts.textSize,
                placeholderStyle: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                kFontSize, ),
                color: kHintColor,
                ),
                placeholder: 'Email',
                onChanged: (String value) {
                Variables.email = value;
                },
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorder),
                border: Border.all(color: kLightBrown)),
                )
                    : Theme(
                data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                child: TextField(

                readOnly: true,
                controller: _email,
                autocorrect: true,
                autofocus: false,
                cursorColor: (kTextFieldBorderColor),
                keyboardType: TextInputType.emailAddress,
                style: Fonts.textSize,
                decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey,

                hintStyle:GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(kFontSize, ),
                color: kHintColor,
                ),
                contentPadding: EdgeInsets.fromLTRB(
                20.0, 18.0, 20.0, 18.0),
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                kBorder)),
                focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                color: kLightBrown))
                ),
                onChanged: (String value) {
                Variables.email = value;
                },
                ),
                )

                ],
                ),
                ),
                spacer(),
                SizedBtn(title: 'Update', bgColor: kDoneColor, nextFunction: () {
                _updateUser();
                },),
                spacer(),
                ],
                ),

                ),
                ),
                )));
                }

                    Future<void> _updateUser() async {
            if (_fName.text.isEmpty) {
            Fluttertoast.showToast(
            msg: kFNameError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
            } else if (_lName.text.isEmpty) {
            Fluttertoast.showToast(
            msg: kFNameError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
            } else if (_mobile.text.isEmpty) {
            Fluttertoast.showToast(
            msg: kMobileError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
            } else if (_mobile.text.length < 10) {
            Fluttertoast.showToast(
            msg: 'Error please check your phone number',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
            } else {
            if(_mobile.text.startsWith('0')){
            String a = _mobile.text.substring(1);
            _mobile.text = a;
            }

            //check if there is changes at all

            if((_fName.text.trim() == Variables.currentUser[0]['fn']) &&
            (_lName.text.trim() == Variables.currentUser[0]['ln']) &&
            (_checkMobileNumber == false) && (imageURI == null)){
            VariablesOne.notify(title: 'No changes made');


            }else{

            //check if user is changing phone number
            if(_checkMobileNumber == false){

            checkToUpdate();


            }else{

            setState(() {
            _publishModal = true;
            });
            //check if that line is existing in the database

            final QuerySnapshot result = await FirebaseFirestore.instance.collection(
            'userReg')
                .where('ph', isEqualTo: _countryCode + _mobile.text.trim())
                .get();

            final List <DocumentSnapshot> documents = result.docs;
            if (documents.length == 1) {
            setState(() {
            _publishModal = false;
            });

            Fluttertoast.showToast(
            msg: 'Sorry this phone number already exist',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: kBlackColor,
            textColor: kRedColor);

            }else {
            sendToWhatsApp();
            }
            }
            }}
            }

                Future<void> sendToWhatsApp() async {
        setState(() {
        _publishModal = true;
        });
//check if phone number starts with 0
        if(_mobile.text.trim().startsWith('0')){
        String a = _mobile.text.trim().substring(1);
        _mobile.text = a;
        }

        var phone = '$_countryCode${_mobile.text.trim()}';


        Random random = new Random();
        randomNumber = random.nextInt(1000000);


        try{
          Services.sendSms(
              phoneNumber: phone,
              message: '$kCompanyNames-$randomNumber',
                      );

          Platform.isIOS ?
          //show ios bottom modal sheet
          showCupertinoModalPopup(

              context: context, builder: (BuildContext context) {
            return CupertinoActionSheet(
              actions: <Widget>[
                VerifyChangeMobileScreen(otpCode:(){updateMobileNumber();})
              ],
            );
          })

                  : showModalBottomSheet(
                  isDismissible: false,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => VerifyChangeMobileScreen(otpCode:(){updateMobileNumber();})
                  );

        }catch(e){
        setState(() {
        _publishModal = false;
        });
        Fluttertoast.showToast(
        msg: "Sorry we couldn't send verification code to you",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: kBlackColor,
        textColor: kRedColor); }



        }


        void updateMobileNumber() {

    if ((Variables.mobilePin == null) || (Variables.mobilePin == '')) {
    Fluttertoast.showToast(
    msg: kPinError,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: kBlackColor,
    textColor: kRedColor);
    } else {

    if(int.parse(Variables.mobilePin!) == randomNumber){
    Navigator.pop(context);
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
    }
    //update database
    checkToUpdate();


    }else{
    Fluttertoast.showToast(
    msg: 'Sorry incorrect code,please check the message sent to you',
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: kBlackColor,
    textColor: kRedColor);
    }
    }

    }

        Future<void> checkToUpdate()
    async {
      if (imageURI == null) {
        try {
          setState(() {
            _publishModal = true;
          });
          var capitalizedValue = _fName.text.substring(0, 1).toUpperCase();

          FirebaseFirestore.instance.collection('userReg').doc(
              Variables.userUid)
              .update({
            'fn': _fName.text.trim(),
            'ln': _lName.text.trim(),
            'ph': _checkMobileNumber
                ? _countryCode + _mobile.text.trim()
                : Variables.currentUser[0]['cc'] +
                Variables.currentUser[0]['p2'],
            'cc': _checkMobileNumber ? _countryCode : Variables
                .currentUser[0]['cc'],
            'p2': _checkMobileNumber ? _mobile.text.trim() : Variables
                .currentUser[0]['p2'],
            'sk':capitalizedValue,

          });

          //check if user is a vendor or business
          updateVendorCollectionNoImage();

          setState(() {
            _publishModal = false;
          });

          VariablesOne.notify(title: 'Profile updated successfully');
        Navigator.pop(context);
        } catch (e) {
          setState(() {
            _publishModal = false;
          });

          VariablesOne.notifyFlutterToastError(title: kError);
        }
      } else {
        setState(() {
          _publishModal = true;
        });
        try {
          var capitalizedValue = _fName.text.substring(0, 1).toUpperCase();

          Reference ref = FirebaseStorage.instance.ref().child(filePath);

          uploadTask = ref.putFile(imageURI!);

          final TaskSnapshot downloadUrl = await uploadTask!;
          url = await downloadUrl.ref.getDownloadURL();
          FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid).update({
            'fn': _fName.text.trim(),
            'ln': _lName.text.trim(),
            'ph': _checkMobileNumber
                ? _countryCode + _mobile.text.trim()
                : Variables.currentUser[0]['cc'] +
                Variables.currentUser[0]['p2'],
            'cc': _checkMobileNumber ? _countryCode : Variables.currentUser[0]['cc'],
            'p2': _checkMobileNumber ? _mobile.text.trim() : Variables.currentUser[0]['p2'],
            'pix': url,
            'sk':capitalizedValue,
          });
          //check if user is a vendor

          updateVendorCollectionNoImage();
          setState(() {
            _publishModal = false;
          });


          VariablesOne.notify(title: 'Profile updated successfully');
          Navigator.pop(context);

        } catch (e) {
          setState(() {
            _publishModal = false;
          });
          VariablesOne.notifyFlutterToastError(title: kError);
        }
      }
    }


    void updateVendorCollectionNoImage() {

      if (Variables.currentUser[0]['ven'] == true) {
        FirebaseFirestore.instance
            .collectionGroup('companyVendors')
            .where('vId', isEqualTo: Variables.userUid)
            .get().then((value) {
          value.docs.forEach((result) {
            result.reference.update({
              'fn': _fName.text.trim(),
              'ln': _lName.text.trim(),
              'ph': _checkMobileNumber
                  ? _countryCode + _mobile.text.trim()
                  : Variables.currentUser[0]['cc'] +
                  Variables.currentUser[0]['p2'],
              'pix':imageURI == null?Variables.currentUser[0]['pix']:url
            });
          });
        });
      }

      if (Variables.currentUser[0]['cat'] == AdminConstants.business) {
        FirebaseFirestore.instance
            .collection('AllBusiness')
            .where('ud', isEqualTo: Variables.userUid)
            .get().then((value) {
          value.docs.forEach((result) {
            result.reference.update({
              'fn': _fName.text.trim(),
              'ln': _lName.text.trim(),
              'pix':imageURI == null?Variables.currentUser[0]['pix']:url,
              'ph': _checkMobileNumber
                  ? _countryCode + _mobile.text.trim()
                  : Variables.currentUser[0]['cc'] +
                  Variables.currentUser[0]['p2'],
            });
          });
        });
      }
    }
  }


