import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:easy_homes/utility/progress.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/screens/profile_image.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
class VendorLicence extends StatefulWidget {
  @override
  _VendorLicenceState createState() => _VendorLicenceState();
}

class _VendorLicenceState extends State<VendorLicence> {
   UploadTask? uploadTask;

  DateTime selectedDate = DateTime.now();
  TextEditingController _licenceNumber = new TextEditingController();
  DateTime selectedExpiredDate = DateTime.now();
  String get filePaths => 'Vlicence/${DateTime.now()}';
  Color btnColor = kTextFieldBorderColor;
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
  }
  bool _publishModal = false;
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    VendorConstants.uploadTask = null;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(body:

   ProgressHUDFunction(
     inAsyncCall: _publishModal,
     child: SingleChildScrollView(
       child: Container(
         margin: EdgeInsets.symmetric(horizontal: 15),
         child: Column(
           children: <Widget>[
             spacer(),
            BackLogo(),

             spacer(),

         Container(
           alignment: Alignment.topLeft,
           margin: EdgeInsets.symmetric(horizontal: kHorizontal),
           child: Center(
             child: TextWidgetAlign(
                   name: kLicence.toUpperCase(),
                   textColor: kLightBrown,
                   textSize: kFontSize,
                   textWeight: FontWeight.bold,
                 ),
           ),
         ),

         spacer(),
         Wrap(

               alignment: WrapAlignment.spaceBetween,
               children: <Widget>[
               Column(
                 children: <Widget>[
                   TextWidget(
                     name: kIssuedDate,
                     textColor: kBlackColor,
                     textSize: kFontSize,
                     textWeight: FontWeight.w400,
                   ),
                   Container(
                     height: 60.h,
                     width: MediaQuery.of(context).size.width * textFieldSize,
                     child:  OutlineButton(
                       onPressed: (){
                         _selectIssuesDate(context);
                       },
                       child: TextWidget(
                         name: VendorConstants.issuedLicence == null?'YYYY-mm-dd':"${selectedDate.toLocal()}".split(' ')[0],
                         textColor: VendorConstants.issuedLicence == null?kHintColor:kBlackColor,
                         textSize: kFontSize,
                         textWeight: FontWeight.w400,
                       ),
                     ),
                   ),
                 ],
               ),

                SizedBox(width: 4.w,),
                 /*Licence Expering Date*/


                 Column(
                   children: <Widget>[
                     TextWidget(
                       name: kExpiringDate,
                       textColor:  kBlackColor,
                       textSize: kFontSize,
                       textWeight: FontWeight.w400,
                     ),
                     Container(
                       height: 60.h,
                       width: MediaQuery.of(context).size.width * textFieldSize,
                       child:  OutlineButton(
                           onPressed: (){
                             _selectExpiredDate(context);
                           },
                         child: TextWidget(
                           name: VendorConstants.ExpiredLicenceDate == null?'YYYY-mm-dd':"${selectedExpiredDate.toLocal()}".split(' ')[0],
                           textColor: VendorConstants.ExpiredLicenceDate == null?kHintColor:kBlackColor,
                           textSize: kFontSize,
                           textWeight: FontWeight.w400,
                         ),
                       ),
                     ),
                   ],
                 )



               ],
             ),

             /*getting the drivers licence Number*/
         spacer(),
             Container(
              //margin: EdgeInsets.symmetric(horizontal: kHorizontal),
               child:   Platform.isIOS
                   ? CupertinoTextField(
                 controller: _licenceNumber,
                 autocorrect: true,


                 keyboardType: TextInputType.number,
                 cursorColor: (kTextFieldBorderColor),
                 style: Fonts.textSize,
                 placeholderStyle: GoogleFonts.oxanium(
                   fontSize: ScreenUtil().setSp(
                       kFontSize, ),
                   color: kHintColor,
                 ),
                 placeholder: 'Licence number \n e.g AB73638',
                 onChanged: (String value) {
                   VendorConstants.licenceNumber = value;
                 },
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(kBorder),
                     border: Border.all(color: kLightBrown)),
               )
                   : TextField(
                 controller: _licenceNumber,
                 autocorrect: true,
                 cursorColor: (kTextFieldBorderColor),
                 keyboardType: TextInputType.number,
                 style: Fonts.textSize,
                 decoration: VendorConstants.driverLicence,
                 onChanged: (String value) {
                   VendorConstants.licenceNumber = value;
                 },

               ),

             ),
           spacer(),
             GestureDetector(
                 onTap: (){
                   uploadLicence();
                 },
                 child: SvgPicture.asset('assets/imagesFolder/upload.svg')),

       Center(
         child: TextWidget(
           name: kScans,
           textColor: kTextColor,
           textSize: 12,
           textWeight: FontWeight.w400,
         ),
       ),

        spacer(),
             VendorConstants.usePrevious?Align(
               alignment: Alignment.topRight,
               child: RaisedButton(
                 color: kRedColor,
                 onPressed: (){
                   Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ProfileImage()));

                 },
                 child: TextWidget(
                   name: 'Use previous',
                   textColor: kWhiteColor,
                   textSize: kFontSize,
                   textWeight: FontWeight.w400,
                 ),
               ),
             ):
                 Text('')

           //UploadingProgress(),


           ],
         ),
       ),
     ),
   )



    ));
  }

  void moveToNext() {
if((VendorConstants.licenceUrl == null) || (VendorConstants.licenceUrl == '')){
  Fluttertoast.showToast(
      msg: 'Please upload your licence',
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: kBlackColor,
      timeInSecForIosWeb: 5,
      textColor: kRedColor);
}else{


  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ProfileImage()));

}

  }

  Future<void> uploadLicence() async {


    /*check if inputs r empty*/

    if(VendorConstants.issuedLicence == null){
      Fluttertoast.showToast(
          msg: kInputError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else if(VendorConstants.ExpiredLicenceDate == null){
      Fluttertoast.showToast(
          msg: kInputError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else if((VendorConstants.licenceNumber == null)|| (VendorConstants.licenceNumber == '')){
      Fluttertoast.showToast(
          msg: kInputError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else {
      FilePickerResult? files = await FilePicker.platform.pickFiles(
        type: FileType.image,

      );
      String _path = files.toString();

      String fileName = _path
          .split('/')
          .last;

      setState(() {
        VendorConstants.fileName = fileName;
      });

/*check the file size*/
      if (files != null) {
        File fileLength = File(files.files.single.path!);
        int fileSize = fileLength.lengthSync();
        if (fileSize <= kSFileSize) {

          /*crop the licence*/
          _cropImage(fileLength.path, fileLength);

        }else{
          Fluttertoast.showToast(
              msg: kSFileError2,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackColor,
              timeInSecForIosWeb: 5,
              textColor: kRedColor);

        }
      }



    }
  }

  _cropImage(filePath, File files) async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxWidth: 1000,
        maxHeight: 1000,
        compressQuality: 20,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Licence',
            toolbarColor: kWhiteColor,
            toolbarWidgetColor: kLightBrown,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    setState(() {
      _publishModal = true;
    });

    if (croppedImage  != null) {
      Reference ref = FirebaseStorage.instance.ref().child(filePaths);
      uploadTask = ref.putFile(croppedImage,
        SettableMetadata(
          contentType: 'images.jpg',
        ),
      );

      final TaskSnapshot downloadUrl = await uploadTask!;

      VendorConstants.licenceUrl = await downloadUrl.ref.getDownloadURL();
      setState(() {
        btnColor= kLightBrown;
        _publishModal = false;

      });
      moveToNext();

    }else{
      Reference ref = FirebaseStorage.instance.ref().child(filePaths);
      uploadTask = ref.putFile(files,
        SettableMetadata(
          contentType: 'images.jpg',
        ),
      );

      final TaskSnapshot downloadUrl = await uploadTask!;
      VendorConstants.licenceUrl = await downloadUrl.ref.getDownloadURL();
      print(VendorConstants.licenceUrl);
      setState(() {
        btnColor= kLightBrown;
        _publishModal = false;

      });

      moveToNext();

    }
  }


  Future<void> _selectIssuesDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      helpText: 'Select Linence Issued date',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Issued date',
      fieldHintText: 'Month/Date/Year',


        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.dark(
                primary: kSeaGreen,
                onPrimary: Colors.white,
                surface: kSeaGreen,
                onSurface: kBlackColor,


              ),
              dialogBackgroundColor: kWhiteColor,
            ),
            child: child!,
          );
        }

    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        VendorConstants.issuedLicence = "${selectedDate.toLocal()}".split(' ')[0];


      });
  }

  Future<void> _selectExpiredDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedExpiredDate, // Refer step 1
        firstDate: DateTime(2010),
        lastDate: DateTime(2030),
        helpText: 'Select Linence Expring date',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter date in valid range',
        fieldLabelText: 'Expired date',
        fieldHintText: 'Month/Date/Year',


        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.dark(
                primary: kSeaGreen,
                onPrimary: Colors.white,
                surface: kSeaGreen,
                onSurface: kBlackColor,


              ),
              dialogBackgroundColor: kWhiteColor,
            ),
            child: child!,
          );
        }

    );
    if (picked != null && picked != selectedExpiredDate)
      setState(() {
        selectedExpiredDate = picked;
        VendorConstants.ExpiredLicenceDate = "${selectedExpiredDate.toLocal()}".split(' ')[0];


      });
  }
}
