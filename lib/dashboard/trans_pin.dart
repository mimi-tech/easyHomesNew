import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easy_homes/utils/encrypt.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

late NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

class TransactionPin extends StatefulWidget {
  @override
  _TransactionPinState createState() => _TransactionPinState();
}

class _TransactionPinState extends State<TransactionPin> {



  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();


  final TextEditingController _reEntertController = TextEditingController();
  final FocusNode _reEnterFocusNode = FocusNode();
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  String? rePin;
bool progress = false;
  Widget animatingBorders() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: kWhiteColor,
      border: Border.all(color: kTextFieldBorderColor),
      borderRadius: BorderRadius.circular(15),

    );
    return PinPut(

      autofocus: true,
      //validator: Variables.validatePin,
      obscureText: '*',
      fieldsCount: 6,
      eachFieldHeight: 20,
      onSubmit: (String pine) {
        Variables.mobilePin = pine;
      },
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration:
      pinPutDecoration.copyWith(borderRadius: BorderRadius.circular(20)),
      pinAnimationType: PinAnimationType.slide,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: kTextFieldBorderColor,
        ),
      ),
    );
  }



  Widget reEnterPin() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: kWhiteColor,
      border: Border.all(color: kTextFieldBorderColor),
      borderRadius: BorderRadius.circular(15),

    );
    return PinPut(

      autofocus: true,
      //validator: Variables.validatePin,
      obscureText: '*',
      fieldsCount: 6,
      eachFieldHeight: 20,
      onSubmit: (String pine) {
        rePin = pine;
      },
      focusNode: _reEnterFocusNode,
      controller: _reEntertController,
      submittedFieldDecoration:
      pinPutDecoration.copyWith(borderRadius: BorderRadius.circular(20)),
      pinAnimationType: PinAnimationType.slide,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: kTextFieldBorderColor,
        ),
      ),
    );
  }




  final MethodChannel platform = MethodChannel('crossingthestreams.io/resourceResolver');


  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      );
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
  }






  @override
  Widget build(BuildContext context) {
    return progress == true?Loading():SafeArea(child: PlatformScaffold(

        appBar: PlatformAppBar(
          backgroundColor: kWhiteColor,
          leading: GestureDetector(
              onTap: (){Navigator.pop(context);},
              child: Icon(Icons.arrow_back, size:30,color: kBlackColor,)),
          title:  TextWidget(
            name: Variables.currentUser[0]['tx'] == null?'Create Pin'.toUpperCase():kRestPin.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[

          spacer(),

          LogoDesign(),

          spacer(),

          TextWidget(
            name: Variables.currentUser[0]['tx'] == null?'Enter Your Transaction Pin':'Enter your new transaction pin',
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w400,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: animatingBorders(),
          ),


          spacer(),
          TextWidget(
            name: 'Re-Enter Your Transaction Pin',
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w400,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: reEnterPin(),
          ),

          GestureDetector(
            onTap: () {
              _pinPutController.text = '';
              _reEntertController.text = '';

            },
            child: Text(kEditMobileClear,
              style: GoogleFonts.oxanium(
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(
                    kFontSize, ),
                color: kLightBrown,
              ),
            ),
          ),
          spacer(),
          BtnSecond(title: 'Create', nextFunction: () {
            moveToNext();
          }, bgColor: kDoneColor,),



          spacer(),

        ],
      ),
    )));
  }

  Future<void> moveToNext() async {

    if ((_reEntertController.text.length == 0) || (_pinPutController.text.length == 0)) {
      Fluttertoast.showToast(
          msg: 'Please enter your Transaction pin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);

    }else if (_reEntertController.text != _pinPutController.text ){
      Fluttertoast.showToast(
          msg: 'Pin does not match',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);
    }else{
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      setState(() {
        progress = true;
      });

      try{

        final encrypter = Encryption.encryptAes(_pinPutController.text);



        FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid)
            .set({
          'tx':encrypter.base64,
        },SetOptions(merge: true));
        setState(() {
          progress = false;
        });
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreenSecond(),
          ),
              (route) => false,
        );


        Fluttertoast.showToast(
            msg: 'Pin created successfully',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            timeInSecForIosWeb: 10,
            textColor: kGreenColor);



        var scheduledNotificationDateTime =
        DateTime.now().add(Duration(minutes: 1));
        var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your other channel id',
            'your other channel name', 'your other channel description');
        var iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
        NotificationDetails platformChannelSpecifics = NotificationDetails(
            android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.schedule(
            0,
            'Reset Pin',
            '${Variables.userFN!} you pin reset was successful',
            scheduledNotificationDateTime,
            platformChannelSpecifics);


      }catch(e){
        setState(() {
          progress = false;
        });
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            timeInSecForIosWeb: 10,
            textColor: kRedColor);
      }


    }
  }
}
