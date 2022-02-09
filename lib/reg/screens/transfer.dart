import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/loading.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';

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

class TransferScreen extends StatefulWidget {

  TransferScreen({required this.doc});

  final DocumentSnapshot doc;

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.05);
  }
  Color btnColor = kTextFieldBorderColor;
  TextEditingController _amt = TextEditingController();

  late String amount;
bool _publishModal = false;
  var currentDate = new DateTime.now();




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
    return _publishModal == true?Loading():SafeArea(child: PlatformScaffold(
        appBar: PlatformAppBar(
          backgroundColor: kWhiteColor,
         leading: GestureDetector(
             onTap: (){
               Navigator.pop(context);
             },
             child: Icon(Icons.arrow_back,size: 30,color: kBlackColor,)),
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextWidget(
                name: 'Transfer cash'.toUpperCase(),
                textColor: kLightBrown,
                textSize: 20,
                textWeight: FontWeight.bold,
              ),



            ],
          ),
        ),

        body: SingleChildScrollView(

      child: Column(
        children: <Widget>[


          Card(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child:  Column(
                children: [
                  TextWidgetAlign(
                    name: 'Wallet balance',
                    textColor: kTextColor,
                    textSize: 20,
                    textWeight: FontWeight.bold,

                  ),
                  SizedBox(height: 10,),
                  TextWidget(
                      name: 'NGN ${VariablesOne.numberFormat.format(Variables.currentUser[0]['wal']).toString()}',
                      textColor: kSeaGreen,
                      textSize: 14,
                      textWeight: FontWeight.w500,

                  ),
                ],
              ),
            ),
          ),
          spacer(),
          TextWidgetAlign(
            name: 'Dear ${Variables.userFN!} ${Variables.userLN}',
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(

                  text: 'You are sending money to ',

                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.normal,
                    fontSize: ScreenUtil().setSp(
                        kFontSize, ),
                    color: kTextColor,
                  ),

                  children: <TextSpan>[
                    TextSpan(text: '${widget.doc['fn']} ${widget.doc['ln']}',
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(
                            22, ),
                        color: kDoneColor,
                      ),)
                  ]
              ),
            ),
          ),
          spacer(),


          Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: Platform.isIOS
                  ? CupertinoTextField(
                controller: _amt,
                autocorrect: true,
                autofocus: true,

                keyboardType: TextInputType.emailAddress,
                cursorColor: (kTextFieldBorderColor),
                style: Fonts.textSize,
                placeholderStyle: GoogleFonts.oxanium(
                  fontSize: ScreenUtil().setSp(
                      kFontSize, ),
                  color: kHintColor,
                ),
                placeholder: 'Enter Amount',
                onChanged: (String value) {
                  Variables.email = value;
                  if (_amt.text.length == 0) {
                    setState(() {
                      btnColor = kTextFieldBorderColor;
                    });
                  } else {
                    setState(() {
                      btnColor = kDoneColor;
                    });
                  }
                },
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorder),
                    border: Border.all(color: kLightBrown)),
              )
                  : TextField(
                controller: _amt,
                autocorrect: true,
                autofocus: true,
                cursorColor: (kTextFieldBorderColor),
                keyboardType: TextInputType.number,
                style: Fonts.textSize,
                inputFormatters: <TextInputFormatter>[
                   FilteringTextInputFormatter.digitsOnly
                ],
                decoration: Variables.amountInput,
                onChanged: (String value) {
                  amount = value;
                  if (_amt.text.length == 0) {
                    setState(() {
                      btnColor = kTextFieldBorderColor;
                    });
                  } else {
                    setState(() {
                      btnColor = kDoneColor;
                    });
                  }
                },
              )),

          spacer(),

          BtnSecond(title: 'Proceed', nextFunction: () {


            nextModal();
          }, bgColor: btnColor,),

          spacer(),
        ],
      ),
    )

    ));
  }

  Future<void> nextModal() async {


    if ((_amt.text == null) || (_amt.text.isEmpty)) {
      Fluttertoast.showToast(
          msg: 'Please enter the amount you want to transfer',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);
    } else if(Variables.currentUser[0]['wal'] < int.parse(amount)) {
      Fluttertoast.showToast(
          msg: 'Sorry, insufficient fund',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);
    }else {


      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      setState(() {
        _publishModal = true;
      });

      /*add the money to the reciepient wallet*/

      try{

        FirebaseFirestore.instance.collection('userReg').doc(widget.doc['ud'])
        .update({
          'wal':widget.doc['wal'] + int.parse(amount),
        });


        /*minus the money from current logged in account*/

        FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid).update({
          'wal':Variables.currentUser[0]['wal'] - int.parse(amount),
        });

        /*update transaction history for current user*/
        DocumentReference documentReference = FirebaseFirestore.instance.collection('History').doc();
        documentReference.set({
          'id':documentReference.id,
          'ts':DateTime.now().toString(),
          'dp':kTrans,
          'amt':int.parse(amount),
          'ud':Variables.userUid,

        });

        /*update transaction history for recipient user*/
        DocumentReference doc = FirebaseFirestore.instance.collection('History').doc();
        doc.set({
          'id':doc.id,

          'ts':DateTime.now().toString(),
          'dp':kTrans2,
          'amt':int.parse(amount),
          'ud':widget.doc['ud'],

        });

        setState(() {
          _publishModal = false;
          Variables.currentUser[0]['wal'] = Variables.currentUser[0]['wal'] - int.parse(amount);
        });
        Navigator.pop(context);
        /*Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: HomeScreenSecond()));
*/
        Fluttertoast.showToast(
            msg: 'Transfer successful',
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
            'Transfer Successful',
            'Your transaction with ${widget.doc['fn']} ${widget.doc['ln']} was successful',
            scheduledNotificationDateTime,
            platformChannelSpecifics);




      }catch(e){
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: 'Transfer not successful',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            timeInSecForIosWeb: 10,
            textColor: kRedColor);
      }







    }
  }
}
