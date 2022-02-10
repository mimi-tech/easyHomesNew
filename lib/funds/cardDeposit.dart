import 'dart:convert';
import 'dart:io';
import 'dart:math';

//import 'package:card_scanner/card_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/back_credit_card.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/credit_card.dart';
import 'package:easy_homes/funds/fund_appbar.dart';
import 'package:easy_homes/funds/number_filter.dart';
import 'package:easy_homes/funds/validator.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/match_vendor.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/loading.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
class CardDeposit extends StatefulWidget {
  CardDeposit({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _CardDepositState createState() => new _CardDepositState();
}

class _CardDepositState extends State<CardDeposit> with SingleTickerProviderStateMixin{
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCardDetails();
  var _autoValidate = false;
  //late CardDetails _cardDetails;
bool progress = false;
  bool checkCvv = false;
  var walletEarning;
var buffer;
  late Map<String,dynamic> jsonDecoded;
  TextEditingController _exp = TextEditingController();
  TextEditingController _cvv = TextEditingController();
  TextEditingController _name = TextEditingController();
bool progress2 = false;
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05,);
  }
  late Gradient backgroundGradientColor;
  Color cardBgColor = kLightDoneColor;
  var _card = new PaymentCardDetails();
  var binCardNumber;
  String number = '8888 8888 8888 8888';
  String exp = '00 / 00';
  String cvv = '888';
  String name = 'CARD HOLDER';
dynamic customerCardLastDigit;
  dynamic customerCardType;
 late bool customerCardValid;
  dynamic authorization;
  dynamic customerCardFirstDigit;


