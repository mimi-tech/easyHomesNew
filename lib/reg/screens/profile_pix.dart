import 'dart:io';

import 'package:easy_homes/reg/screens/mobile.dart';
import 'package:easy_homes/utils/choose_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utils/capitalize.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';




class ProfilePixScreen extends StatefulWidget {
  @override
  _ProfilePixScreenState createState() => _ProfilePixScreenState();
}

class _ProfilePixScreenState extends State<ProfilePixScreen> {
  TextEditingController _fName = TextEditingController();
  TextEditingController _lName = TextEditingController();

  Color btnColor = kTextFieldBorderColor;
  final picker = ImagePicker();



File? imageURI;
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        imageURI = File(pickedFile.path);
        _cropImage(imageURI!.path, imageURI!);

      } else {
        print('No image selected.');
      }
    });
  }





  Future getImageFromGallery() async {
    try {
      File? file;
      FilePickerResult? files = await FilePicker.platform.pickFiles(

        type: FileType.image,

      );
      if (files != null) {
        File fileLength = File(files.files.single.path!);
        _cropImage(fileLength.path, fileLength);
      }
    }catch(e){
      print("An Error $e");
    }

  }
  Future getPhoto() async {


    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(
        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          ChoosePhoto(
          gallery: (){
        Navigator.pop(context);
        getImageFromGallery();
      },
      camera: (){
      Navigator.pop(context);
      getImageFromCamera();
      },

          )
        ],
      );
    })

        : showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ChoosePhoto(gallery: (){
          Navigator.pop(context);
          getImageFromGallery();
        },
        camera: (){
          Navigator.pop(context);
          getImageFromCamera();
        },
        ),

    );


  }

  _cropImage(filePath, File file) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1000,
      maxHeight: 1000,
        compressQuality: 20,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: kWhiteColor,
            toolbarWidgetColor: kLightBrown,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    if (croppedImage  != null) {

      setState(() {
        imageURI  = croppedImage;
        Variables.image = croppedImage;

      });
    }else{
      setState(() {
        imageURI  = file;
        Variables.image = file;

      });
    }
  }


  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  Widget mainBody(){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          spacer(),
          GestureDetector(
            onTap:(){Navigator.pop(context);},
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                alignment: Alignment.centerLeft,
                child: PlatformIconButton(
                    icon: Icon(Icons.arrow_back_ios,size: 30,),
                    onPressed: (){
                      Navigator.pop(context);
                    }
                ),
            ),
          ),
          Center(child:
         imageURI == null? GestureDetector(
              onTap: (){

                getPhoto();
              },
              child: SvgPicture.asset('assets/imagesFolder/user.svg')

         )

             : GestureDetector(
           onTap: (){

             getPhoto();
           },
               child: CircleAvatar(
           backgroundColor: Colors.transparent,
           backgroundImage: FileImage(imageURI!),
           radius: 50,

         ),
             )

          ),

          Text( imageURI == null? kProfilePix:'Edit photo',
            style:GoogleFonts.oxanium(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(kFontSize, ),
              color: imageURI == null?  kPix:kRedColor,
            ),
          ),

          spacer(),
          Text(kName,
            style:GoogleFonts.oxanium(
              fontWeight: FontWeight.normal,
              fontSize: ScreenUtil().setSp(kFontSize, ),
              color: kBlackColor,
            ),
          ),
          spacer(),
/*showing the textField*/

          Container(
            margin: EdgeInsets.symmetric(horizontal:kHorizontal),
            child: Wrap(


              children: <Widget>[
                Container(
                  width:MediaQuery.of(context).size.width*0.4,
                  child: Platform.isIOS
                      ? CupertinoTextField(
                    controller: _fName,
                    autocorrect: true,
                    autofocus: true,

                    keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    placeholderStyle:GoogleFonts.oxanium(
                      fontSize: ScreenUtil().setSp(kFontSize, ),
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
                    autofocus: true,
                    cursorColor: (kTextFieldBorderColor),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    style: Fonts.textSize,
                    decoration: Variables.fNameInput,
                    onChanged: (String value) {
                      Variables.fName = value;

                    },
                  ),

                ),
                SizedBox(width: 10.0.w,),
                /*displaying last name*/

                Container(
                  width:MediaQuery.of(context).size.width*0.4,
                  child:   Platform.isIOS
                      ? CupertinoTextField(
                    controller: _lName,
                    autocorrect: true,
                    autofocus: true,

                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    placeholderStyle:GoogleFonts.oxanium(
                      fontSize: ScreenUtil().setSp(kFontSize, ),
                      color: kHintColor,
                    ),
                    placeholder: kFName,
                    onChanged: (String value) {
                      Variables.lName = value;
                      if(Variables.lName == '' ){
                        setState(() {
                          btnColor = kTextFieldBorderColor;
                        });
                      }else{
                        setState(() {
                          btnColor = kLightBrown;
                        });
                      }
                    },
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorder),
                        border: Border.all(color: kLightBrown)),
                  )
                      : TextField(
                    controller: _lName,
                    autocorrect: true,
                    autofocus: true,
                    cursorColor: (kTextFieldBorderColor),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    style: Fonts.textSize,
                    decoration: Variables.lNameInput,
                    onChanged: (String value) {
                      Variables.lName = value;
                      if(Variables.lName == '' ){
                        setState(() {
                          btnColor = kTextFieldBorderColor;
                        });
                      }else{
                        setState(() {
                          btnColor = kLightBrown;
                        });
                      }
                    },
                  ),
                )


              ],
            ),
          ),


          /*displaying Next button*/
          spacer(),


          Btn(nextFunction: (){moveToNext();}, bgColor: btnColor,)
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(child:
    Platform.isIOS? CupertinoPageScaffold(
      child: mainBody(),
    ):Scaffold(
        body: mainBody()));
  }

  void moveToNext() {
    if((Variables.fName == null) || (Variables.fName == '')){
      Fluttertoast.showToast(
          msg: kFNameError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else if ((Variables.lName == null) || (Variables.lName == '')){
      Fluttertoast.showToast(
          msg: kFNameError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);

    } else{
      var capitalizedValue = Variables.fName!.substring(0, 1).toUpperCase();
      print(capitalizedValue);
      var firstName =  Variables.fName!.capitalize();
       Variables.fName = firstName;


      var lastName =  Variables.lName!.capitalize();
      Variables.lName = lastName;


       Navigator.of(context).push
        (MaterialPageRoute(builder: (context) => MobileScreen()));


    }
  }

}
