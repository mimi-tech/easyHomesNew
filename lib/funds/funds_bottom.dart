
import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/bankAccount/screen_1.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/headings.dart';

import 'package:easy_homes/funds/validator.dart';

import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/utility/second_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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

class FundWallet extends StatefulWidget {
  @override
  _FundWalletState createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWallet> with SingleTickerProviderStateMixin {
  final String txref = DateTime.now().toIso8601String();

  // final String currency = FlutterwaveCurrency.NGN;


  /*var publicKey = 'FLWPUBK_TEST-26daeed55b6b7d7bb9f1f58342c625f8-X';
  var encryptionKey = 'FLWSECK_TESTcff64a33aa3b';*/
  //var secretKey = 'FLWSECK_TEST-07f2b0a3a6b46eeb39bfd389f08977eb-X';

  //final String txref = "My_unique_transaction_reference_123";
  //final String amount = "200";
  //final String currency = FlutterwaveCurrency.NGN;


  Widget space() {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.02,
    );
  }

  int amount = 0;

  TextEditingController _amount = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  final MethodChannel platform = MethodChannel(
      'crossingthestreams.io/resourceResolver');


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
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
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
    return SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery
                .of(context)
                .viewInsets,
            duration: const Duration(milliseconds: 600),
            curve: Curves.decelerate,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  space(),
                  space(),

                  WalletHeading(),
                  Divider(),
                  space(),
                  Center(
                    child: FormHeading(
                      title: 'Enter amount'.toUpperCase(),
                    ),
                  ),
                  space(),
                  Platform.isIOS ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: CupertinoTextField(
                      controller: _amount,
                      autocorrect: true,
                      cursorColor: (kTextFieldBorderColor),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,

                      ],

                      style: Fonts.textSize,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kBorder),
                          border: Border.all(color: kLightBrown)),

                      placeholderStyle: GoogleFonts.oxanium(
                        fontSize: ScreenUtil().setSp(kFontSize14,),
                        color: kBlackColor.withOpacity(0.6),
                      ),
                      placeholder: 'Not less than NGN 1000.00',

                      onChanged: (String value) {
                        //amount = int.parse(value);
                      },
                    ),
                  )
                      : Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: TextFormField(
                            controller: _amount,
                            autocorrect: true,
                            cursorColor: (kTextFieldBorderColor),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,

                            ],

                            style: Fonts.textSize,
                            decoration: Variables.amountInputs,
                            onSaved: (String? value) {
                              amount = int.parse(value!);
                            },

                            onChanged: (String value) {
                              //amount = int.parse(value);
                            },
                            validator: Validator.validateAMount,
                          )
                      )
                  ),

                  space(),
                  space(),

                  /* Divider(),
                  space(),


                  ListTile(

                    leading:
                    SvgPicture.asset('assets/imagesFolder/blue_card.svg'),
                    title: TextWidget(
                      name: 'Fund with card',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w400,
                    ),

                    onTap: () {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        setState(() {
                          Deposit.amount = amount;
                        });

                        if(Variables.currentUser[0]['pay'] == true){
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CardListStore()));

                        }else{
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CardDeposit()));

                        }}
                    },
                  ),
                  ListTile(
                    onTap: () {
                      payWithBank();
                    },
                    leading: SvgPicture.asset('assets/imagesFolder/bank.svg'),
                    title: TextWidget(
                      name: 'Fund with bank account',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w400,
                    ),
                  ),*/

                  Center(child: NewBtn(nextFunction: () {
                    Platform.isIOS ? payWithBankIos() :
                    payWithBank();
                  }, bgColor: kLightBrown, title: 'Next')),
                  space(),
                ])));
  }

  Future<void> payWithBank() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        Deposit.amount = amount;
      });
      Navigator.pop(context);
      Navigator.push(context, PageTransition(type: PageTransitionType.fade,
          child: PayWithBankAccountFlutterWave()));
    }
  }

  payWithBankIos() {
    Deposit.amount = int.parse(_amount.text);
    if ((_amount.text.length == 0) || (amount < 1000)) {
      VariablesOne.notifyFlutterToastError(
          title: "Amount must be more than 1000.00");
    } else {
      Navigator.pop(context);
      Navigator.push(context, PageTransition(type: PageTransitionType.fade,
          child: PayWithBankAccountFlutterWave()));
    }
  }
}

/*
      final Flutterwave flutterwave = Flutterwave.forUIPayment(
          context: this.context,
          encryptionKey:Variables.cloud!['fen'],
          publicKey:Variables.cloud!['fpk'],
          currency: this.currency,
          amount: Deposit.amount.toString(),
          email: Variables.currentUser[0]['email'],
          fullName: "${Variables.currentUser[0]['fn']} ${Variables.currentUser[0]['ln']}",
          txRef: this.txref,
          isDebugMode: true,
          phoneNumber: Variables.currentUser[0]['ph'],
             acceptBankTransferPayment: true,
          frequency: 2,
          narration: 'Funding with bank Transfer',
          duration: 2,
          //acceptCardPayment: true,
          acceptUSSDPayment: true,
          acceptAccountPayment: true,
          acceptFrancophoneMobileMoney: false,
          acceptGhanaPayment: false,
          acceptMpesaPayment: false,
          acceptRwandaMoneyPayment: false,
          acceptUgandaPayment: false,
          acceptZambiaPayment: false);*/

      /*try {
        final ChargeResponse response = await flutterwave.initializeForUiPayments();
        if (response == null) {
          // user didn't complete the transaction. Payment wasn't successful.
        } else {
          final isSuccessful = checkPaymentIsSuccessful(response);
          if (isSuccessful) {
            print('pppppppppp');

            pushToHistory();
            sendNotification();

            if(VariablesOne.fundingOrder  == true){
              Fluttertoast.showToast(
                  msg: 'Funding successful',
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: kBlackColor,
                  textColor: kGreenColor);

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: VendorCustomerMatch()));

            }else{
              Fluttertoast.showToast(
                  msg: 'Funding successful',
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: kBlackColor,
                  textColor: kGreenColor);
              Navigator.pop(context);

            }
*/

        /*  } else {
            Fluttertoast.showToast(
                msg: 'Funding  not successful',
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: kBlackColor,
                textColor: kRedColor);
            notSuccessful();

            // check message
            print(response.message);

            // check status
            print(response.status);

            // check processor error
            print(response.data.processorResponse);
          }
        }
      } catch (error, stacktrace) {
        // handleError(error);
        // print(stacktrace);
      }




  }}*/

 /* checkPaymentIsSuccessful(ChargeResponse response) {

    return response.data.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data.currency == this.currency &&
        response.data.amount == Deposit.amount.toString() &&
        response.data.txRef == this.txref;
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

      //check if the user is a business and also add the money to his business wallet
      if(Variables.userCat == AdminConstants.business){

        FirebaseFirestore.instance.collection('AllBusiness')
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

    }*/


/*
class CurrencyInputFormatter extends TextInputFormatter {

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if(newValue.selection.baseOffset == 0){
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value/100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}*/
