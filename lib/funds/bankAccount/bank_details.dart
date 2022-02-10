import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/bankAccount/enter_otp.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/fund_appbar.dart';
import 'package:easy_homes/funds/headings.dart';
import 'package:easy_homes/pay_api/core/core_utils/flutterwave_api_utils.dart';
import 'package:easy_homes/pay_api/models/responses/get_bank/get_bank_response.dart';
//import 'package:easy_homes/pay_api/core/models/responses/get_bank/get_bank_response.dart';


import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/match_vendor.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sticky_headers/sticky_headers.dart';

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

class CustomerBankDetails extends StatefulWidget {


  @override
  CustomerBankDetailsState createState() => CustomerBankDetailsState();
}

class CustomerBankDetailsState extends State<CustomerBankDetails> {
   GetBanksResponse? selectedBank;
   PersistentBottomSheetController? bottomSheet;
   Future<List<GetBanksResponse>>? banks;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _accountNumberController =
  TextEditingController();
  final TextEditingController _bankController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _phoneNumberController.text = Variables.currentUser[0]['ph'];
    this.banks = FlutterwaveAPIUtils.getBanks(http.Client());

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    super.dispose();
    this._accountNumberController.dispose();
    this._phoneNumberController.dispose();
    this._bankController.dispose();
  }
  Widget space() {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.05,
    );
  }
  bool _publishModal = false;

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
    this._bankController.text =
    // ignore: unnecessary_null_comparison
    (this.selectedBank != null ? this.selectedBank!.bankname : "")!;
    return SafeArea(
      //debugShowCheckedModeBanner: widget._paymentManager.isDebugMode,
      child: Scaffold(
        key: this._scaffoldKey,
        appBar: CardAppBar(),

        body: ProgressHUDFunction(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Center(
                    child: TextWidgetAlign(
                      name: 'Payment with bank'.toUpperCase(),
                      textColor: kLightBrown,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: this._formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        FormHeading(
                          title: 'Your mobile number',
                        ),
                        TextFormField(
                          cursorColor: kLightBrown,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          style: Fonts.textSize,
                          decoration: Variables.bankPhoneNumber,

                          controller: this._phoneNumberController,
                          validator: (value) =>
                          value!.isEmpty ? "Phone Number is required" : null,
                        ),
                        space(),

                        FormHeading(
                          title: 'Please choose your bank',
                        ),

                        TextFormField(
                          onTap: this._showBottomSheet,
                          readOnly: true,
                          cursorColor: kLightBrown,

                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          style: Fonts.textSize,
                          decoration: Variables.bankAccountNumber,
                          controller: this._bankController,
                          validator: (value) =>
                          value!.isEmpty ? "Bank is required" : null,
                        ),
                        space(),

                        FormHeading(
                          title: 'Please enter account number',
                        ),

                        TextFormField(
                          cursorColor: kLightBrown,

                          style: Fonts.textSize,
                          decoration: Variables.bankAccountNumber2,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          controller: this._accountNumberController,
                          validator: (value) =>
                          value!.isEmpty ? "Account Number is required" : null,
                        ),
                        space(),
                        space(),

                        SizedBtn(nextFunction: (){
                          verifyDetails();
                        }, bgColor: kLightBrown, title: 'fund NGN ${VariablesOne.numberFormat.format(Deposit.amount)}'.toUpperCase())


                        /* Container(
                          width: double.infinity,
                          height: 50,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: RaisedButton(
                            onPressed: this._onPaymentClicked,
                            color: Colors.orangeAccent,
                            child: Text(
                              "PAY WITH ACCOUNT",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _banks() {
    return FutureBuilder(
        future: this.banks,
        builder: (BuildContext context,
            AsyncSnapshot<List<GetBanksResponse>> snapshot) {
          if (snapshot.hasData) {
            return this._bankLists(snapshot.data!);
          }
          if (snapshot.hasError) {
            return Center(child: Text("Unable to fetch banks."));
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _bankLists(final List<GetBanksResponse> banks) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,

      child: SingleChildScrollView(
        child: Column(
          children: [
            StickyHeader(
                header:  AdminHeader(title: 'Choose your bank'.toUpperCase(),),


                content:ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: banks.map((bank) => GestureDetector(
                    onTap: () => {this._handleBankTap(bank)},
                    child: Column(
                        children: [

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.ac_unit,color: kLightBrown,),
                                  SizedBox(width: 10,),
                                  TextWidget(
                                    name: bank.bankname!,
                                    textColor: kDoneColor,
                                    textSize: kFontSize12,
                                    textWeight: FontWeight.w500,
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
                  )
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }


  void _showBottomSheet() {
    Platform.isIOS?
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
           this._banks()

      ],
      );
    })
        :showModalBottomSheet(
      context: this.context,
      isDismissible: true,
      builder: (context) {
        return this._banks();
      },
    );
  }

  void _handleBankTap(final GetBanksResponse selectedBank) {
    this._removeFocusFromView();
    this.setState(() {
      this.selectedBank = selectedBank;
    });
    Navigator.pop(this.context);
  }

  void _removeFocusFromView() {
    FocusScope.of(this.context).requestFocus(FocusNode());
  }

  Future<void> verifyDetails() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      _publishModal = true;
    });
//resolve account number
    try{
    String urlCheck = Deposit.resolveAccount;
    Map<String, String> headersCheck = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['fsk']}'};
    var bodyCheck = json.encode ({'account_number': _accountNumberController.text.trim(), 'account_bank': selectedBank!.bankcode});
    Response responseCheck = await post(urlCheck as Uri, headers: headersCheck, body: bodyCheck);

    if(responseCheck.statusCode == 200) {
      final Map<String,dynamic> jsonDecoded = json.decode(responseCheck.body);

      initiatePayment(jsonDecoded);
  }else{
      setState(() {
        _publishModal = false;
      });
      VariablesOne.notifyErrorBot(title:kResolveBank );
    }
  }catch(e){
      setState(() {
        _publishModal = false;
      });
      VariablesOne.notifyErrorBot(title: kError);

    }
  }
///initiating the payment
  Future<void> initiatePayment(Map<String,dynamic> jsonDecoded) async {

    try{
      String urlCheck = Deposit.initiatePayment;
      Map<String, String> headersCheck = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['fsk']}'};
      var bodyCheck = json.encode ({
        'account_number': _accountNumberController.text.trim(),
        'account_bank': selectedBank!.bankcode,
        "tx_ref":DateTime.now().toIso8601String(),
        "amount":Deposit.amount.toString(),
        "currency":"NGN",
        "email":Variables.currentUser[0]['email'],
        "phone_number":_phoneNumberController.text.trim(),
        "fullname":'${Variables.currentUser[0]['fn']} ${Variables.currentUser[0]['ln']}'
      });
      Response responseCheck = await post(urlCheck as Uri, headers: headersCheck, body: bodyCheck);
      if(responseCheck.statusCode == 200) {
        final Map<String,dynamic> jsonDecoded = json.decode(responseCheck.body);

        callOtp(jsonDecoded);

      }else{
        setState(() {
          _publishModal = false;
        });
        VariablesOne.notifyErrorBot(title: kResolveBank2);

      }

    }catch(e){
      setState(() {
        _publishModal = false;
      });
      print('lll$e');
      VariablesOne.notifyErrorBot(title: kError);

    }

  }

  void callOtp(Map<String,dynamic> jsonDecoded) {
    //show a bottom that will tell you to enter otp
    setState(() {
      _publishModal = false;
    });
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => RequestForOTP(next: (){_validateOtp(jsonDecoded);},)
    );
  }

  //check if otp is correct
  Future<void> _validateOtp(Map<String, dynamic> jsonDecoded) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    Navigator.pop(context);
    setState(() {
      _publishModal = true;
    });
    try{
      String urlCheck = Deposit.checkOtp;
      Map<String, String> headersCheck = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['fsk']}'};
      var bodyCheck = json.encode ({
        'otp':  Deposit.otpText,
        'flw_ref': jsonDecoded['data']['flw_ref'],
        'type':'account'
      });
      Response responseCheck = await post(urlCheck as Uri, headers: headersCheck, body: bodyCheck);

      if(responseCheck.statusCode == 200) {
        final Map<String,dynamic> jsonDecoded = json.decode(responseCheck.body);

        verifySuccessTxn(jsonDecoded);
      }else{
        setState(() {
          _publishModal = false;
        });
        VariablesOne.notifyErrorBot(title: 'OTP error');

      }
      }catch(e){
      setState(() {
        _publishModal = false;
      });
      VariablesOne.notifyErrorBot(title: kError);

    }

  }

  Future<void> verifySuccessTxn(Map<String, dynamic> jsonDecoded) async {
    setState(() {
      _publishModal = true;
    });
    try{
    String url = "https://api.flutterwave.com/v3/transactions/${jsonDecoded['data']['id']}/verify";

    http.Response res = await http.get(Uri.parse(url),
        headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['fsk']}'});
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
        Navigator.pop(context);

      }
    }else{
      setState(() {
        _publishModal = false;
      });
      VariablesOne.notifyErrorBot(title:kResolveBank4 );

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





