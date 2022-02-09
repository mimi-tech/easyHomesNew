import 'dart:io';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/progress.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/screens/bank_details.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
class NotADriver extends StatefulWidget {
  @override
  _NotADriverState createState() => _NotADriverState();
}

class _NotADriverState extends State<NotADriver> {

  Color btnColor = kTextFieldBorderColor;
  String get filePaths => 'VProfileImage/${DateTime.now()}';
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
  }
  File? imageUrl;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    VendorConstants.uploadTask = null;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        spacer(),
       BackLogo(),

        spacer(),

        /*Adding of profile Image*/
        Container(

          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          width: double.infinity,

          decoration: BoxDecoration(

            shape: BoxShape.rectangle,

            border: Border.all(

              width: 0.5,

              color: kTurnOnBtn,

            ),

            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              spacer(),
              TextWidget(
                name: kAddPhoto,
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.w400,
              ),

              imageUrl == null? GestureDetector(
                  onTap: (){_uploadImage();},
                  child: SvgPicture.asset('assets/imagesFolder/profile_image.svg')):


              GestureDetector(
                onTap: (){_uploadImage();},
                child: ClipOval(
                  child: Image.file(
                    imageUrl!,
                    height: 150.h,
                    width: 150.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              spacer(),

              TextWidget(
                name: 'Example',
                textColor: kDividerColor,
                textSize: kFontSize,
                textWeight: FontWeight.w400,
              ),


              UploadingProgress(),
              spacer(),
            ],
          ),
        ),

        SvgPicture.asset('assets/imagesFolder/potrait_text.svg'),



        spacer(),
        Btn(nextFunction: () {
          moveToNext();
        }, bgColor: btnColor,),
        spacer(),
      ],


    )));
  }

  void moveToNext() {
    if(( VendorConstants.vendorImage  == null) || ( VendorConstants.vendorImage == '')) {
      Fluttertoast.showToast(
          msg: 'Please upload your profile picture',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else{
      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PaymentDetails()));



    }
  }

  Future<void> _uploadImage() async {
    FilePickerResult? files = await FilePicker.platform.pickFiles(
      type: FileType.image,

    );

/*check the file size*/
    if(files != null) {
      setState(() {
        imageUrl = File(files.files.single.path!);
      });
    }
    if (files!.files.single.size <= kSFileSize) {

      Reference ref = FirebaseStorage.instance.ref().child(filePaths);
      VendorConstants.uploadTask = ref.putFile(imageUrl!,
        SettableMetadata(
          contentType: 'images.jpg',
        ),
      );

      final TaskSnapshot? downloadUrl = await VendorConstants.uploadTask;
      VendorConstants.vendorImage = await downloadUrl!.ref.getDownloadURL();
      setState(() {
        btnColor = kLightBrown;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSFileError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }

  }
