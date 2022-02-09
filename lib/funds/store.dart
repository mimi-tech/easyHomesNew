import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/dashboard_page.dart';
import 'package:easy_homes/dashboard/vendor/today_earning.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/cardDeposit.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/fund_appbar.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/utils/encrypt.dart';
import 'package:easy_homes/utils/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
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


class CardListStore extends StatefulWidget {
  @override
  _CardListStoreState createState() => _CardListStoreState();
}

class _CardListStoreState extends State<CardListStore> {
  final MethodChannel platform =
  MethodChannel('crossingthestreams.io/resourceResolver');

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCards();

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }
  var itemsData = <dynamic>[];
   var _documents = <DocumentSnapshot>[];
bool prog = false;
  bool progress = false;
bool fund = false;
    List<dynamic> currentCard = <dynamic>[];
  late int currentCardDetails;

  String? decryptedNumber;

  @override
  Widget build(BuildContext context) {
    return progress?Loading():SafeArea(child: Scaffold(
      //backgroundColor: kLightBrown,
        appBar: CardAppBar(),

        body: itemsData.length == 0 && prog == false ?Center(child: PlatformCircularProgressIndicator()):
        itemsData.length == 0 && prog == true ? ErrorTitle(errorTitle:'No card have been saved'):SingleChildScrollView(
          child: Column(

            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextWidgetAlign(
                  name: 'Please select the card you want to use and fund your wallet',
                  textColor: kDoneColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                ),
              ),


              ListView.builder(
              physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: _documents.length,
          itemBuilder: (context, int index) {
            return ListTile(
              leading:currentCard.contains(index)?
              IconButton(icon: Icon(
                Icons.radio_button_on, color: kTextColor,),
                  onPressed: () {})
                  : IconButton(icon: Icon(
                Icons.radio_button_unchecked, color: kTextColor,),
                  onPressed: () {
                    particularCard(index,_documents);
                  }),
              title: Row(
                children: [
                  itemsData[index]['ty'] == 'visa' ? SvgPicture.asset(
                    'assets/imagesFolder/visa2.svg', height: 10,
                    width: 10,) : SvgPicture.asset(
                    'assets/imagesFolder/master_card.svg',),
                  SizedBox(width: 5,),
                  TextWidget(
                    name: '${itemsData[index]['fd']} .... .... ${itemsData[index]['la']}',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ],
              ),
              trailing: IconButton(
                  icon: Icon(Icons.cancel, color: kTextColor,),
                  onPressed: () {
                    _removeCard(index,_documents);
                  }),
            );
          }

    ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              NewBtn(nextFunction: (){
                Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: CardDeposit()));

              }, bgColor: kLightBrown, title: 'Add new card'),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
             fund? SizedBtn(nextFunction: (){

               fundMyWallet();
              }, bgColor: kGreenColor, title: 'Fund NGN ${VariablesOne.numberFormat.format(Deposit.amount)}'):Text(''),


            ],
          ),
        )

    ));
  }

  Future<void> getCards() async {
      itemsData.clear();
      final QuerySnapshot result = await FirebaseFirestore.instance
.collection('stack')
          .where('ud', isEqualTo: Variables.currentUser[0]['ud'])
          .where('su',isEqualTo: true).orderBy('dt',descending: true)
          .get();

      final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
  Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: CardDeposit()));

  setState(() {
          prog = true;
        });


} else {

        for (DocumentSnapshot document in documents) {
          setState(() {
            itemsData.add(document.data());
            _documents.add(document);
          });
          print(document.data());
        }
      }
  }


  void _removeCard(int index, List<DocumentSnapshot> itemsData) {
    if(itemsData[index]['cv'] == Variables.currentUser[0]['ccv']){

      try{
        FirebaseFirestore.instance.collection('stack').doc(itemsData[index]['id']).delete();
        setState(() {
          _documents.removeAt(index);

        });

        FirebaseFirestore.instance.collection('userReg').doc(Variables.currentUser[0]['ud']).update({
          'pay':false,
        });
        setState(() {
          Variables.currentUser[0]['pay'] = false;
          _documents.removeAt(index);

        });
        Fluttertoast.showToast(
            msg: kCardDelete,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: kBlackColor,
            textColor: kGreenColor);

      }catch(e){

      }

    }else{
      try{
        FirebaseFirestore.instance.collection('stack').doc(itemsData[index]['id']).delete();
        setState(() {
          _documents.removeAt(index);

        });
        Fluttertoast.showToast(
            msg: kCardDelete,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: kBlackColor,
            textColor: kGreenColor);

      }catch(e){

      }}
  }

  void particularCard(int index,List<DocumentSnapshot> document) {

    setState(() {
      fund = true;
      currentCard.clear();
      currentCardDetails = index;

      currentCard.add(index);
    });

  }

  Future<void> fundMyWallet() async {

    setState(() {
      progress = true;
    });

    //check if the card has such an amount

    String urlCheck = 'https://api.paystack.co/transaction/check_authorization';
    Map<String, String> headersCheck = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'};
    var bodyCheck = json.encode ({'email': '${Variables.currentUser[0]['email']}', 'amount': Deposit.amount.toString(), 'authorization_code': itemsData[currentCardDetails]['aut'],});
// make POST request
    Response responseCheck = await post(Uri.parse(urlCheck), headers: headersCheck, body: bodyCheck);
    if(responseCheck.statusCode == 200) {



    //chargeCard

    String url = 'https://api.paystack.co/transaction/charge_authorization';
    Map<String, String> headers = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'};
    var body = json.encode ({'authorization_code': itemsData[currentCardDetails]['aut'], 'email': '${Variables.currentUser[0]['email']}', 'amount': Deposit.amount.toString()});
// make POST request
    Response response = await post(Uri.parse(url), headers: headers, body: body);
    if(response.statusCode == 200){
      final Map<String,dynamic> jsonDecoded = json.decode(response.body);

      saveAmount();
      saveCard(jsonDecoded);


    }else{
      BotToast.showSimpleNotification(title: kCardError,
          duration: Duration(seconds: 5),
          titleStyle:TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil()
                .setSp(kFontSize, ),
            color: kDarkRedColor,
          ));
    }
  }else{
      VariablesOne.notifyErrorBot(title: 'Sorry insufficient fund');
    }

  }


  void saveCard(Map<String,dynamic > jsonDecoded) {


  //save this card as the current card
    try {
      FirebaseFirestore.instance.collection('userReg').doc(
          Variables.currentUser[0]['ud']).set({
        'pay':true,
        'ccn': itemsData[currentCardDetails]['cc'],
        'ccv': itemsData[currentCardDetails]['cv'],
        'cyr': itemsData[currentCardDetails]['yr'],
        'cmt': itemsData[currentCardDetails]['mt'],
        'cna': itemsData[currentCardDetails]['na'],
        'aut': itemsData[currentCardDetails]['aut'],
        'ctid':jsonDecoded['data']['customer']['id'],

      },SetOptions(merge: true));

      setState(() {
        progress = false;
      });

      Fluttertoast.showToast(
          msg: 'Wallet funded successful',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

      setState(() {
        Variables.currentUser[0]['wal'] =  Variables.currentUser[0]['wal'] + Deposit.amount;
      });

      Navigator.pop(context);
      Navigator.pop(context);
    }catch(e){
      setState(() {
        progress = false;
      });
    }
  }

  Future<void> giveNotification() async {
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

  void saveAmount() {
    try {
      FirebaseFirestore.instance
          .collection('userReg').doc(Variables.currentUser[0]['ud']).get()
          .then((resultEarnings) {
        var walletEarning = resultEarnings.data()!['wal'] + Deposit.amount;

        resultEarnings.reference.set({
          'wal': walletEarning,
        },SetOptions(merge: true));
      });

      if(Variables.userCat == AdminConstants.business){

        FirebaseFirestore.instance
            .collection('AllBusiness')
            .where('ud', isEqualTo:  Variables.currentUser[0]['ud'])
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
      DocumentReference documentReference = FirebaseFirestore.instance.collection('History').doc();
      documentReference.set({
        'id': documentReference.id,
        'ud': Variables.currentUser[0]['ud'],
        'amt': Deposit.amount,
        'ts': DateTime.now().toString(),
        'dp': kDeposit,
        'dpp':kDeposit,
        'dpw': kWith,
      });
      giveNotification();
    }catch(e){

    }
  }


}
