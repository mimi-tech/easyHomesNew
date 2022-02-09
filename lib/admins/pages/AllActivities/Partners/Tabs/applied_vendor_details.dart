import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/applicants.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/applied_vendors.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'Package:vector_math/vector_math_64.dart' show Vector3;
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
class AppliedVendorDetails extends StatefulWidget {

  @override
  _AppliedVendorDetailsState createState() => _AppliedVendorDetailsState();
}

class _AppliedVendorDetailsState extends State<AppliedVendorDetails>with TickerProviderStateMixin {
  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.025);
  }
  bool _publishModal = false;
 double imageSize = 25.0;
  File? _image;
  File? _licenceImage;
String radioItem = '';
  final picker = ImagePicker();
double _scale = 1.0;
double _previousScale = 1.0;
  late UploadTask uploadTask;
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
  double _height = 70.0.h;
  double _width = 50.0.w;
  bool _resized = false;
  String get filePath => 'profilePix/${DateTime.now()}';

  static String username = Variables.cloud!['em'];
  static String password = Variables.cloud!['ps'];
  final smtpServer = gmail(username, password);
  static List<File> licenceReg = <File>[];
  static List<String> licenceRegUrl = <String>[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(
        appBar: PlatformAppBar(
          leading: IconButton(
            icon: SvgPicture.asset('assets/imagesFolder/go_back.svg',color: kWhiteColor,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: kDoneColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextWidget(
                name: 'Screening'.toUpperCase(),
                // AdminConstants.bizName!.toUpperCase(),
                textColor: kWhiteColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),

    VendorPix(pix: AdminConstants.vendorDetails[0]['pix'], pixColor: Colors.transparent)




            ],
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _publishModal,
          child: CustomScrollView(slivers: <Widget>[
            ApplicantAppBar(
            add: (){verifyVendor();},
            camera: (){capture();},
              upload: (){
              print('ccs');
              _uploadVehicalReg();},
          ),
      SliverList(
            delegate: SliverChildListDelegate([
            SingleChildScrollView(
              child: Column(

                children: <Widget>[



                  _image == null
                      ? Text('')
                      : Container(
                      width: kImageWidth,
                      height: kImageHeight,
                      decoration:  BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:  FileImage(_image!)
                          )
                      )
                  ),

              space(),
              Dot(title: kFName,name: AdminConstants.vendorDetails[0]['fn'].toString().toUpperCase(),),

                  space(),
                  Dot(title: kLName,name: AdminConstants.vendorDetails[0]['ln'].toString().toUpperCase(),),

                  space(),
                  Dot(title: kEmail2,name: AdminConstants.vendorDetails[0]['email'],),
                  space(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SvgPicture.asset('assets/imagesFolder/dot.svg',height: MediaQuery.of(context).size.height * 0.02),
                        SizedBox(width: kHorizontal,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            TextWidget(
                              name: 'Phone Number',
                              textColor: kRadioColor,
                              textSize: kFontSize14,
                              textWeight: FontWeight.w400,),

                            TextWidget(
                              name: '${AdminConstants.vendorDetails[0]['ph']}',
                              textColor: kTextColor,
                              textSize: kFontSize,
                              textWeight: FontWeight.w500,),



                          ],
                        ),

                      ],
                    ),
                  ),

              space(),


                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SvgPicture.asset('assets/imagesFolder/dot.svg',height: MediaQuery.of(context).size.height * 0.02,),
                        SizedBox(width: kHorizontal,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextWidget(
                              name: kAddress,
                              textColor: kRadioColor,
                              textSize: kFontSize14,
                              textWeight: FontWeight.w400,),

                            Container(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: ScreenUtil()
                                      .setWidth(250),
                                  minHeight: ScreenUtil()
                                      .setHeight(20),
                                ),
                                child: ReadMoreText(
                                  AdminConstants.vendorDetails[0]['str'],
                                  //doc.data['desc'],
                                  trimLines: 1,
                                  colorClickableText: kLightBrown,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: ' ...',
                                  trimExpandedText: '  less',
                                  style: GoogleFonts.oxanium(
                                      fontSize: ScreenUtil().setSp(kFontSize, ),
                                      color: kTextColor,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),
                  space(),

                  Dot(title: kCompanyName2,name: AdminConstants.vendorDetails[0]['cn'],),

                  space(),
                  Dot(title: kCanUDrive,name: AdminConstants.vendorDetails[0]['drv'],),

                  space(),

                  Dot(title: kMOT,name: AdminConstants.vendorDetails[0]['mt'] == kModeTrans5?'Vendor has no vehicle':AdminConstants.vendorDetails[0]['mt'],),

                  space(),

                  Dot(title: 'Licence $kIssuedDate',name: AdminConstants.vendorDetails[0]['iss'] == null?'Vendor has no driving licence':AdminConstants.vendorDetails[0]['iss'],),

                  space(),

                  Dot(title: 'Licence $kExpiringDate',name: AdminConstants.vendorDetails[0]['exp'] == null?'Vendor has no driving licence':AdminConstants.vendorDetails[0]['exp'],),
                  space(),

                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: TextWidget(
                      name: 'Licence Image',
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w400,
                    ),
                  ),
                  space(),



                  AdminConstants.vendorDetails[0]['limg']== null?TextWidget(
                    name: 'vendor has No Licence Image',
                    textColor: kRadioColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w400,
                  ): GestureDetector(
                    onTap: (){getSizes();},
                    child: AnimatedSize(
                      curve: Curves.easeIn,
                      vsync: this,
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        width: _width,
                        height:_height,
                        //color: Variables.numItems.contains(Variables.newItems[i])?kLightBrown:Colors.transparent,
                        child: FadeInImage.assetNetwork(

                          image: AdminConstants.vendorDetails[0]['limg'].toString(),
                          placeholder: 'assets/imagesFolder/loading4.gif',

                          //placeholder: (context, url) => SvgPicture.asset('assets/imagesFolder/loading4.gif'),
                          imageErrorBuilder: (context, url, error) => SvgPicture.asset('assets/imagesFolder/loading4.gif'),
                          width: 50.0.w,
                          height: 70.0.h,
                          fit: BoxFit.cover,

                        ),
                      ),
                    ),
                  ),

                space(),
                ]
    ),
            )
    ]
    )
      )
    ]
    ),
        )
    )
    );
  }
  void getSizes() {
    //reSize.clear();
    if(_resized ){
      setState(() {
        _resized = false;
        _height = 100.0;
        _width = 80.0;
      });
    }else{

      setState(() {
        _resized = true;

        _height = 350.0;
        _width = 300.0;
      });
    }
  }
  void verifyVendor() {

    //check if vendor means of delivery is none

if((AdminConstants.vendorDetails[0]['mt'] == kModeTrans5) && (radioItem == '')){
  showDialog(
        context: context,
        builder: (context) =>
      SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        title: TextWidgetAlign(
          name: 'Means of delivery'.toUpperCase(),
          textColor: kLightBrown,
          textSize: 20,
          textWeight: FontWeight.bold,
        ),
        children: <Widget>[
          RadioListTile(
            groupValue: radioItem,
            title:TextWidget(
              name: kModeTrans2,
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.w400,
            ),
            value: 'vehicle',
            onChanged: (dynamic val) {
             setState(() {
               radioItem = val;
             });

            },
          ),

          RadioListTile(
            groupValue: radioItem,
            title: TextWidget(
              name: kModeTrans3,
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.w400,
            ),
            value: 'byke',
            onChanged: (dynamic val) {
setState(() {
  radioItem = val;
});
            },
          ),

          Container(
              margin: EdgeInsets.symmetric(horizontal: 30),

              child: NewBtn(nextFunction:(){
                updateVerify();
              }, bgColor: kLightBrown, title: 'Ok'))
        ],
      ));
}else{

    VariablesOne.showMyVendorVerify(context: context,yesClick: (){updateVerify();});

  }}

  Future<void> updateVerify() async {
    Navigator.pop(context);
    setState(() {
      _publishModal = true;
    });
    if (_image == null) {
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: 'Capture have not taken place',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 5,
          textColor: kRedColor);
    } else if (licenceReg.length == 0){
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: 'Upload vendor vehicle licence registration',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 5,
          textColor: kRedColor);
  }else{
      try {
        Reference ref = FirebaseStorage.instance.ref().child(filePath);

        uploadTask = ref.putFile(_image!);

        final TaskSnapshot downloadUrl = await uploadTask;
        final String url = await downloadUrl.ref.getDownloadURL();

        //upload reg

        for(int i = 0; i < licenceReg.length; i++){
          Reference ref = FirebaseStorage.instance.ref().child(filePath);

          uploadTask = ref.putFile(licenceReg[i]);

          final TaskSnapshot downloadUrl = await uploadTask;
          final String url = await downloadUrl.ref.getDownloadURL();
          licenceRegUrl.add(url);
          print(licenceRegUrl);
        }

        FirebaseFirestore.instance
            .collectionGroup('companyVendors')
            .where('vId', isEqualTo: AdminConstants.vendorDetails[0]['vId'])
            .get().then((value) {
          value.docs.forEach((result) {
            result.reference.update({
              'appr': true,
              'biz': AdminConstants.bizName,
              'cbi': AdminConstants.category ==
                  AdminConstants.admin.toLowerCase()
                  ? AdminConstants.ownerUid
                  : Variables.userUid,
              'pix': url,
              'reg':licenceRegUrl,
              'mt':AdminConstants.vendorDetails[0]['mt'] == kModeTrans5 ?radioItem:AdminConstants.vendorDetails[0]['mt'],
            });
          });
        });

       FirebaseFirestore.instance
            .collection('userReg')
            .doc(AdminConstants.vendorDetails[0]['vId'])
            .set({
          'reg': false,
          'rate': 1.0,
          'cud': AdminConstants.category ==
              AdminConstants.admin.toLowerCase()
              ? AdminConstants.ownerUid
              : Variables.userUid,
          'biz': AdminConstants.bizName,
          'ven':true,
          'er':0,
         'pix':url,
       },SetOptions(merge: true));
         sendEmailToVendor();


      } catch (e) {
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            timeInSecForIosWeb: 5,
            textColor: kRedColor);
      }
    }
  }
  Future<void> capture() async {

    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> sendEmailToVendor() async {



     var msgHtml = "<h3 style='color:orange;'>SOSURE GAS</h3>\n<p style='colors:LightGray;font-size:14px;'>Dear <strong style='color:darkBlue;'>${AdminConstants.vendorDetails[0]['fn']} ${AdminConstants.vendorDetails[0]['ln']}.</strong> Congratulations! You are now a vendor with <h3 style='color:orange;'>SOSURE GAS</h3> </p>";
     var emailRev = AdminConstants.vendorDetails[0]['email'];



    // Create our message.
    final message = Message()
      ..from = Address(username, kSosure)
      ..recipients.add(emailRev)
      ..subject = '$kSosure vendor 😀'
      ..html = msgHtml;
    try {
      final sendTitle =  await send(message, smtpServer);
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: 'Successfully Approved',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 5,
          textColor: kGreenColor);
      Navigator.pop(context, 'Done');
    }on MailerException catch (e) {
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: 'Successfully Approved',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 5,
          textColor: kGreenColor);
      Navigator.pop(context, 'Done');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<void> _uploadVehicalReg() async {
    //uploading all the vehicles reg
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _licenceImage = File(pickedFile.path);
        print(_licenceImage);
        licenceReg.add(_licenceImage!);
        print(licenceReg);
        VariablesOne.notify(title: 'Added successfully. Tap again to add as much as you want');
      } else {
        print('No image selected.');
      }
    });
  }

}


class Dot extends StatelessWidget {
  Dot({required this.title, required this.name});
  final String title;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
      SvgPicture.asset('assets/imagesFolder/dot.svg',height: MediaQuery.of(context).size.height * 0.02,),
          SizedBox(width: kHorizontal,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              TextWidget(
                name: title,
                textColor: kRadioColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,),

              TextWidget(
                name: name,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,),


            ],
          ),

        ],
      ),
    );




  }
}
