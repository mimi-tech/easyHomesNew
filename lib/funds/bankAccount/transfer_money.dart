import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:animations/animations.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/fund_appbar.dart';

import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/match_vendor.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

late  NotificationAppLaunchDetails notificationAppLaunchDetails;

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

class AccountDetailsTransfer extends StatefulWidget {

  @override
  _AccountDetailsTransferState createState() => _AccountDetailsTransferState();
}

class _AccountDetailsTransferState extends State<AccountDetailsTransfer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBankAccount();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }
  bool _publishModal = false;
  late Map<String,dynamic> jsonDecoded;
  var mapItems;
  dynamic number = '';
  dynamic name = '';
  dynamic bN = '';
  dynamic amount = '0';
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
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: CardAppBar(),

        body: ProgressHUDFunction(
          inAsyncCall: _publishModal,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Please make a bank transfer\n to this account".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil()
                        .setSp(17, ),
                    color: kDoneColor,
                  ),
                ),
              ),
              SizedBox(height: 70),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Amount",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize, ),
                              color: kRadioColor,
                            ),
                          ),
                          Text('${VariablesOne.numberFormat.format(Deposit.amount).toString()}',
                            textAlign: TextAlign.end,
                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize, ),
                              color: kTextColor,
                            ),                    ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Account Number",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize, ),
                            color: kRadioColor,
                          ),                    ),
                        Text(number,
                          textAlign: TextAlign.end,
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize, ),
                            color: kTextColor,
                          ),                    ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bank Name",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize, ),
                            color: kRadioColor,
                          ),                    ),
                        Text(name,
                          textAlign: TextAlign.end,
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize, ),
                            color: kTextColor,
                          ),                    ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Wrap(
                      //mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Text(
                          "Beneficiary Name",
                          //textAlign: TextAlign.start,
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize, ),
                            color: kRadioColor,
                          ),                    ),
                        Text(bN,
                          //textAlign: TextAlign.end,
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize, ),
                            color: kTextColor,
                          ),                    ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  NewBtn(nextFunction: (){verifyTransfer();}, bgColor: kLightBrown, title: 'I have made the transfer'),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getBankAccount() async {


    setState(() {
      _publishModal = true;
    });

    //call the transfer api

    try{
      String urlCheck = Deposit.checkTransfer;
      Map<String, String> headersCheck = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['fsk']}'};
      var bodyCheck = json.encode ({

        "tx_ref":DateTime.now().toIso8601String(),
        "amount":Deposit.amount.toString(),
        "email":Variables.currentUser[0]['email'],
        "phone_number":Variables.currentUser[0]['ph'],
        "currency":"NGN",
        "duration":2,
        "frequency":10,
        "narration":"wallet funding",
        "is_permanent":true

      });
      Response responseCheck = await post( Uri.parse(urlCheck), headers: headersCheck, body: bodyCheck);

      if(responseCheck.statusCode == 200) {


        setState(() {
          jsonDecoded = json.decode(responseCheck.body);

          mapItems = jsonDecoded['meta'];

          number = (mapItems['authorization']['transfer_account']);
          name = (mapItems['authorization']['transfer_bank']);
          bN = (mapItems['authorization']['transfer_note']);
          amount = (mapItems['authorization']['transfer_amount']);


              _publishModal = false;
        });
      }else{
        Navigator.pop(context);

        setState(() {
          _publishModal = false;
        });
        VariablesOne.notifyErrorBot(title: "Sorry service unavailable");
        notSuccessful();
      }

    }catch(e){
      print(e);
      Navigator.pop(context);

      setState(() {
        _publishModal = false;
      });

      VariablesOne.notifyErrorBot(title: kError);

    }
}

  Future<void> verifyTransfer() async {
    setState(() {
      _publishModal = true;
    });
    try{
      String url = "https://api.flutterwave.com/v3/transactions/${(mapItems['authorization']['transfer_reference'])}/verify";

      http.Response res = await http.get(Uri.parse(url),
          headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['fsk']}'});
      print(res.body);
      if (res.statusCode == 200) {
        setState(() {
          Variables.currentUser[0]['wal'] =  Variables.currentUser[0]['wal'] + Deposit.amount;
        });
        pushToHistory();
        sendNotification();
        setState(() {
          _publishModal = false;
        });
        if(VariablesOne.fundingOrder  == true){
          VariablesOne.notify(title:kResolveBank3 );


          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: VendorCustomerMatch()));

        }else{
          VariablesOne.notify(title:kResolveBank3 );

          Navigator.pop(context);
          //Navigator.pop(context);

        }
      }else{
        setState(() {
          _publishModal = false;
        });
        VariablesOne.notifyErrorBot(title:kResolveBank4 );

      }
    }catch(e){
      print(e);
      setState(() {
        _publishModal = false;
      });
      VariablesOne.notifyErrorBot(title: kError);

    }

  }

  void pushToHistory() {
    try{
      FirebaseFirestore.instance
          .collection('userReg').doc(Variables.currentUser[0]['ud']).get()
          .then((resultEarnings) {

        var walletEarning = resultEarnings.data()!['wal'] + Deposit.amount;

        resultEarnings.reference.set({
          'wal':walletEarning,
        },SetOptions(merge: true));
      });

      //check if the user is a vendor and also add the money to his vendor wallet
      if(Variables.currentUser[0]['ven'] == true){

        FirebaseFirestore.instance.collectionGroup('companyVendors')
            .where('vId', isEqualTo:  Variables.currentUser[0]['ud'])
            .get().then((value) {

          value.docs.forEach((result) {
            var walletEarning = result.data()['wal'] + Deposit.amount;

            result.reference.set({
              'wal': walletEarning,
            },SetOptions(merge: true));
          });
        });

      }


      //update history
      DocumentReference documentReference =  FirebaseFirestore.instance.collection
        ('History').doc();
      documentReference.set({
        'id':documentReference.id,
        'ud':Variables.currentUser[0]['ud'],
        'amt':Deposit.amount,
        'ts':DateTime.now().toString(),
        'dp': kDeposit,
        'dpp':kDeposit,
        'dpw': kWith,
      });
    }catch(e){
      print(e);
    }

  }

  Future<void> sendNotification() async {
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
        kWalletCredit1,
        'Dear ${Variables.userFN!} $kWalletCredit',
        scheduledNotificationDateTime,
        platformChannelSpecifics);

  }

  Future<void> notSuccessful() async {

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
        kWalletCredit1,
        'Dear ${Variables.userFN!} $kWalletCredit2',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

}