  late AnimationController controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  @override
  void initState() {
    super.initState();
     PaystackPlugin().initialize(publicKey: Variables.cloud!['pk']);

    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _paymentCard.type = CardTypeDetails.Others;
    numberController.addListener(_getCardTypeFrmNumber);

    numberController.addListener(() {

      if(numberController.text.isNotEmpty ){
        setState(() {
          //number = _number.text;
          number =  numberController.text;

        });
      }else{
        setState(() {
          number = '8888 8888 8888 8888';
        });
      }
    });

    _exp.addListener(() {
      if(_exp.text.isNotEmpty ){
        setState(() {
          exp = _exp.text;

        });
      }else{
        setState(() {
          exp = '00 / 00';

        });
      }
    });

    _cvv.addListener(() {
      if(_cvv.text.isNotEmpty ){
        setState(() {
          cvv = _exp.text;

        });
      }else{
        cvv = '888';
      }
    });

    _name.addListener(() {
      if(_name.text.isNotEmpty ){
        setState(() {
          name = _name.text;

        });
      }else{
        setState(() {
          name = 'CARD HOLDER';

        });
      }
    });
    ///Initialize the Front to back rotation tween sequence.
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
    if (checkCvv) {
      controller.forward();
    } else {
      controller.reverse();
    }
    return  SafeArea(
      child: Scaffold(
//        key: _scaffoldKey,
          appBar: CardAppBar(),

          body: ProgressHUDFunction(
            inAsyncCall: progress,
            child: Column(
              children: [

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidgetAlign(
                      name: 'Enter card details',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w400,
                    ),
                  ),
                ),
                checkCvv?Container(

                  decoration: BoxDecoration(
                    image:  DecorationImage(
                      image:  AssetImage('assets/imagesFolder/loading2.gif'),
                      //fit: BoxFit.cover,
                    ),

                    //gradient: backgroundGradientColor,
                  ),
                  child: AnimationCard(
                    animation:checkCvv?_backRotation:_frontRotation ,

                    child: BackCreditCard(

                      cardCvv: cvv,
                      cIcon: CardUtils.getCardIcon(_paymentCard.type!),
                    ),
                  ),
                ):
                Container(
                  decoration: BoxDecoration(
                    image:  DecorationImage(
                      image:  AssetImage('assets/imagesFolder/loading2.gif'),
                      //fit: BoxFit.cover,
                    ),

                    //gradient: backgroundGradientColor,
                  ),
                  child: AnimationCard(
                    animation:checkCvv?_backRotation:_frontRotation ,
                    child: MineCreditCard(
                        cNumber: number,
                        cDate: exp,
                        cName: name,
                        cIcon: CardUtils.getCardIcon(_paymentCard.type!),

                      ),
                  ),
                ),

                //space(),

                Flexible(

                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:  Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topRight,
                                  child: TextWidgetAlign(
                                    name: 'Scan card'.toUpperCase(),
                                    textColor: kTextColor,
                                    textSize: kFontSize14,
                                    textWeight: FontWeight.normal,
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: numberController,
                                  autocorrect: true,
                                  cursorColor: (kTextFieldBorderColor),
                                  textInputAction: TextInputAction.next,
                                  onTap: (){
                                    setState(() {
                                      checkCvv = false;
                                    });
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(19),
                                    CardNumberInputFormatter()
                                  ],
                                  //controller: numberController,
                                  decoration:InputDecoration(

                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                            onTap: (){scanCard();},
                                            child: SvgPicture.asset('assets/imagesFolder/photograph.svg',height: 20,width: 20,)),
                                      ),

                                      labelText: 'Card number',
                                      labelStyle:GoogleFonts.oxanium(
                                        fontSize: ScreenUtil().setSp(kFontSize14, ),
                                        color: kTextColor,
                                      ),
                                      //  icon: CardUtils.getCardIcon(_paymentCard.type),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 18.0, 20.0, 18.0),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              kBorder)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kLightBrown))
                                  ),
                                  onSaved: (String? value) {
                                    _paymentCard.number = CardUtils.getCleanedNumber(value!);
                                  },
                                  validator: CardUtils.validateCardNum,
                                ),
                                space(),


                                TextFormField(
                                  controller: _name,
                                  autocorrect: true,
                                  cursorColor: (kTextFieldBorderColor),
                                   onTap: (){
                                     setState(() {
                                       checkCvv = false;
                                     });
                                   },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.sentences,
                                  style: Fonts.textSize,
                                  decoration: Variables.cardNameInput,
                                  onSaved: (String? value) {
                                    name = value!;
                                  },
                                  validator: Validator.validateCardName,
                                ),
                                space(),



                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.45,

                                      child: TextFormField(
                                        controller: _exp,
                                        autocorrect: true,
                                        textInputAction: TextInputAction.next,

                                        onTap: (){
                                          setState(() {
                                            checkCvv = false;
                                          });
                                        },


                                        cursorColor: (kTextFieldBorderColor),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,

                                           LengthLimitingTextInputFormatter(4),
                                           CardMonthInputFormatter()
                                        ],
                                        decoration: Variables.ExpInput,

                                        validator: CardUtils.validateDate,
                                        onSaved: (value) {
                                          List<int> expiryDate = CardUtils.getExpiryDate(value!);
                                          _paymentCard.month = expiryDate[0];
                                          _paymentCard.year = expiryDate[1];
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.45,

                                      child: TextFormField(
                                        controller: _cvv,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,

                                          LengthLimitingTextInputFormatter(4),
                                        ],
                                        decoration: Variables.cvvInput,

                                        validator: CardUtils.validateCVV,
                                        keyboardType: TextInputType.number,
                                        onTap: (){
                                          setState(() {
                                            checkCvv = true;
                                          });
                                        },
                                        onChanged: (value) {
                                          cvv = value;
                                        },
                                        onSaved: (value) {
                                          _paymentCard.cvv = int.parse(value!);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                space(),

                                SizedBtn(nextFunction:(){_validateInputs();

                                }, bgColor: kLightBrown, title: 'Fund NGN ${VariablesOne.numberFormat.format(Deposit.amount)}'.toUpperCase())
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    controller.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardTypeDetails cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  Future<void> _validateInputs() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });

    } else {
      form.save();
      //change back the credit card to front view
      print('yyyyyyyyyyyyy');
      setState(() {
        checkCvv = false;
      });

      setState(() {
        progress = true;
      });

 binCardNumber = _paymentCard.number!.substring(0,6);

//check if the card is valid
      try{
        String url ="https://api.paystack.co/decision/bin/$binCardNumber";

        http.Response res = await http.get(Uri.parse(url),
            headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});

        if (res.statusCode == 200) {
         jsonDecoded = json.decode(res.body);

          //if card is valid, charge the card
          Charge charge = Charge();
          charge.card = _getCardFromUI();
          //call payStack
          charge
            ..amount = Deposit.amount! // In base currency
            ..email = '${Variables.currentUser[0]['email']}'
            ..card = _getCardFromUI()
            ..reference = _getReference()

            ..putCustomField('Charged From', kSosure);
          _chargeCard(charge);


        }else{
          VariablesOne.notifyErrorBot(title:kResolveBank5 );
         Navigator.pop(context);
        }
      }catch(e){
        VariablesOne.notifyErrorBot(title:kError );
        Navigator.pop(context);
      }




    }
  }

