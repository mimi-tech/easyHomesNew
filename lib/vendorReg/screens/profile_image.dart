import 'dart:io';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';

import 'package:easy_homes/utility/progress.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/choose_photo.dart';
import 'package:easy_homes/vendorReg/screens/bank_details.dart';

import 'package:easy_homes/vendorReg/vendor_constants.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';

class ProfileImage extends StatefulWidget {
  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  Color btnColor = kTextFieldBorderColor;

  String get filePaths => 'VProfileImage/${DateTime.now()}';

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
  }

  File? imageUrl;
  UploadTask? uploadTask;
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(DateTime.now());

  String get filePath => 'profilePix/${DateTime.now()}';

  String url = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    VendorConstants.uploadTask = null;
  }

  final picker = ImagePicker();
  bool _publishModal = false;

  Future getPhoto() async {
    Platform.isIOS
        ?
        /*show ios bottom modal sheet*/
        showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                actions: <Widget>[
                  ChoosePhoto(
                    gallery: () {
                      Navigator.pop(context);
                      getImageFromGallery();
                    },
                    camera: () {
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
            builder: (context) => ChoosePhoto(
              gallery: () {
                Navigator.pop(context);
                getImageFromGallery();
              },
              camera: () {
                Navigator.pop(context);
                getImageFromCamera();
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PlatformScaffold(
            body: ProgressHUDFunction(
      inAsyncCall: _publishModal,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            spacer(),
            BackLogo(),
            spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: paddingSize, top: 12),
                        child: TextWidget(
                          name: kLicence,
                          textColor: kTextColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  VendorConstants.usePrevious = true;
                                  print(Variables.userPix);
                                },
                                child: SvgPicture.asset(
                                    'assets/imagesFolder/edit.svg'))),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SvgPicture.asset('assets/imagesFolder/photo.svg'),
                        SizedBox(
                          width: 20.w,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: ScreenUtil().setWidth(200),
                            minHeight: 10.h,
                          ),
                          child: ReadMoreText(
                            VendorConstants.fileName!,
                            style: GoogleFonts.oxanium(
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize, ),
                              color: kGreen,
                            ),
                            trimLines: 1,
                            colorClickableText: Colors.pink,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '...',
                            trimExpandedText: ' show less',
                          ),
                        ),
                      ],
                    ),
                  ),
                  spacer(),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 1.8,
                      minHeight: 10.h,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: paddingSize),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ReadMoreText(
                          'Licence number: ' +
                              "" +
                              VendorConstants.licenceNumber!,
                          style: GoogleFonts.oxanium(
                            fontSize: ScreenUtil()
                                .setSp(kFontSize, ),
                            color: kTextColor,
                          ),
                          trimLines: 1,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...',
                          trimExpandedText: ' show less',
                        ),
                      ),
                    ),
                  ),
                  spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: paddingSize),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: TextWidget(
                        name: 'Issued Date: ' +
                            "" +
                            VendorConstants.issuedLicence!,
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: paddingSize),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: TextWidget(
                        name: 'Expired Date: ' +
                            "" +
                            VendorConstants.ExpiredLicenceDate!,
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  spacer(),
                ],
              ),
            ),

            /*Adding of profile Image*/
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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

                  Variables.userPix == null
                      ? Column(
                          children: [
                            imageUrl == null
                                ? GestureDetector(
                                    onTap: () {
                                      getPhoto();
                                    },
                                    child: SvgPicture.asset(
                                        'assets/imagesFolder/profile_image.svg'))
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 32,
                                    child: ClipOval(
                                      child: Image.file(
                                        imageUrl!,
                                        width: 200.w,
                                        height: 200.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      : Column(
                          children: [
                            CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 50,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: Variables.userPix!,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            SvgPicture.asset(
                                                'assets/imagesFolder/user.svg'),
                                        fit: BoxFit.cover,
                                        width: 200.w,
                                        height: 200.h,
                                      ),
                                    ),
                                  ),
                          ],
                        ),

                  spacer(),

                  TextWidget(
                    name: 'Vendor profile picture',
                    textColor: kDividerColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w400,
                  ),

                  //UploadingProgress(),

                  spacer(),
                ],
              ),
            ),
            spacer(),
            Btn(
              nextFunction: () {
                moveToNext();
              },
              bgColor: kLightBrown,
            ),
            spacer(),
          ],
        ),
      ),
    )));
  }

  Future<void> moveToNext() async {
    if ((Variables.userPix == null) && (VendorConstants.vendorImage == null)) {
      Fluttertoast.showToast(
          msg: 'Please upload your profile picture',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else {

      if(imageUrl == null){
        Navigator.push(
            context,
            PageTransition(type: PageTransitionType.rightToLeft, child: PaymentDetails()));
      }else{
        setState(() {
          _publishModal = true;
        });
        try {
          Reference ref = FirebaseStorage.instance.ref().child(filePath);
          uploadTask = ref.putFile(imageUrl!);
          final TaskSnapshot downloadUrl = await uploadTask!;
          url = await downloadUrl.ref.getDownloadURL();
          Variables.userPix = url;

          setState(() {
            _publishModal = false;
          });
          Navigator.push(
              context,
              PageTransition(type: PageTransitionType.rightToLeft, child: PaymentDetails()));
        } catch (e) {
          setState(() {
            _publishModal = false;
          });
          //Variables.userPix = url;
          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PaymentDetails()));
        }
      }
    }
  }

  Future<void> _uploadImage() async {
//check the file size

    /*setState(() {
        imageUrl = files;
      });
      StorageReference ref = FirebaseStorage.instance.ref().child(filePaths);
      VendorConstants.uploadTask = ref.putFile(files,
        StorageMetadata(
          contentType: 'images.jpg',
        ),
      );

      final StorageTaskSnapshot downloadUrl = await VendorConstants.uploadTask.onComplete;
      VendorConstants.vendorImage = await downloadUrl.ref.getDownloadURL();
      setState(() {
        btnColor= kLightBrown;
      });*/
  }

  Future<void> getImageFromGallery() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    // int fileSize = file.lengthSync();
    _cropImage(file!.files.single.path, File(file.files.single.path!));
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        imageUrl = File(pickedFile.path);
        _cropImage(imageUrl, imageUrl!);
      } else {
        print('No image selected.');
      }
    });
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
        ));

    if (croppedImage != null) {
      setState(() {
        imageUrl = croppedImage;
        Variables.image = croppedImage;
      });
    } else {
      setState(() {
        imageUrl = file;
        Variables.image = file;
      });
    }
  }
}
