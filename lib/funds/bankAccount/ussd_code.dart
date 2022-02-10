import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/fund_appbar.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/match_vendor.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
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

class USSDCode extends StatefulWidget {
  USSDCode({required this.jsonBody,required this.mapBody,});
  final Map<String,dynamic> jsonBody;
  dynamic mapBody;

  @override
  _USSDCodeState createState() => _USSDCodeState();
}

class _USSDCodeState extends State<USSDCode> {
  bool _publishModal = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
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
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: CardAppBar(),
        body: ProgressHUDFunction(
          inAsyncCall: _publishModal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimationSlide(
                  title: TextWidgetAlign(
                    name: "Dial the code below to complete the payment:",

                    textColor: kLightBrown,
                    textSize: 20,
                    textWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 60),

              TextWidgetAlign(
                name: widget.mapBody['authorization']['note'],
                textColor: kTextColor,
                textSize: 30,
                textWeight: FontWeight.bold,
              ),

              SizedBox(height: 60),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: "Payment code:  ",
                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize, ),
                    color: kTextColor,
                  ),            children: [
                  TextSpan(
                      text: widget.jsonBody['data']['payment_code'],
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil()
                            .setSp(22, ),
                        color: kTextColor,
                      )),
                ],
                ),
              ),
              SizedBox(height: 60),
              NewBtn(nextFunction:(){verifyTxn();}, bgColor: kLightBrown, title: 'I have made the transfer')

            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyTxn() async {

    setState(() {
      _publishModal = true;
    });
    try{
      String url = "https://api.flutterwave.com/v3/transactions/${widget.jsonBody['data']['id']}/verify";

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
          VariablesOne.fundingOrder = false;
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: VendorCustomerMatch()));
        }else{
          VariablesOne.notify(title:kResolveBank3 );

          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);

        }
      }else{
        setState(() {
          _publishModal = false;
        });
        VariablesOne.notifyErrorBot(title:kResolveBank4 );
        notSuccessful();
      }
    }catch(e){
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
