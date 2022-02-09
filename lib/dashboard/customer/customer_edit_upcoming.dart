import 'dart:convert';
import 'dart:io';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/extacted_classes/enter_new_card.dart';
import 'package:easy_homes/payment/methods.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:http/http.dart' as http;

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/bookings/constructors/bookings_appbar.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/confirm_payment.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';

class CustomerEditUpcomingOrder extends StatefulWidget {
  @override
  _CustomerEditUpcomingOrderState createState() => _CustomerEditUpcomingOrderState();
}

class _CustomerEditUpcomingOrderState extends State<CustomerEditUpcomingOrder> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  int? kgTotal;
  TextEditingController _quantity = TextEditingController();
  TextEditingController _gasKg = TextEditingController();
  bool verify = false;
  dynamic count = 0;
  dynamic countKg = 0;
  bool progress = false;
  List<dynamic> itemsData = <dynamic>[];
  late List<dynamic> loadKg;
 late  List<dynamic> loadKg2;
  bool _publishModal = false;
  dynamic prize;
  List<Widget> getImages(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < loadKg.length; i++){
      Widget w = Column(
        children: [
          SizedBox(width: 100,),
          TextWidgetAlign(
            name: '${loadKg[i].toString()}Kg',
            textColor: kDoneColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,
          ),

          itemsData[0]['cQ'].length == 0 ?Text(''): TextWidgetAlign(
            name: '${itemsData[0]['cQ'][i].toString()}',
            textColor: kTextColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,
          ),
        ],

      );
      list.add(w);
    }
    return list;
  }

  List<Widget> getSecondKG(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < loadKg2.length; i++){
      Widget w = Column(
        children: [
          SizedBox(width: 100,),
          TextWidgetAlign(
            name: '${loadKg2[i].toString()}Kg',
            textColor: kDoneColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,
          ),

        ],

      );
      list.add(w);
    }
    return list;
  }
  bool showFirstContainer = true;
  bool gasKgIsChange = false;
  bool paymentTypeIsChanged = false;
  var expectedWeight = '';
  dynamic total;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();



  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: BookingAppBar(title:itemsData.length == 0?'Loading': itemsData[0]['bgt'],),

        body: itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
        itemsData.length == 0 && progress == true ? Center(child:  AnimationSlide(title: TextWidgetAlign(
          name:'Sorry no order to verify',
          textColor: kRedColor,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ),),): ModalProgressHUD(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                spacer(),
                Column(
                  children: [
                    AnimationSlide(title: TextWidgetAlign(
                      name:itemsData[0]['by']?'No of cylinder(s) you are buying': kCylinderQtyText,
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),),
                    spacer(),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.065,
                        decoration: BoxDecoration(
                          border: Border.all(color: kRadioColor,),

                        ),

                        child:  Center(
                          child: TextWidgetAlign(
                            name: itemsData[0]['ca'].toString(),
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,
                          ),
                        ),

                      ),
                    )
                  ],
                ),
                Divider(),
                Center(
                  child:  AnimationSlide(title:
                  itemsData[0]['re']?TextWidgetAlign(
                    name:   'Rented cylinder sizes & quantity',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ):


                  TextWidgetAlign(
                    name:  itemsData[0]['cQ'].length == 0 ?'Selected  cylinder sizes':'Selected new cylinder sizes & quantity',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                  ),
                ),

                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: getImages(),

                ),
                Center(
                  child:  AnimationSlide(title:
                  TextWidgetAlign(
                    name: loadKg2.length == 0 ?'':'Selected own cylinder sizes',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                  ),
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: getSecondKG(),

                ),
                Divider(),
                //spacer(),
                Column(
                  children: [
                    AnimationSlide(title:
                    TextWidgetAlign(
                      name: 'Total gas kg ( LPG )',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                    ),
                    spacer(),
                    itemsData[0]['by']?Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.065,
                        decoration: BoxDecoration(
                          border: Border.all(color: kRadioColor,),

                        ),



                        child:  Center(
                          child: TextWidgetAlign(
                            name: itemsData[0]['by']?'0':
                            gasKgIsChange == false? itemsData[0]['gk'].toString():_gasKg.text.toString(),
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ): Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      child: TextField(
                          controller: _gasKg,
                          autocorrect: true,
                          textAlign: TextAlign.center,

                          keyboardType: TextInputType.numberWithOptions(decimal: true),

                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]'))
                          ],
                          cursorColor: (kTextFieldBorderColor),
                          style: Fonts.textSize,
                          decoration: InputDecoration(


                              hintText: 'Enter the total gas kg',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color:kRadioColor),
                                  borderRadius: BorderRadius.circular(kBorder)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kLightBrown))

                          ),
                          onChanged: (String value) {
                            countKg = double.parse(value);
                            if(countKg > itemsData[0]['tc']){
                              Fluttertoast.showToast(
                                  msg: 'gas kg has exceeded',
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 10,
                                  backgroundColor: kBlackColor,
                                  textColor: kRedColor);
                            }

                          }
                      ),
                    ),
                    spacer(),
                    spacer(),

                    Center(
                      child: TextWidgetAlign(
                        name: 'Tare Weight (initial cylinder weight)',
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      child: TextField(
                          controller: _quantity,
                          autocorrect: true,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          readOnly: itemsData[0]['uo'] == true?true:false,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]'))
                          ],
                          cursorColor: (kTextFieldBorderColor),
                          style: Fonts.textSize,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color:kRadioColor),
                                  borderRadius: BorderRadius.circular(kBorder)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kLightBrown))

                          ),
                          onChanged: (String value) {
                            count = double.parse(value);

                          }

                      ),
                    ),




                  ],
                ),

                spacer(),
                _quantity.text.isEmpty? Text(''):
                Column(
                  children: [
                    spacer(),
                    Center(
                      child: TextWidgetAlign(
                        name: 'Expected total weight from vendor is',
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.065,
                        decoration: BoxDecoration(
                          border: Border.all(color: kRadioColor,),

                        ),
                        child:  Center(
                          child: TextWidgetAlign(
                            name:gasKgIsChange?'${int.parse(_quantity.text) + countKg}'.toString():'${int.parse(_quantity.text) + itemsData[0]['gk']}'.toString(),
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),





                spacer(),
                verify || itemsData[0]['uo'] == true?
                itemsData[0]['vf'] == true ?Text(''):SizedBtn(nextFunction: (){
                  if(itemsData[0]['gv'] == true){
                  _verifyOrder();
                  }else{
                    VariablesOne.notifyErrorBot(title: 'Please wait your cylinder have not been filled');

                  }

                  }, bgColor: kLightBrown, title: 'verify delivery')


                    : SizedBtn(nextFunction: (){

                      //check if time for delivery is now
                  bool checkDate = DateTime.parse(itemsData[0]['dd']).isBefore(DateTime.now());
                   if(checkDate) {
                     _updateOrder();
                   }else{
                     VariablesOne.notifyErrorBot(title: 'Sorry not yet time to update your order');
                   }

                      }, bgColor: kLightBrown, title: 'Update order'),
                spacer(),
              ],
            ),
          ),
        )));
  }

  Future<void> getDetails() async {
    itemsData.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collection('Upcoming')
        .where('cud',isEqualTo: Variables.userUid)
        .where('vf',isEqualTo: false)
        //.where('day',isGreaterThanOrEqualTo: DateFormat('d').format(DateTime.now()))
        .where('mth',isGreaterThanOrEqualTo:  DateFormat('MM').format(DateTime.now()))
        .where('yr',isEqualTo: DateFormat('yyyy').format(DateTime.now()))
        //.where('gv',isEqualTo: false )
        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
     for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {itemsData.add(document.data());
          loadKg = data['cKG'];
          loadKg2 = data['cKG2'];
          kgTotal = loadKg.length + loadKg2.length;
          _gasKg.text = itemsData[0]['gk'].toString();
        });
      }

    }

    _gasKg.addListener(() {
      if(itemsData[0]['gk'].toString() == _gasKg.text){
        gasKgIsChange = false;

      }else{
        gasKgIsChange = true;


      }

    });


    if( itemsData[0]['uo'] == true){
      _quantity.text = itemsData[0]['trw'].toString();
    }

  }

  Future<void> _verifyOrder() async {

    setState(() {
      _publishModal = true;
    });
    try {
      FirebaseFirestore.instance.collection('Upcoming')
          .doc(itemsData[0]['doc'])
          .update({
        'vf': true
      });
    } catch (e) {
      setState(() {
        _publishModal = true;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }

    //send the customer booking details to database if rent

    if(itemsData[0]['re'] == true){
      prize = itemsData[0]['pz'].fold(0, (previous, current) => previous + current);

      try{

        FirebaseFirestore.instance.collection("rent").doc(
            Variables.userUid).set({
          'ud':Variables.currentUser[0]['ud'],
          'fn':Variables.currentUser[0]['fn'],
          'ln':Variables.currentUser[0]['ln'],
          'ph':Variables.currentUser[0]['ph'],
          'pix':Variables.currentUser[0]['pix'],
          'ts':DateTime.now().toString(),

          're': FieldValue.arrayUnion([{
            'vfn': itemsData[0]['vfn'],
            'vln': itemsData[0]['vln'],
            'vpi': itemsData[0]['vpi'],
            'vph': itemsData[0]['vph'],
            'cm': itemsData[0]['cm'],
            'ad': itemsData[0]['ad'],

            'cKG': itemsData[0]['cKG'],
            'pz': prize,
            'dt':DateTime.now().toString(),
          }])

        },SetOptions(merge: true));
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: 'Order verified successfully',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 10,
            backgroundColor: kBlackColor,
            textColor: kGreenColor);
        Navigator.pop(context);


      }catch(e){
        Navigator.pop(context);

      }

    }else{
      Fluttertoast.showToast(
          msg: 'Order verified successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
      Navigator.pop(context);
    }



  }

  void _updateOrder() {
    print(count);
    if (_quantity.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please give us the tare weight of your cylinder',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else if(_gasKg.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please give us the actual gas kg you want to buy',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else{

//check if gas kg is greater than the total cylinder kg
      if(double.parse(_gasKg.text.trim()) > itemsData[0]['tc']){
        Fluttertoast.showToast(
            msg: 'gas kg has exceeded',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 10,
            backgroundColor: kBlackColor,
            textColor: kRedColor);


      }else{

        sendOrder();
      }




    }

  }

  void sendOrder(){

    //update tare weight to database
    if(gasKgIsChange == false){
      //show the customer the total amount of money to be paid in a bottomSheet
      showTotalAmountNotChanged();
      total = itemsData[0]['amt'];


    }else{
      var tt = countKg * itemsData[0]['gas'];
      dynamic amt = itemsData[0]['amt'] - itemsData[0]['aG'];
      total = tt + amt;

      //tell the user the total amount to be paid in connect screen
      var r = Variables.grandTotal - itemsData[0]['aG'];
      dynamic g = r + tt;
      setState(() {
        Variables.grandTotal = g;
      });


      //show the customer the total amount of money to be paid in a bottomSheet
      showTotalAmount(total);





    }




  }

  void showTotalAmount(total) {
    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          ConfirmCustomerPayment(amount: total,click: (){yesPay(total);},)
        ],
      );
    })

        : showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ConfirmCustomerPayment(amount: total,click: (){

          if(itemsData[0]['mp'] != kCard){
            //show the customer the total amount of money to be paid in a bottomSheet
            if(Variables.currentUser[0]['refact'] >= total){
              yesPay(total);

            }else{
              //choose another payment method
              VariablesOne.checkPayment = true;
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PaymentMethods()));

            }

            if(Variables.currentUser[0]['wal'] >= total){
              yesPay(total);

            }else{
              //choose another payment method
              VariablesOne.checkPayment = true;
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PaymentMethods()));

            }

          }else{
            //customer is paying with card

            takeMoneyFromCard();
          }



        }

          ,)
    );
  }

  void yesPay(total) {
    setState(() {
      _publishModal = true;
    });
    try{
      //the user changed the kg
      FirebaseFirestore.instance.collection('Upcoming').doc(itemsData[0]['doc']).set({
        'trw':_quantity.text.trim(),
        'ew':count + int.parse(_quantity.text),//count,
        'gk':double.parse(_gasKg.text.trim()),
        'aG':countKg * itemsData[0]['gas'],
        'amt': total,
        'uo':true,

      },SetOptions(merge: true));
      setState(() {
        _publishModal = false;
        verify = true;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Order updated successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
    }catch(e){
      setState(() {
        _publishModal = false;
      });
      VariablesOne.notifyFlutterToastError(title: kError);
    }
  }

  void showTotalAmountNotChanged() {
    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          ConfirmCustomerPayment(amount: itemsData[0]['amt'],click: (){yesPayNoChanges();},)
        ],
      );
    })

        : showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ConfirmCustomerPayment(amount: itemsData[0]['amt'],click: (){

          if(itemsData[0]['mp'] != kCard){
            //show the customer the total amount of money to be paid in a bottomSheet
            yesPayNoChanges();


          }else{
            //customer is paying with card

            takeMoneyFromCard();
          }



        },

        )
    );

  }

  void yesPayNoChanges() {
    setState(() {
      _publishModal = true;
    });



    try{
      //if the user did not change the kg
      FirebaseFirestore.instance.collection('Upcoming').doc(itemsData[0]['doc']).set({
        'trw':_quantity.text.trim(),
        'ew':int.parse(_quantity.text) + itemsData[0]['gk'],//count,
        'uo':true,


      },SetOptions(merge: true));
      setState(() {
        _publishModal = false;
        verify = true;

      });
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Order updated successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
    }catch(e){
      setState(() {
        _publishModal = false;
      });
      VariablesOne.notifyFlutterToastError(title: kError);
    }
  }

  Future<void> takeMoneyFromCard() async {
    setState(() {
      _publishModal = true;
    });
    //check if the card has been used before
    Navigator.pop(context);
    if(Variables.currentUser[0]['aut'] == null){
      //check if card is valid if the customer have entered card details

      //checkValidCard();
      enterNewCard();


    }else{


//check if the card has the required amount of money
      String? urlCheck = 'https://api.paystack.co/transaction/check_authorization';
      Map<String, String> headersCheck = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'};
      var bodyCheck = json.encode ({'email': '${Variables.currentUser[0]['email']}', 'amount': total.round(), 'authorization_code': Variables.currentUser[0]['aut'],});
// make POST request
      Response responseCheck = await post(urlCheck as Uri, headers: headersCheck, body: bodyCheck);
      if(responseCheck.statusCode == 200) {


//take the money from the card

        String url = 'https://api.paystack.co/transaction/charge_authorization';
        Map<String, String> headers = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'};
        var body = json.encode ({'authorization_code': Variables.currentUser[0]['aut'], 'email': '${Variables.currentUser[0]['email']}', 'amount': total.round()});
// make POST request
        Response response = await post(Uri.parse(url), headers: headers, body: body);
        if(response.statusCode == 200){
          final Map<String,dynamic> jsonDecoded = json.decode(response.body);

          //verify the transaction
          verifyTxnWithAuth(jsonDecoded);
        }else{


          setState(() {
            _publishModal = false;
          });

          BotToast.showSimpleNotification(title: kCardError,
              duration: Duration(seconds: 5),
              titleStyle:TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil()
                    .setSp(kFontSize, ),
                color: kDarkRedColor,
              ));

          paymentSuggestion();
        }
      }else{
        setState(() {
          _publishModal = false;
        });
        paymentSuggestion();

        VariablesOne.notifyErrorBot(title: 'Sorry insufficient funds');


      }



    }}

  void updateWallet() {


    try{
      FirebaseFirestore.instance
          .collection('userReg').doc(Variables.currentUser[0]['ud']).get()
          .then((resultEarnings) {

        var walletEarning = resultEarnings.data()!['wal'] + total.round();

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
            var walletEarning = result.data()['wal'] + total.round();

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
        'amt':total.round(),
        'ts':DateTime.now().toString(),
        'dp': kDeposit,
        'dpp':kDeposit,
        'dpw': kWith,
      });
      VariablesOne.notifyFlutterToast(title: 'Payment is successful');

      //update the database tha order has been verified

      if(gasKgIsChange == false){

        yesPayNoChanges();
      }else{
        yesPay(total);
      }

    }catch(e){
      setState(() {
        _publishModal = false;

      });
      VariablesOne.notifyFlutterToastError(title: kError);
    }
  }

  _chargeCard(Charge charge) async {
    try{
      final response = await PaystackPlugin().chargeCard(context, charge: charge);

      //final reference = response.reference;

      // Checking if the transaction is successful
      print(response);

      if (response.message == 'Success') {




        verifyTxn(response);


      }else{
        //transaction failed
        setState(() {
          _publishModal = false;

        });


        Fluttertoast.showToast(
            msg: 'Not successful,please try again',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
        paymentSuggestion();


      }
    }catch(e){
      print('kkkkkkk$e');
      //transaction failed
      setState(() {
        _publishModal = false;

      });


      Fluttertoast.showToast(
          msg: 'Not successful,please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
      paymentSuggestion();
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
    print(Variables.currentUser[0]);
    return PaymentCard(
        number: Variables.currentUser[0]['ccn'],
        cvc:  Variables.currentUser[0]['ccv'],
        expiryMonth:  Variables.currentUser[0]['cmt'],
        expiryYear: Variables.currentUser[0]['cyr'],
        name:  Variables.currentUser[0]['fn']
    );
  }

  void updateCard(CheckoutResponse response, Map<String,dynamic> jsonDecoded) {
    try {


      //save to stack

      DocumentReference doc =  FirebaseFirestore.instance.collection('stack').doc();
      doc.set({
        'id':doc.id,
        'ud':Variables.currentUser[0]['ud'],
        'cc': Variables.currentUser[0]['ccn'],
        'cv':Variables.currentUser[0]['ccv'],
        'mt':Variables.currentUser[0]['cmt'],
        'yr':Variables.currentUser[0]['cyr'],
        'uu':Variables.currentUser[0]['ccv'],
        'dt':DateTime.now(),
        'su': true,
        'aut': jsonDecoded['data']['authorization']['authorization_code'],
        'fd': jsonDecoded['data']['authorization']['bin'],
        'la': response.card!.last4Digits,
        'va': response.card!.isValid(),
        'ty': response.card!.type!.toLowerCase(),
      });

      FirebaseFirestore.instance.collection
        ('userReg').doc(Variables.currentUser[0]['ud']).set({

        'aut': jsonDecoded['data']['authorization']['authorization_code'],
        'pay':true,
        'ccn': Variables.currentUser[0]['ccn'],
        'ccv':Variables.currentUser[0]['ccv'],
        'cyr':  Variables.currentUser[0]['cyr'],
        'cmt': Variables.currentUser[0]['cmt'],
        'ctid':jsonDecoded['data']['customer']['id'],

      },SetOptions(merge: true));


    }catch(e){

    }
  }

  Future<void> verifyTxn(CheckoutResponse response) async {
    //transaction is successful, verify transaction
    String url = "https://api.paystack.co/transaction/verify/${response.reference}";

    http.Response res = await http.get(Uri.parse(url),
        headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});

    if (res.statusCode == 200) {
      print('999999${res.body}');

      final Map<String,dynamic> jsonDecoded = json.decode(res.body);

      //update current card
      updateCard(response,jsonDecoded);
      //update the user wallet
      updateWallet();


    }else{
      setState(() {
        _publishModal = false;

      });

      Fluttertoast.showToast(
          msg: 'Not successful,please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
      paymentSuggestion();

    }


  }

  Future<void> verifyTxnWithAuth(Map<String,dynamic> jsonDecoded) async {
    String url = "https://api.paystack.co/transaction/verify/${jsonDecoded['data']['reference']}";

    http.Response res = await http.get(Uri.parse(url), headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});

    if (res.statusCode == 200) {

      //update the user wallet
      updateWallet();


    }else{
      setState(() {
        _publishModal = false;

      });

      Fluttertoast.showToast(
          msg: 'Not successful,please try again',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
      paymentSuggestion();


    }

  }

  void paymentSuggestion() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    VariablesOne.showMyDialog(context:context,yesClick: (){changePaymentType();}, noClick: (){
      Navigator.pop(context);
      print('ddd');
      enterNewCard();
    }
    );
  }

  void changePaymentType() {
    Navigator.pop(context);
    setState(() {
      _publishModal = true;
    });
    try {
      //change method of payment to cash
      FirebaseFirestore.instance.collection('customer')
          .doc(itemsData[0]['vid'])
          .set({
        'mp': kCash,


      }, SetOptions(merge: true));
    }catch(e){
      setState(() {
        _publishModal = false;
      });
      VariablesOne.notifyFlutterToastError(title: kError);
    }
    //update the database tha order has been verified

    if(gasKgIsChange == false){

      yesPayNoChanges();
    }else{
      yesPay(total);
    }

  }



  void chargeRawCard() {
    Charge charge = Charge();
    charge.card = _getCardFromUI();
    //call payStack
    charge
      ..amount = total.round()// In base currency
      ..email = '${Variables.currentUser[0]['email']}'
      ..card = _getCardFromUI()
      ..reference = _getReference()
      ..putCustomField('Charged From', kSosure);
    _chargeCard(charge);

  }

  Future<void> checkValidCard() async {
    setState(() {
      _publishModal = true;
    });
    print('ddd');
    var binCardNumber = Variables.currentUser[0]['ls'];
    print(binCardNumber);

    try{
      String url ="https://api.paystack.co/decision/bin/$binCardNumber";

      http.Response res = await http.get(Uri.parse(url),
          headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});
      print(res.body);
      if (res.statusCode == 200) {
        chargeRawCard();

      }else{
        setState(() {
          _publishModal = false;
        });
        VariablesOne.notifyErrorBot(title: kResolveCard);
        paymentSuggestion();

      }
    }catch(e){
      setState(() {
        _publishModal = false;
      });
      VariablesOne.notifyErrorBot(title: kResolveCard);
      paymentSuggestion();

    }




  }
  void enterNewCard() {

    //check if the customer have entered his card details
    if ((Variables.currentUser[0]['ccn'] == null) || (Variables.currentUser[0]['ccv'] == null) ||
        (Variables.currentUser[0]['ls'] == null) || (Variables.currentUser[0]['cyr'] == null) ||
        (Variables.currentUser[0]['cmt'] == null)){


      showModalBottomSheet(
          isDismissible: false,
          isScrollControlled: true,
          context: context,
          builder: (context) => OrderNewCardForm(takeMoney:(){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            Navigator.pop(context);
            checkValidCard();
          }

          ));
    }else{
      checkValidCard();

    }

  }






}