  _chargeCard(Charge charge) async {
    final response = await PaystackPlugin().chargeCard(context, charge: charge);

    //final reference = response.reference;

    // Checking if the transaction is successful
    if (response.message == 'Success') {

      customerCardLastDigit = response.card!.last4Digits;
      customerCardType = response.card!.type;
      customerCardValid = response.card!.isValid();




      //transaction is successful, verify transaction
      String url = "https://api.paystack.co/transaction/verify/${response.reference}";

      http.Response res = await http.get(Uri.parse(url),
          headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});

      if (res.statusCode == 200) {
        print(res.body);
        print(res.statusCode);

        final Map<String,dynamic> jsonDecoded = json.decode(res.body);
        authorization = jsonDecoded['data']['authorization']['authorization_code'];
        customerCardFirstDigit = jsonDecoded['data']['authorization']['bin'];

        //save current card
        currentCard(jsonDecoded);

        getCardDetails();

        askSaveCard();
        sendNotification();

        setState(() {
          Variables.currentUser[0]['wal'] =  Variables.currentUser[0]['wal'] + Deposit.amount;
        });
        //check if the funding is coming directly from ordering gas
        if(VariablesOne.fundingOrder  == true){
          Fluttertoast.showToast(
              msg: 'Funding successful',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackColor,
              textColor: kGreenColor);
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: VendorCustomerMatch()));
         setState(() {
           VariablesOne.fundingOrder = false;
         });
        }else{
               Fluttertoast.showToast(
              msg: 'Funding successful',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackColor,
              textColor: kGreenColor);

          //take the user to dashboard
         /* Navigator.pop(context);
          Navigator.pop(context);*/

        }
      }else{
        Navigator.pop(context);
      }




    }else{
      //transaction failed
      setState(() {
        progress = false;

      });
      print(response.status);
      print(response.message);
      Navigator.pop(context);

      Fluttertoast.showToast(
          msg: 'Not successful,please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }


  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }




  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: numberController.text.trim(),
      cvc: _cvv.text.trim(),
      expiryMonth: _paymentCard.month,
      expiryYear: _paymentCard.year,
      name: _name.text.trim()
    );
  }


 /* _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }*/


  Future<void> scanCard() async {
    /*var cardDetails = await CardScanner.scanCard(
        scanOptions: CardScanOptions(scanCardHolderName: true, scanExpiryDate: true));

    if (!mounted)
      return;
    setState(() {
      _cardDetails = cardDetails;
    });
    if(_cardDetails != null){

      setState(() {
        numberController.text = _cardDetails.cardNumber;

        _exp.text = _cardDetails.expiryDate;
        _name.text =  _cardDetails.cardHolderName;
        number = _cardDetails.cardNumber;
        exp =  _cardDetails.expiryDate;
        name = _cardDetails.cardHolderName;

        buffer = new StringBuffer();
        for (int i = 0; i < numberController.text.length; i++) {
          buffer.write(numberController.text[i]);
          var nonZeroIndex = i + 1;
          if (nonZeroIndex % 4 == 0 && nonZeroIndex != numberController.text.length) {
            buffer.write('  '); // Add double spaces.
          }}
        numberController.text = buffer.toString();
      });

    }*/
  }

  Future<void> getCardDetails() async {
    //hash cards details


//add amount to user wallet

   try{
     FirebaseFirestore.instance.collection('userReg').doc(Variables.currentUser[0]['ud']).get()
         .then((resultEarnings) {

       walletEarning = resultEarnings.data()!['wal'] + Deposit.amount;

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
     DocumentReference documentReference =  FirebaseFirestore.instance.collection('History').doc();
     documentReference.set({
       'id':documentReference.id,
       'ud':Variables.currentUser[0]['ud'],
       'amt':Deposit.amount,
       'ts':DateTime.now().toString(),
       'dp': kDeposit,
       'dpp':kDeposit,
       'dpw': kWith,
     });



   }catch (e){
     setState(() {
       progress = false;
     });
   }



    }

  void saveCard() {

    showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'Save Card'.toUpperCase(),
          contentText: 'Do you want to save your card?',
          onPositiveClick: () {
            Navigator.of(context).pop();
          },
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
          actions: [
            progress2?PlatformCircularProgressIndicator():NewBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kRadioColor, title: 'No'),

            progress2?Text(''): NewBtn(nextFunction: (){_yesSaveCard();}, bgColor: kLightBrown, title: 'Yes')
          ],

        );


      },
      animationType: DialogTransitionType.slideFromRightFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );

  }

  void _yesSaveCard() {
    Navigator.pop(context);
    setState(() {
      progress2 = true;
    });

try{

  DocumentReference doc =  FirebaseFirestore.instance.collection
('stack').doc();
  doc.set({
    'id':doc.id,
    'ud':Variables.currentUser[0]['ud'],
    'cc':numberController.text.trim(),
    'cv':_cvv.text.trim(),
    'mt':_paymentCard.month,
    'yr':_paymentCard.year,
    'na':_name.text.trim(),
    'la':customerCardLastDigit,
    'va':customerCardValid,
    'ty':jsonDecoded['data']['brand'].toString().toLowerCase(),//customerCardType,
    'su':true,
    'aut':authorization,
    'fd':customerCardFirstDigit,
    'dt':DateTime.now(),
  });


  Fluttertoast.showToast(
      msg: 'Saved successfully',
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: kBlackColor,
      textColor: kGreenColor);
  setState(() {
    progress2 = false;
  });

}catch(e){
  setState(() {
    progress2 = false;
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

  void currentCard(Map<String,dynamic > jsonDecoded) {
    //update user current active card
    try {
      FirebaseFirestore.instance.collection('userReg').doc(Variables.currentUser[0]['ud']).set({
        'pay':true,
        'ccn': numberController.text.trim(),
        'ccv':_cvv.text.trim(),
        'cyr': _paymentCard.year,
        'cmt': _paymentCard.month,
        'cna':_name.text.trim(),
        'aut':authorization,
        'ctid':jsonDecoded['data']['customer']['id'],
        'ls': binCardNumber


      },SetOptions(merge: true));
    }catch(e){

    }
  }

  Future<void> askSaveCard() async {
    //check if  users card exist
try{
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('stack')
        .where('ud', isEqualTo: Variables.currentUser[0]['ud'])
        .where('cv', isEqualTo: _cvv.text.trim())
        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {

      //save users card
      setState(() {
        progress = false;
      });
      saveCard();


    }


  }catch(e){
  }
  }


}