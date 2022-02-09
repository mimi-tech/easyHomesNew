import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfirmGasStation extends StatefulWidget {
  ConfirmGasStation({required this.docs});
  final DocumentSnapshot docs;

  @override
  _ConfirmGasStationState createState() => _ConfirmGasStationState();
}

class _ConfirmGasStationState extends State<ConfirmGasStation> {
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }
  var walletEarning;
  bool progress = false;
  dynamic p1c;
  dynamic p1;
  dynamic p2;
  dynamic p3;
  dynamic p4;
  dynamic pcy = 0;
  dynamic pcy1 = 0;
  dynamic pcy2 = 0;
  dynamic pcy3 = 0;
  dynamic pcy4 = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),

      child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(seconds: 1),
          curve: Curves.decelerate,
          child: SingleChildScrollView(
            child: Column(
              children: [
                spacer(),
                TextWidget(
                  name: '${widget.docs['cm']} Confirmation'.toUpperCase(),
                  textColor: kLightBrown,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                ),
                spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: TextWidgetAlign(
                    name: '${widget.docs['gk']}Tkg gas refilled?',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ),
                spacer(),

                progress?Center(child: PlatformCircularProgressIndicator()):YesNoBtnDynamic(noText:kCancel,yesText:kConfirm2,no: (){rejectGasRefill();}, yes: (){_confirmed();}),
                spacer(),
              ],
            ),
          )
      ),
    );
  }

  void _confirmed() {

setState(() {
  progress = true;
  //change this back to false so that the vendor will not see the confirm button again
  Constant1.checkGasStationConfirm = false;
});

//check if we are the one that gave the vendor our bike
    if(Variables.currentUser[0]['bky'] == true) {
      p1c = Variables.transit!['df'] *Variables.cloud!['df']['bky1'] / 100.round();
    }else{
      p1c = Variables.transit!['df'] *Variables.cloud!['df']['bky2'] / 100.round();
    }

  var customerAmount = Variables.transit!['amt'];
    //update the gas station service to true
   _updateGV();




try{
    if(widget.docs['mp'] == kCash){
      //take 20% from the vendor wallet
      FirebaseFirestore.instance.collection('userReg').doc(Variables.currentUser[0]['ud']).get()
          .then((resultEarnings) {

       // var totalEarning = resultEarnings.data()!['er'] - p1c;
        var walletEarning = resultEarnings.data()!['wal'] - p1c;

        resultEarnings.reference.set({
          //'er':totalEarning,
          'wal':walletEarning,
        },SetOptions(merge: true));
      });
      //minus the money from his vendor wallet

        FirebaseFirestore.instance.collectionGroup('companyVendors')
            .where('vId', isEqualTo:  Variables.currentUser[0]['ud'])
            .get().then((value) {

          value.docs.forEach((result) {
            var walletEarning = result.data()['wal'] - p1c;

            result.reference.set({
              'wal': walletEarning,
            },SetOptions(merge: true));
          });
        });



      getEarnings();

    }else if(widget.docs['mp'] == kWallet){
      //remove the money from the customer wallet
      FirebaseFirestore.instance
          .collection('userReg').doc(Variables.transit!['cud']).get()
          .then((resultEarnings) {
        if(resultEarnings.data()!['wal'] >= customerAmount) {
          walletEarning = resultEarnings.data()!['wal'] - customerAmount;

          resultEarnings.reference.set({
            'wal':walletEarning,
          },SetOptions(merge: true));
          ///update the customer history
          getCustomerHistory(kWalletWarning);
          getAllEarnings();
        }else{
          customerError();
        }


      });


    }else if(widget.docs['mp'] == kPromo){
//remove the money from the customer promo account
      FirebaseFirestore.instance
          .collection('userReg').doc(Variables.transit!['cud']).get()
          .then((resultEarnings) {
        if(resultEarnings.data()!['refact'] >= customerAmount) {
          walletEarning = resultEarnings.data()!['refact'] - customerAmount;

          resultEarnings.reference.set({
            'refact':walletEarning,
          },SetOptions(merge: true));

          getCustomerHistory(walletEarning);
          getAllEarnings();

        }else{
          customerError();
        }

      });


    }else if(widget.docs['mp'] == kCard){
      //remove the money from the customer wallet
      FirebaseFirestore.instance.collection('userReg').doc(Variables.transit!['cud']).get()
          .then((resultEarnings) {

            //check if money in the wallet is equal to the gas amount
        if(resultEarnings.data()!['wal'] >= customerAmount){
          walletEarning = resultEarnings.data()!['wal'] - customerAmount;

          resultEarnings.reference.set({
            'wal':walletEarning,
          },SetOptions(merge: true));

          getCustomerHistory(walletEarning);
          getAllEarnings();
        }else{
          customerError();
        }


      });

    }
  }catch(e){
  print(e.toString());
  Fluttertoast.showToast(
      msg: kError,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 5,
      backgroundColor: kBlackColor,
      textColor: kRedColor);
}
  }

  void getEarnings(){
//when payment is cash
    p1 = Variables.transit!['aG'];


    if(Variables.currentUser[0]['bky'] == true) {
      p4 = Variables.transit!['df'] *Variables.cloud!['df']['bky1'] / 100.round();
    }else{
      p4 = Variables.transit!['df'] *Variables.cloud!['df']['bky2'] / 100.round();
    }

    p2 = Variables.transit!['df'] - p4;
    p3 = Variables.transit!['df'] - p4;


    try {
      //updating vendor earnings and add the earnings in his wallet
       FirebaseFirestore.instance
          .collection('userReg').doc(Variables.userUid).get()
          .then((resultEarnings) {

        var totalEarning = resultEarnings.data()!['er'] + p4;
        var totalWallet = resultEarnings.data()!['wal'] + p4;

        resultEarnings.reference.set({
          'er':totalEarning + pcy4,
          'wal':totalWallet +pcy4,
        },SetOptions(merge: true));
      });




///updating vendor history
      try{
        DocumentReference documentReference =  FirebaseFirestore.instance.collection
('History').doc();
        documentReference.set({
          'id':documentReference.id,
          'ud':Variables.userUid,
          'amt':p4 + pcy4,
          'ts':DateTime.now().toString(),
          'dp': 'Delivery',
        });
      }catch(e){

      }

      //updating owner earnings and add to wallet
      FirebaseFirestore.instance.collection
('userReg').doc(Variables.cloud!['ud']).get().then((resultEarnings) {

        var totalEarning = resultEarnings.data()!['er'] + p3;
        var totalWallet = resultEarnings.data()!['wal'] + p3;

        resultEarnings.reference.set({
          'er':totalEarning + pcy3,
          'wal':totalWallet + pcy3,
        },SetOptions(merge: true));
      });

      ///updating owner history
      try{
        DocumentReference documentReference =  FirebaseFirestore.instance.collection
('History').doc();
        documentReference.set({
          'id':documentReference.id,
          'ud':Variables.cloud!['ud'],
          'amt':p3 + pcy3,
          'ts':DateTime.now().toString(),
          'dp': 'Gas order',
        });
      }catch(e){

      }

      //updating partner earnings and wallet
      FirebaseFirestore.instance
          .collection('userReg').doc(Variables.cloud!['pud']).get()
          .then((resultEarnings) {

        var totalEarning = resultEarnings.data()!['er'] + p2;
        var totalWallet = resultEarnings.data()!['wal'] + p2;


        resultEarnings.reference.set({
          'er':totalEarning + pcy2,
          'wal':totalWallet + pcy2,
        },SetOptions(merge: true));
      });

      ///updating partner history
      try{
        DocumentReference documentReference =  FirebaseFirestore.instance.collection('History').doc();
        documentReference.set({
          'id':documentReference.id,
          'ud':Variables.cloud!['pud'],
          'amt':p2 + pcy2,
          'ts':DateTime.now().toString(),
          'dp': 'Gas order',
        });



      }catch(e){

      }
      Navigator.pop(context);
      setState(() {
        progress = false;
        VariablesOne.gasConfirmed = true;
        Constant1.checkGasStationConfirm = true;
      });

      Fluttertoast.showToast(
          msg: 'confirmed successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

    }catch(e){
      setState(() {
        progress = false;
      });

      print('this error user earnings ${e.toString()}');
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }

 void getAllEarnings(){
    //when payment is a wallet

   if(Variables.currentUser[0]['bky'] == true) {
     p4 = Variables.transit!['df'] *Variables.cloud!['df']['bky1'] / 100.round();
   }else{
     p4 = Variables.transit!['df'] *Variables.cloud!['df']['bky2'] / 100.round();
   }

     p1 = Variables.transit!['aG'];
     p2 = Variables.transit!['aG'] - p4;
     p3 = Variables.transit!['aG'] - p4;






    try {
      //updating vendor earnings
      FirebaseFirestore.instance
          .collection('userReg').doc(Variables.userUid).get()
          .then((resultEarnings) {

        var totalEarning = resultEarnings.data()!['er'] + p4 + pcy4;
        var totalWallet = resultEarnings.data()!['er'] + p4 + pcy4;

        resultEarnings.reference.set({
          'er':totalEarning,
          'wal':totalWallet,
        },SetOptions(merge: true));
      });

      ///updating vendor history
      try{
        DocumentReference documentReference =  FirebaseFirestore.instance.collection('History').doc();
        documentReference.set({
          'id':documentReference.id,
          'ud':Variables.userUid,
          'amt':p4 + pcy4,
          'ts':DateTime.now().toString(),
          'dp': 'Delivery',
        });
      }catch(e){

      }

      //updating owner earnings and wallet
      FirebaseFirestore.instance.collection
('userReg').doc(Variables.cloud!['ud']).get().then((resultEarnings) {

        var totalEarning = resultEarnings.data()!['er'] + p3 + pcy3;
        var totalWallet = resultEarnings.data()!['er'] + p3 +pcy3;

        resultEarnings.reference.set({
          'er':totalEarning,
          'wal':totalWallet,

        },SetOptions(merge: true));
      });
      ///updating owner history
      try{
        DocumentReference documentReference =  FirebaseFirestore.instance.collection
('History').doc();
        documentReference.set({
          'id':documentReference.id,
          'ud':Variables.cloud!['ud'],
          'amt':p3 + pcy3,
          'ts':DateTime.now().toString(),
          'dp': 'Gas order',
        });
      }catch(e){

      }
      //updating partner earnings
      FirebaseFirestore.instance.collection
('userReg').doc(Variables.cloud!['pud']).get().then((resultEarnings) {

        var totalEarning = resultEarnings.data()!['er'] + p2 + pcy2;
        dynamic walletEarning = resultEarnings.data()!['wal'] + p2 + pcy2;

        resultEarnings.reference.set({
          'er':totalEarning,
          'wal':walletEarning,
        },SetOptions(merge: true));
      });

      ///updating partner history
      try{
        DocumentReference documentReference =  FirebaseFirestore.instance.collection('History').doc();
        documentReference.set({
          'id':documentReference.id,
          'ud':Variables.cloud!['pud'],
          'amt':p2 + pcy2,
          'ts':DateTime.now().toString(),
          'dp': 'Gas order',
        });
      }catch(e){

      }

      //updating gas stations earnings
      FirebaseFirestore.instance.collection('userReg').doc(Variables.transit!['cbi']).get()
          .then((resultEarnings) {
        dynamic totalEarning = resultEarnings.data()!['er'] + p1 + pcy1;
        dynamic walletEarning = resultEarnings.data()!['wal'] + p1 + pcy1;

        resultEarnings.reference.set({
          'er':totalEarning,
          'wal':walletEarning,

        },SetOptions(merge: true));
      });





      ///updating gas station history
      try{
        DocumentReference documentReference =  FirebaseFirestore.instance.collection('History').doc();
        documentReference.set({
          'id':documentReference.id,
          'ud':Variables.transit!['cbi'],
          'amt':p1 + pcy1,
          'ts':DateTime.now().toString(),
          'dp': 'Gas order',
        });
      }catch(e){

      }

      Navigator.pop(context);
      setState(() {
        progress = false;
        VariablesOne.gasConfirmed = true;
        Constant1.checkGasStationConfirm = true;

      });

      Fluttertoast.showToast(
          msg: 'Confirmed successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

    }catch(e){
      setState(() {
        progress = false;
      });

      print('this error user earnings ${e.toString()}');
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }


  void _updateGV() {
    try {
      if(VariablesOne.isUpcoming == true) {
        FirebaseFirestore.instance.collection('Upcoming')
            .doc(Variables.transit!['doc'])
            .update({
          'gv': true,
        });
        //set gv to true so that the vendor will cancel the order after buying gas

      }else{
        FirebaseFirestore.instance.collection('customer')
            .doc(Variables.userUid)
            .update({
          'gv': true,
        });


      }



    }catch (e){
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }

  void getCustomerHistory(var walletEarning) {
    try{
      DocumentReference documentReference =  FirebaseFirestore.instance.collection('History').doc();
      documentReference.set({
        'id':documentReference.id,
        'ud':Variables.transit!['cud'],
        'amt':walletEarning,
        'ts':DateTime.now().toString(),
        'dp': kPurchase,
      });
    }catch(e){

    }
  }

  void customerError() {
    Navigator.pop(context);
    setState(() {
      progress = false;
      VariablesOne.gasConfirmed = true;
    });

   VariablesOne.notifyErrorBot(title: 'Sorry customer payment incomplete. We advise the gas station to hold the cylinder until customer resolve with the vendor.Thanks');
  }

  void rejectGasRefill() {
    //show a dialog that will ask the vendor if truly the gas station did not give gas
    VariablesOne.showRejectDialog(yesClick: (){_updateBackGv();}, noClick: (){
      Navigator.pop(context);

    }, context: context);

  }

  void _updateBackGv() {
    Constant1.rejectedGasDeliveryCount++;
    try {
      if(VariablesOne.isUpcoming == true) {
        FirebaseFirestore.instance.collection('Upcoming')
            .doc(Variables.transit!['doc'])
            .update({
          'gv': false,
        });
        //set gv to true so that the vendor will cancel the order after buying gas

      }else{
        FirebaseFirestore.instance.collection('customer')
            .doc(Variables.userUid)
            .update({
          'gv': false,
        });
      }
      VariablesOne.notifyRejectedErrorBot(title: kRejectText);

      FirebaseFirestore.instance.collection('confirmRejection').add({
        'fn':Variables.currentUser[0]['fn'],
        'ln':Variables.currentUser[0]['ln'],
        'pix':Variables.currentUser[0]['pix'],
        'ph':Variables.currentUser[0]['ph'],
        'gs':Variables.transit!['cm'],
        'ga':Variables.transit!['ga'],
        'ts':DateTime.now().toString(),
      });


    }catch (e){
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }



}
