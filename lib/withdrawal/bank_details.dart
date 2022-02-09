import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utils/NGNbankList.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:easy_homes/utility/profile_pix.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/screens/successful.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:easy_homes/withdrawal/bvn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';
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


class UserWithdrawalDetails extends StatefulWidget {
  @override
  _UserWithdrawalDetailsState createState() => _UserWithdrawalDetailsState();
}

class _UserWithdrawalDetailsState extends State<UserWithdrawalDetails> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
  }
bool changeText = Variables.currentUser[0]['bvf'] == null?false:true;
  bool showName = false;
  bool progress = false;
  TextEditingController _actName = new TextEditingController();

  TextEditingController _actNumber = new TextEditingController();
  Color btnColor = kTextFieldBorderColor;
bool _publishModal = false;
  dynamic bankAccountName = '';
  dynamic bankAccountRes = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // PaystackPlugin.initialize(publicKey: publicKey);
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
    return SafeArea(child: PlatformScaffold(body: ModalProgressHUD(
      inAsyncCall: _publishModal,
      child: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Column(
              children: <Widget>[
                spacer(),
                BackLogo(),
                ProfilePicture(),

                spacer(),
                Center(
                  child: TextWidget(
                    name: kPaymentDetails3.toUpperCase(),
                    textColor: kLightBrown,
                    textSize: kFontSize,
                    textWeight: FontWeight.w600,
                  ),
                ),


                spacer(),
                Align(
                  alignment: Alignment.topLeft,
                  child: TextWidget(
                    name: 'Bank Name',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w600,
                  ),
                ),


                Platform.isIOS
                    ? GestureDetector(
                  onTap: (){_showBankNames();},
                  child: AbsorbPointer(
                    child: CupertinoTextField(

                      controller: VariablesOne.name,
                      autocorrect: true,
                      cursorColor: (kTextFieldBorderColor),
                      style: Fonts.textSize,
                      placeholderStyle: GoogleFonts.oxanium(
                        fontSize: ScreenUtil().setSp(
                            kFontSize, ),
                        color: kHintColor,
                      ),
                      placeholder: 'Bank name',
                      onChanged: (String value) {
                        VendorConstants.bankName = value;
                      },
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kBorder),
                          border: Border.all(color: kLightBrown)),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: (){_showBankNames();},
                  child: AbsorbPointer(
                    child: TextField(
                      onTap: (){_showBankNames();},
                      controller: VariablesOne.name,
                      autocorrect: true,
                      cursorColor: (kTextFieldBorderColor),
                      style: Fonts.textSize,
                      decoration: VendorConstants.bankNameInput,
                      onChanged: (String value) {
                        VendorConstants.bankName = value;
                      },

                    ),
                  ),
                ),


                /*back account Number*/

                spacer(),
                Align(
                  alignment: Alignment.topLeft,
                  child: TextWidget(
                    name: 'Bank Account Number',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w600,
                  ),
                ),
                Platform.isIOS
                    ? CupertinoTextField(
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: false,
                    signed: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _actNumber,
                  autocorrect: true,
                  maxLength: 10,
                  cursorColor: (kTextFieldBorderColor),
                  style: Fonts.textSize,
                  placeholderStyle: GoogleFonts.oxanium(
                    fontSize: ScreenUtil().setSp(
                        kFontSize, ),
                    color: kHintColor,
                  ),
                  placeholder: 'Enter your bank account number',
                  onChanged: (String value) {
                    VendorConstants.bankAccountNumber = int.parse(value);;

                    if ( _actNumber.text.length ==10) {
                      setState(() {
                        btnColor = kLightBrown;
                      });
                    } else {
                      setState(() {
                        btnColor = kTextFieldBorderColor;
                      });
                    }
                  },
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorder),
                      border: Border.all(color: kLightBrown)),
                )
                    : TextField(
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: false,
                    signed: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _actNumber,
                  maxLength: 10,
                  autocorrect: true,
                  cursorColor: (kTextFieldBorderColor),
                  style: Fonts.textSize,
                  decoration: VendorConstants.bankAccountNumberInput,
                  onChanged: (String value) {
                    VendorConstants.bankAccountNumber = int.parse(value);
                    if ( _actNumber.text.length ==10) {
                      setState(() {
                        btnColor = kLightBrown;
                      });
                    } else {
                      setState(() {
                        btnColor = kTextFieldBorderColor;
                      });
                    }

                  },

                ),



                spacer(),
                Visibility(
                    visible: showName,
                    child:Column(
                      children: [
                        Text('Account Name',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.oxanium(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize, ),
                            color: kDoneColor,
                          ),
                        ),
                        TextWidget(
                          name: bankAccountName,
                          textColor: kTextColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.w600,
                        ),
                      ],
                    )
                ),
                spacer(),

                
                Visibility(
                  visible: Variables.currentUser[0]['bvf'] == true?false:true,
                  child: TextWidgetAlign(
                  name: 'Note: Your BVN will be verified if amount is above NGN 50,000. Thanks.',
                  textColor: kTextColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w600,
                ),),

                spacer(),

                showName?NewBtn(nextFunction: () {
                  moveToNext();
                }, bgColor: btnColor,title: changeText?'Withdrawing...'.toUpperCase():'Verify bvn'.toUpperCase(),):
                progress?Center(child: PlatformCircularProgressIndicator()):NewBtn(nextFunction: () {
                  verify();
                }, bgColor: btnColor,title: 'verify Account number'.toUpperCase(),),
                spacer(),
                RichText(
                  text: TextSpan(
                      text: 'You are withdrawing ',
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil()
                            .setSp(kFontSize14, ),
                        color: kTextColor,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'NGN ${VariablesOne.numberFormat.format(Deposit.amount)}'.toString(),
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize14, ),
                            color: kSeaGreen,
                          ),
                        )
                      ]),
                ),

                spacer(),
                RichText(
                  text: TextSpan(
                      text: 'Amount remaining ',
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil()
                            .setSp(kFontSize14, ),
                        color: kTextColor,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'NGN ${VariablesOne.numberFormat.format(Variables.currentUser[0]['wal'] - Deposit.amount)}'.toString(),
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize14, ),
                            color: kYellow,
                          ),
                        )
                      ]),
                )

              ],
            )

        ),
      ),
    )));
  }

  Future<void> verify() async {
    if(VariablesOne.name.text.isEmpty){
      Fluttertoast.showToast(
          msg: kInputError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);

    }else if (_actNumber.text.isEmpty ){
      Fluttertoast.showToast(
          msg: kInputError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }

    else {
      setState(() {
        progress = true;
      });
//get the user bank name
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      String url = "https://api.paystack.co/bank/resolve?account_number=${_actNumber.text.trim()}&bank_code=${VendorConstants.bankNameCode}";
      http.Response res = await http.get(Uri.parse(url),
          headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});
      //headers:{"Authorization: Bearer"});
      //print(res.body);

      if (res.statusCode == 200) {
        final Map<String,dynamic> jsonDecoded = json.decode(res.body);
        setState(() {
          bankAccountName = jsonDecoded['data']['account_name'];
          VendorConstants.bankAccountName = jsonDecoded['data']['account_name'];
          progress = false;

          showName = true;
        });


        //print(jsonDecoded['account_name']);

        //print(jsonDecoded);
        /* setState(() {
          bankAccountName = jsonDecoded['account_name'];
          showName = true;
        });*/

      }else{
        setState(() {
          bankAccountName = "Sorry we could'nt resolve your bank details";
          progress = false;
          //showName = true;


        });
      }

    }


  }

  void _showBankNames() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    /*display a modal showing the names of bank in nigeria*/
    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          NGBankList()
        ],
      );
    })

        : showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => NGBankList()
    );

  }

  Future<void> moveToNext() async {
/*
setState(() {
  _publishModal = true;
});
*/




// set up withdrawal or check if bvn has been verified
String url = 'https://api.paystack.co/transferrecipient';
Map<String, String> headers = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'};
var body = json.encode ({'type': "nuban", 'name': '$bankAccountName', 'account_number': '${_actNumber.text.trim()}', 'bank_code': '${VendorConstants.bankNameCode}', 'currency': 'NGN'});
// make POST request
Response response = await post(Uri.parse(url), headers: headers, body: body);
    print(response.statusCode);

    if((response.statusCode == 201) || (response.statusCode == 200)){
      //print(response.body);
      final Map<String,dynamic> jsonDecoded = json.decode(response.body);
      bankAccountRes = jsonDecoded['data']['recipient_code'];
      //if amount to withdraw is above 50k
      if((Deposit.amount! >= 50000) && (Variables.currentUser[0]['bvf'] == null)) {
        verifyBvn();

      }else {
        makeWithdrawal();
      }
    }else{

      setState(() {
        _publishModal = false;
      });
    VariablesOne.notifyFlutterToastError(title: kError);
    }



  }

  Future<void> makeWithdrawal() async {

    setState(() {
      _publishModal = true;
    });
    String url = 'https://api.paystack.co/transfer';
    Map<String, String> headers = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'};
    var body = json.encode ({'source': "balance", 'amount': '${Deposit.amount.toString()}', 'recipient': '$bankAccountRes'});
// make POST request
    Response response = await post(Uri.parse(url), headers: headers, body: body);
     print(response.body);
     print(response.statusCode);
    if(response.statusCode == 200){
      final Map<String,dynamic> jsonDecoded = json.decode(response.body);
      print(jsonDecoded);

      getHistory(jsonDecoded);
    }else{

      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: 'Withdrawal not successful',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);    }
  }

  void getHistory(Map<String,dynamic> jsonDecoded) {
    try{
      FirebaseFirestore.instance
          .collection('userReg').doc(Variables.currentUser[0]['ud']).get()
          .then((resultEarnings) {

        var walletEarning = resultEarnings.data()!['wal'] - Deposit.amount;

        resultEarnings.reference.set({
          'wal':walletEarning,
          'bN': VendorConstants.bankName!.trim(),
          'bAct': VendorConstants.bankAccountName!.trim(),
          'bAN': VendorConstants.bankAccountNumber,
          'bkc':  VendorConstants.bankNameCode,
          //'rep': bankAccountRes,
          'ref':jsonDecoded['reference'],

          'refId':jsonDecoded['id'],
          'refc':jsonDecoded['transfer_code'],
          'rep':jsonDecoded['recipient'],
        },SetOptions(merge:true));
      });


      //check if the user is a business and also minus the money from his business wallet
      if(Variables.userCat == AdminConstants.business){

        FirebaseFirestore.instance.collection('AllBusiness')
            .where('ud', isEqualTo:  Variables.currentUser[0]['ud'])
            .get().then((value) {

          value.docs.forEach((result) {
            var walletEarning = result.data()['wal'] - Deposit.amount;

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
        'dp': kWith,
        'dpp':kDeposit,
        'dpw': kWith,
        'ref':jsonDecoded['reference'],
        'st':jsonDecoded['status']
      });
      setState(() {
        _publishModal = false;
      });
      sendNotification();
      Fluttertoast.showToast(
          msg: 'Withdrawal successful',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreenSecond(),
        ),
            (route) => false,
      );
    }catch(e){
    VariablesOne.notifyFlutterToastError(title: kError);
      setState(() {
        _publishModal = false;
      });
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

  Future<void> verifyBvn() async {
    //verify user bvn
    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          BvnScreen(verify:changeText?PlatformCircularProgressIndicator():BtnSecond(title:'Verify',nextFunction:(){userVerifyBvn();},bgColor: btnColor,),)
        ],
      );
    })

        : showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => changeText?PlatformCircularProgressIndicator(): BvnScreen(verify:BtnSecond(title:'Verify',nextFunction:(){userVerifyBvn();},bgColor: btnColor,),)

    );
  }

  Future<void> userVerifyBvn() async {
    if ((VendorConstants.bvn == null) && (VendorConstants.bvn == '')) {
      Fluttertoast.showToast(
          msg: kInputError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else {
        setState(() {
          changeText = true;
        });
//verify bvn
      String url = 'https://api.paystack.co/bvn/match';
      Map<String, String> headers = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'};
      var body = json.encode ({'bvn': VendorConstants.bvn, 'account_number': '${_actNumber.text.trim()}', 'bank_code': VendorConstants.bankNameCode});
// make POST request
      Response response = await post(Uri.parse(url), headers: headers, body: body);
      print(response.body);
      print(response.statusCode);
      if(response.statusCode == 200){
        //final Map<String,dynamic> jsonDecoded = json.decode(response.body);
        updateBvn();

        Navigator.pop(context);
        makeWithdrawal();

      }else{
        setState(() {
          changeText = false;
        });

        Fluttertoast.showToast(
            msg: 'Error verifying your bvn',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }

    }
  }

  void updateBvn() {
    //update userReg bvn true

    try {
      FirebaseFirestore.instance.collection
('userReg').doc(Variables.currentUser[0]['ud']).set({

        'bvf':true,
      },SetOptions(merge:true));

      Fluttertoast.showToast(
          msg: "Verified successfully",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

    }catch(e){

    }
  }
}
