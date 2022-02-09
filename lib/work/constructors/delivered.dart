import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/work/vendor_office.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';

class DeliverGas extends StatefulWidget {
  @override
  _DeliverGasState createState() => _DeliverGasState();
}

class _DeliverGasState extends State<DeliverGas> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  dynamic p1 = 0;
  dynamic p2 = 0;
  dynamic p3 = 0;
  dynamic p4 = 0;
  dynamic pcy1 = 0;
  dynamic pcy2 = 0;
  dynamic pcy3 = 0;
  dynamic pcy4 = 0;
  bool _publishModal = false;
  var referral;
  var referralEarning;
  @override
  Widget build(BuildContext context) {
    return _publishModal?Center(child: PlatformCircularProgressIndicator()):SizedBtn(
      nextFunction: () {
        delivered();
      },
      bgColor: kLightBrown,
      title: kGasDeliverd.toUpperCase(),
    );
  }

  void delivered() {
    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidgetAlign(
            name: kConfirm.toUpperCase() + " " + Variables.transit!['fn'],
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content: Column(
            children: <Widget>[
              TextWidget(
                name: kYesConfirm,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,
              ),
              TextWidgetAlign(
                name: Variables.transit!['bgt'] + " " + 'order',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Confirm'),
              onPressed: () {
                deliverOrder();
              },
            ),
          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child: TextWidgetAlign(
              name:
              kConfirm.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: Column(
                children: <Widget>[
                  TextWidgetAlign(
                    name: '${Variables.transit!['gk']}Tkg gas delivered to ${Variables.transit!['fn']} ${Variables.transit!['ln']}',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
            spacer(),
            YesNoBtnDynamic(
              noText: 'Cancel',
              yesText: 'Confirm',
              no: () {
                Navigator.pop(context);
              },
              yes: () {
                deliverOrder();
              },
            ),
          ],
        ));
  }

  /*yes gas has been delivered */

  Future<void> deliverOrder() async {
    Navigator.pop(context);
    setState(() {
      VariablesOne.playState = false;
      _publishModal = true;
    });




/*update the customer user account to trap if the customer confirmed gas delivery*/
    try {


        /*FirebaseFirestore.instance
            .collection('Upcoming')
          .doc(Variables.transit!['doc'])
            .update({
          'vf': true,

        });*/

//update customer confirmation to false
        FirebaseFirestore.instance
            .collection('userReg')
            .doc(Variables.transit!['cud'])
            .get().then((resultData) {
          resultData.reference.set({
            'uc': false,

            'ord': resultData.data()!['ord'] + 1,
            'tt': Variables.transit!['tm'],
          }, SetOptions(merge: true));
        });

        //updating vendors delivery count
        FirebaseFirestore.instance
            .collection('userReg')
            .doc(Variables.currentUser[0]['ud'])
            .get().then((resultData) {
          resultData.reference.set({
            'dlc': resultData.data()!['dlc'] + 1,
          }, SetOptions(merge: true));
        });


        /*update customer delivered to true in customer collection to remove ongoing order*/

        await FirebaseFirestore.instance
            .collection('customer')
            .doc(Variables.userUid).set({
          'del': true,

        },SetOptions(merge: true));



        /*update vendor transit and accept to false*/
        FirebaseFirestore.instance
            .collectionGroup('companyVendors')
            .where('vId', isEqualTo: Variables.userUid)
            .get()
            .then((value) {
          value.docs.forEach((result) {
            result.reference.update({
              'ac': "",
              'tr': false,
              'con': false,
            });
          });
        });






      getPercentage();
      dailyAccount();
      weeklyAccount();
      monthlyAccount();
      yearlyAccount();
      dailyCount();
      vendorCount(Variables.transit!);
      ownerCount();
      partnerCount();
      businessCount();
      updateUserReg();

      setState(() {
        _publishModal = false;
        VariablesOne.decline = true;
      });


        VariablesOne.updatedOrderTrue = false;
        //set this to false so that the vendor will be able to see cancel order
        VariablesOne.gasConfirmed = false;
        Constant1.checkGasStationConfirm = false;

      VariablesOne.orderEnded = true;
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => VendorOffice(),
          ),
              (route) => false,
        );
        VariablesOne.notify(title: 'Please tell your customer to rate you');

        //updating ongoing order count
        FirebaseFirestore.instance
            .collection('sessionActivity')
            .doc()
            .get().then((resultData) {
          resultData.reference.set({
            'ong': resultData.data()!['ong'] - 1,
          }, SetOptions(merge: true));
        });




    } catch (e) {
      setState(() {
        _publishModal = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }


  void dailyCount() {

    try {
      DocumentReference documentReference = FirebaseFirestore.instance.collection('vendorDaily').doc();
      documentReference.set({
        'doc': documentReference.id,
        'id': Variables.transit!['vid'],
        'day': DateTime.now().day,//Variables.transit!['day'],
        'kg': Variables.transit!['cKG'],
        'kg2': Variables.transit!['cKG2'],
        'cQ':Variables.transit!['cQ'],
        'ca': Variables.transit!['ca'],
        'gk': Variables.transit!['gk'],
        'aG':Variables.transit!['aG'],
        'gd':Variables.transit!['gd'],
        'acy':Variables.transit!['acy'],
        'by':Variables.transit!['by'],
        're':Variables.transit!['re'],
        'cm':Variables.transit!['cm'],
        'pid':Variables.transit!['pid'],
        'p1':p1,
        'p2':p2,
        'p3':p3,
        'p4':p4,

        'py1':pcy1,
        'py2':pcy2,
        'py3':pcy3,
        'py4':pcy4,

        'amt': Variables.transit!['amt'],
        'ud':Variables.transit!['ud'],
        'cbi':Variables.transit!['cbi'],

        'od':Variables.cloud!['ud'],
        'pd':Variables.cloud!['pud'],

        'wkm': Jiffy().week,
        'Mth':DateTime.now().month,
        'dt':DateTime.now().toString(),




        'tm':Variables.transit!['tm'],
        'yr':DateTime.now().year,
        'mth':DateTime.now().month,
        'bg': Variables.transit!['bgt'],
        'mp':Variables.transit!['mp'],

        'fn':Variables.transit!['vfn'],
        'ln':Variables.transit!['vln'],
        'pi':Variables.transit!['vpi'],
        'ph':Variables.transit!['vph'],

        'cufn':Variables.transit!['fn'],
        'culn':Variables.transit!['ln'],
        'cupix':Variables.transit!['px'],
        'cuAdd':Variables.transit!['ad']

      });

      //customerOrder(result);

    } catch (e) {

      print('this error daily ${e.toString()}');
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }


  }

  Future<void> vendorCount(DocumentSnapshot<Object?> result) async {
    /*check if snapshot do exist*/

    final snapShot = await FirebaseFirestore.instance
        .collection("vendorCount")
      .doc(  Variables.transit!['vid'])
        .get();

    if (snapShot == null || !snapShot.exists) {

      //send vendor count to database;
      try {
        FirebaseFirestore.instance.collection
('vendorCount').doc(
            Variables.transit!['vid'])
            .set({
          'vid':Variables.transit!['vid'],
          'od':Variables.cloud!['ud'],

          'pd':Variables.cloud!['pud'],
          'dai':1,//daily booking count
          'wkb':1,//weekly booking count
          'mtb':1,//monthly booking count
          'yb':1,//monthly booking count
          'ab':1,//all count
          //'ue':0, //upcoming event
          'yr':DateTime.now().year,
          'mth':DateTime.now().month,
          'day':DateTime.now().day,
          'wkd':DateTime.now().weekday,
          'wky':Jiffy().week,
          'tt':Variables.transit!['tt'],
          'cbi':Variables.transit!['cbi'],
          'amt':Variables.transit!['amt'],
          'all':p4 + pcy4,
          'p4d':p4 + pcy4,
          'p4w':p4 + pcy4,
          'p4m':p4 + pcy4,
          'p4y':p4 + pcy4,





          'pi': Variables.transit!['vpi'],
          'fn':Variables.transit!['vfn'],
          'ln': Variables.transit!['vln'],
          'biz': Variables.transit!['biz'],
          'atw':Variables.transit!['amt'],
          'atm':Variables.transit!['amt'],
          'aty':Variables.transit!['amt'],
          'ph':Variables.transit!['vph'],


        },SetOptions(merge: true));


      }catch(e){
        print('this error vendor count ${e.toString()}');
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    }else {

      try{



        //get the vendor count details and update it
        FirebaseFirestore.instance.collection
("vendorCount").doc(Variables.transit!['vid']).get().then((resultData) {

          var month = resultData.data()!['mth'];
          var year = resultData.data()!['yr'];
          var currentDay =  resultData.data()!['day'];
          var currentWeek =  resultData.data()!['wky'];


          /*in case if the vendor first go to office */
          if(month == null){
            resultData.reference.set({
              'vid':Variables.transit!['vid'],
              'od':Variables.cloud!['ud'],
              'pd':Variables.cloud!['pud'],
              'dai':1,//daily booking count
              'wkb':1,//weekly booking count
              'mtb':1,//monthly booking count
              'yb':1,//yearly booking count
              'ab':1,//all count
              //'ue':0, //upcoming event
              'yr':DateTime.now().year,
              'mth':DateTime.now().month,
              'day':DateTime.now().day,
              'wkd':DateTime.now().weekday,
              'wky':Jiffy().week,
              'tt':Variables.transit!['tt'],
              'cbi':Variables.transit!['cbi'],
              'amt':Variables.transit!['amt'],

              'p4d':p4 + pcy4,
              'p4w':p4 + pcy4,
              'p4m':p4 + pcy4,
              'p4y':p4 + pcy4,
              'all':p4 + pcy4,

              'pi': Variables.transit!['vpi'],
              'fn': Variables.transit!['vfn'],
              'ln': Variables.transit!['vln'],
              'biz': Variables.transit!['biz'],
              'atw':Variables.transit!['amt'],
              'atm':Variables.transit!['amt'],
              'aty':Variables.transit!['amt'],
              'ph':Variables.transit!['vph'],


            },SetOptions(merge: true));


          }else{

            resultData.reference.set({
              'tt':currentDay == DateTime.now().day? resultData.data()!['tt']+Variables.transit!['tt']: Variables.transit!['tt'],
              'dai':currentDay == DateTime.now().day? resultData.data()!['dai']+1: 1,

              'all':resultData.data()!['all'] + Variables.transit!['df'] + pcy4,
              'p4d':currentDay == DateTime.now().day? resultData.data()!['p4d']+p4 + pcy4: p4 + pcy4,
              'p4w':currentWeek == Jiffy().week? resultData.data()!['p4w']+p4 + pcy4: p4 + pcy4,
              'p4m':month == DateTime.now().month? resultData.data()!['p4m']+p4 + pcy4: p4 + pcy4,
              'p4y':year == DateTime.now().year? resultData.data()!['p4y']+p4+ pcy4: p4 + pcy4,


              'amt':currentDay == DateTime.now().day? resultData.data()!['amt']+Variables.transit!['amt']: Variables.transit!['amt'],
              'atw':currentWeek == Jiffy().week? resultData.data()!['atw']+Variables.transit!['amt']: Variables.transit!['amt'],
              'atm':month == DateTime.now().month? resultData.data()!['atm']+Variables.transit!['amt']: Variables.transit!['amt'],
              'aty':year == DateTime.now().year? resultData.data()!['aty']+Variables.transit!['amt']: Variables.transit!['amt'],

              //'no':resultData.data['no'] + 1,
              'wkb':currentWeek == Jiffy().week? resultData.data()!['wkb']+1: 1,
              'mtb':month == DateTime.now().month? resultData.data()!['mtb']+1: 1,
              'yb':year == DateTime.now().year?resultData.data()!['yb']+1:1,
              'ab':resultData.data()!['ab']+1,//all count

              'yr':DateTime.now().year,
              'mth':DateTime.now().month,
              'day':DateTime.now().day,
              'wkd':DateTime.now().weekday,
              'wky':Jiffy().week,
              'ph':Variables.transit!['vph'],
              'od':Variables.cloud!['ud'],
              'pd':Variables.cloud!['pud'],
              'vid':Variables.transit!['vid'],

            },SetOptions(merge: true));
          }

        });
      }catch(e){
        print('this error vendor count ${e.toString()}');
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }

    }
  }


  /*void updateUserRegEarnings(DocumentSnapshot result) {

  }*/

  Future<void> updateUserReg() async {
    /*update the user reg confirm and delivered true to true*/
    try {
      FirebaseFirestore.instance.collection('userReg').doc(Variables.transit!['cud']).set
({
        'uc': true,
        'del':true,

      },SetOptions(merge: true));
      /*update vendor userReg delivery true*/
      FirebaseFirestore.instance.collection('userReg').doc(Variables.transit!['vid']).set
({

        'dl':true,

      },SetOptions(merge: true));

      /*update customer delivered to true for getting current bookings*/
      if(VariablesOne.isUpcoming == false) {
        FirebaseFirestore.instance.collection('customer')
            .doc(Variables.userUid)
            .set({
          'del': true
        }, SetOptions(merge: true));
      }

//Promo Promo Promo
      if(Variables.cloud!['pro'] == true){
      FirebaseFirestore.instance
          .collection('userReg').doc(Variables.transit!['cud']).get()
          .then((ref) {
         referral = ref.data()!['ref'];

      });
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('userReg')
          .where('ref', isEqualTo: referral)
          .get();

      final List <DocumentSnapshot> documents = result.docs;
      if (documents.length != 0) {


        for (DocumentSnapshot document in documents) {
           referralEarning = document['refact'] +  100;
      document.reference.set({

        'refact':referralEarning,
      },SetOptions(merge: true));


      }}

      DocumentReference documentReference =  FirebaseFirestore.instance.collection
        ('History').doc();
      documentReference.set({
        'id':documentReference.id,
        'ud':Variables.transit!['cud'],
        'amt':referralEarning,
        'ts':DateTime.now().toString(),
        'dp': kPromos,
      });

      }

    }catch (e){
      print(e);
      print('this error userReg ${e.toString()}');

      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }


  }

  void getPercentage() {

    //check if we are the one that gave the vendor our bike
    if(Variables.currentUser[0]['bky'] == true) {
      p4 = Variables.transit!['df'] *Variables.cloud!['df']['bky1'] / 100.round();
    }else{
      p4 = Variables.transit!['df'] *Variables.cloud!['df']['bky2'] / 100.round();
    }

    p2 = Variables.transit!['df'] - p4;
    p3 = Variables.transit!['df'] - p4;
    p1 = Variables.transit!['aG'];




  }

  Future<void> ownerCount() async {
    /*check if snapshot do exist*/
try{
    final snapShot = await FirebaseFirestore.instance
        .collection("ownerCount")
      .doc( Variables.cloud!['ud'])
        .get();

    if (snapShot == null || !snapShot.exists) {
FirebaseFirestore.instance.collection
('ownerCount').doc(Variables.cloud!['ud']).set({

  'p3d':p3 + pcy3,
  'p3w':p3 + pcy3,
  'p3m':p3 + pcy3,
  'p3y':p3 + pcy3,
  'all':p3 + pcy3,

  'od':Variables.cloud!['ud'],
  'yr':DateTime.now().year,
  'mth':DateTime.now().month,
  'day':DateTime.now().day,
  'wky':Jiffy().week,
  'dai':1,//daily booking count
  'wkb':1,//weekly booking count
  'mtb':1,//monthly booking count
  'yb':1,//yearly booking count
  'ab':1,
});

    }else{


      //get the owner count details and update it
      FirebaseFirestore.instance.collection
("ownerCount").doc(Variables.cloud!['ud']).get().then((resultData) {

        var month = resultData.data()!['mth'];
        var year = resultData.data()!['yr'];
        var currentDay =  resultData.data()!['day'];
        var currentWeek =  resultData.data()!['wky'];


        resultData.reference.set({
          'p3d':currentDay == DateTime.now().day? resultData.data()!['p3d']+p3 + pcy3: p3 + pcy3,
          'p3w':currentWeek == Jiffy().week? resultData.data()!['p3w']+p3 + pcy3: p3 + pcy3,
          'p3m':month == DateTime.now().month? resultData.data()!['p3m']+ p3 + pcy3: p3 + pcy3,
          'p3y':year == DateTime.now().year? resultData.data()!['p3y']+p3 + pcy3: p3 + pcy3,
          'all':resultData.data()!['all'] + p3 + pcy3,

          'wkb':currentWeek == Jiffy().week? resultData.data()!['wkb']+1: 1,
          'mtb':month == DateTime.now().month? resultData.data()!['mtb']+1: 1,
          'dai':currentDay == DateTime.now().day? resultData.data()!['dai']+1: 1,
          'yb':year == DateTime.now().year?resultData.data()!['yb']+1:1,
          'ab':resultData.data()!['ab']+1,//all count
          'yr':DateTime.now().year,
          'mth':DateTime.now().month,
          'day':DateTime.now().day,
          'wky':Jiffy().week,
          'od':Variables.cloud!['ud'],


        },SetOptions(merge: true));

        });

    }
}catch (e){
  print('this error owner count ${e.toString()}');

    }
}
  ///for partner count
  Future<void> partnerCount() async {
    /*check if snapshot do exist*/
    try{
      final snapShot = await FirebaseFirestore.instance
          .collection("partnerCount")
        .doc(Variables.cloud!['pud'])
          .get();

      if (snapShot == null || !snapShot.exists) {
        FirebaseFirestore.instance.collection
('partnerCount').doc(Variables.cloud!['pud']).set({

          'p2d':p2 + pcy2,
          'p2w':p2 + pcy2,
          'p2m':p2 +pcy2,
          'p2y':p2 +pcy2,
          'all':p2 + pcy2,
          'dai':1,//daily booking count
          'wkb':1,//weekly booking count
          'mtb':1,//monthly booking count
          'yb':1,//yearly booking count
          'ab':1,
          'pd':Variables.cloud!['pud'],
          'yr':DateTime.now().year,
          'mth':DateTime.now().month,
          'day':DateTime.now().day,
          'wky':Jiffy().week,
        });

      }else{
        //get the partner count details and update it
        FirebaseFirestore.instance.collection
("partnerCount").doc(Variables.cloud!['pud']).get().then((resultData) {

          var month = resultData.data()!['mth'];
          var year = resultData.data()!['yr'];
          var currentDay =  resultData.data()!['day'];
          var currentWeek =  resultData.data()!['wky'];


          resultData.reference.set({
            'p2d':currentDay == DateTime.now().day? resultData.data()!['p2d'] + p2 + pcy2: p2 + pcy2,
            'p2w':currentWeek == Jiffy().week? resultData.data()!['p2w'] + p2 + pcy2: p2 + pcy2,
            'p2m':month == DateTime.now().month? resultData.data()!['p2m'] + p2 + pcy2: p2 + pcy2,
            'p2y':year == DateTime.now().year? resultData.data()!['p2y'] + p2 + pcy2: p2 + pcy2,
            'all':resultData.data()!['all'] + p2 + pcy2,
            'wkb':currentWeek == Jiffy().week? resultData.data()!['wkb']+1: 1,
            'mtb':month == DateTime.now().month? resultData.data()!['mtb']+1: 1,
            'dai':currentDay == DateTime.now().day? resultData.data()!['dai']+1: 1,
            'yb':year == DateTime.now().year?resultData.data()!['yb']+1:1,

            'ab':resultData.data()!['ab']+1,//all count
            'yr':DateTime.now().year,
            'mth':DateTime.now().month,
            'day':DateTime.now().day,
            'wky':Jiffy().week,
            'pd':Variables.cloud!['pud'],

          },SetOptions(merge: true));

        });

      }
    }catch (e){
      print('this error partner count ${e.toString()}');

    }




  }


  ///for business count
  Future<void> businessCount() async {
    /*check if snapshot do exist*/
    try{
      final snapShot = await FirebaseFirestore.instance
          .collection("businessCount")
        .doc(Variables.transit!['cbi'])
          .get();

      if (snapShot == null || !snapShot.exists) {FirebaseFirestore.instance.collection('businessCount').doc(Variables.transit!['cbi']).set({

          'p1d':p1 + pcy1,
          'p1w':p1 + pcy1,
          'p1m':p1 + pcy1,
          'p1y':p1 + pcy1,
          'all':p1 + pcy1,
          'dai':1,//daily booking count
          'wkb':1,//weekly booking count
          'mtb':1,//monthly booking count
          'yb':1,//yearly booking count
          'ab':1,
          'yr':DateTime.now().year,
          'mth':DateTime.now().month,
          'day':DateTime.now().day,
          'wky':Jiffy().week,
          'bp':Variables.transit!['cbi'],
        });

      }else{

        //get the business count details and update it
        FirebaseFirestore.instance.collection
("businessCount").doc(Variables.transit!['cbi']).get().then((resultData) {

          var month = resultData.data()!['mth'];
          var year = resultData.data()!['yr'];
          var currentDay =  resultData.data()!['day'];
          var currentWeek =  resultData.data()!['wky'];

          resultData.reference.set({
            'p1d':currentDay == DateTime.now().day? resultData.data()!['p1d'] + p1 + pcy1: p1 + pcy1,
            'p1w':currentWeek == Jiffy().week? resultData.data()!['p1w']+ p1 + pcy1: p1 + pcy1,
            'p1m':month == DateTime.now().month? resultData.data()!['p1m']+ p1 + pcy1: p1 + pcy1,
            'p1y':year == DateTime.now().year? resultData.data()!['p1y']+ p1 + pcy1: p1 + pcy1,
            'all':resultData.data()!['all'] + p1 + pcy1,

            'wkb':currentWeek == Jiffy().week? resultData.data()!['wkb']+1: 1,
            'mtb':month == DateTime.now().month? resultData.data()!['mtb']+1: 1,
            'dai':currentDay == DateTime.now().day? resultData.data()!['dai']+1: 1,
            'yb':year == DateTime.now().year?resultData.data()!['yb']+1:1,
            'ab':resultData.data()!['ab']+1,//all count

            'yr':DateTime.now().year,
            'mth':DateTime.now().month,
            'day':DateTime.now().day,
            'wky':Jiffy().week,
            'bp':Variables.transit!['cbi'],

          },SetOptions(merge: true));

        });

      }
    }catch (e){
print('business Count$e');
    }




  }

  Future<void> dailyAccount() async {
    ///for owner , partner

    try{
      final snapShot = await FirebaseFirestore.instance.collection('ownerDaily')
        .doc('${DateTime.now().year}')
          .collection('periods').doc('${DateTime.now().month}').collection('daily').doc('${DateTime.now().day}')
          .get();

      if (snapShot == null || !snapShot.exists) {


      FirebaseFirestore.instance.collection('ownerDaily')
       .doc('${DateTime.now().year}')
          .collection('periods').doc('${DateTime.now().month}').collection('daily').doc('${DateTime.now().day}').set({

        'oc':1,
        'dt':DateTime.now().toString(),
        'amo':p3 + pcy3,
        'amp': p2 + pcy2,
        'amt':Variables.transit!['amt'],
        'bz':p1 + pcy1,
        'va':Variables.transit!['df'] + pcy4,
         'id':'${DateTime.now().day}'
      });
    }else{
        FirebaseFirestore.instance.collection('ownerDaily')
          .doc('${DateTime.now().year}')
            .collection('periods').doc('${DateTime.now().month}').collection('daily').doc('${DateTime.now().day}').get().then((resultData) {
          resultData.reference.set({
            'oc': resultData.data()!['oc'] + 1,
            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,

            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],
            'bz':resultData.data()!['bz'] + p1 + pcy1,
            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,


          },SetOptions(merge: true));
        });
      }
  }catch(e){
      print('this error owner daily ${e.toString()}');

    }



    ///for business Daily

    try{
      final snapShot = await FirebaseFirestore.instance.collection('businessDaily')
        .doc(Variables.transit!['cbi'])
          .collection('periods').doc('${DateTime.now().month}')
          .collection('daily').doc('${DateTime.now().year}')
          .collection('countBD').doc('${DateTime.now().day}')
          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection('businessDaily')
          .doc(Variables.transit!['cbi'])
            .collection('daily').doc('${DateTime.now().year}')
            .collection('periods').doc('${DateTime.now().month}')
            .collection('countBD').doc('${DateTime.now().day}').set({

          'oc':1,
          'dt':DateTime.now().toString(),
          'amc':p1 + pcy1,
          'amt':Variables.transit!['amt'],
          'amo':p3 + pcy3,
          'amp': p2 + pcy2,
          'va': Variables.transit!['df'] + pcy4,
          'id':Variables.transit!['cbi'],
          'bz':p1 + pcy1,


        });
      }else{
        FirebaseFirestore.instance.collection('businessDaily')
          .doc(Variables.transit!['gd'])
            .collection('daily').doc('${DateTime.now().year}')
            .collection('periods').doc('${DateTime.now().month}')
            .collection('countBD').doc('${DateTime.now().day}').get().then((resultData) {
          resultData.reference.set({

            'oc': resultData.data()!['oc'] + 1,
            'dt': DateTime.now().toString(),
            'amc': resultData.data()!['amc'] + p1 + pcy1,
            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,
            'bz':resultData.data()!['bz'] + p1 + pcy1,
            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,


          },SetOptions(merge: true));
        });
      }
    }catch(e){
      print('this error owner 1 ${e.toString()}');

    }



    ///for gas stations Daily

    try{
      final snapShot = await FirebaseFirestore.instance.collection('stationDaily')
        .doc(Variables.transit!['gd'])
          .collection('periods').doc('${DateTime.now().month}')
          .collection('daily').doc('${DateTime.now().year}')
          .collection('countSD').doc('${DateTime.now().day}')
          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection
('stationDaily')
          .doc(Variables.transit!['gd'])
            .collection('daily').doc('${DateTime.now().year}')
            .collection('periods').doc('${DateTime.now().month}')
            .collection('countSD').doc('${DateTime.now().day}').set({

          'oc':1,
          'dt':DateTime.now().toString(),
          'amg':p1 + pcy1,
          'amt':  Variables.transit!['amt'],
          'amo':p3 + pcy3,
          'amp': p2 + pcy2,
          'bz':p1 + pcy1,
          'va': Variables.transit!['df'] + pcy4,
          'id':Variables.transit!['gd']

        });
      }else{
        FirebaseFirestore.instance.collection('stationDaily')
          .doc(Variables.transit!['gd'])
            .collection('daily').doc('${DateTime.now().year}')
            .collection('periods').doc('${DateTime.now().month}')
            .collection('countSD').doc('${DateTime.now().day}').get().then((resultData) {
          resultData.reference.set({

            'oc': resultData.data()!['oc'] + 1,
            'dt': DateTime.now().toString(),
            'amg': resultData.data()!['amg'] + p1 + pcy1,
            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,
            'bz':resultData.data()!['bz'] + p1 + pcy1,
            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,

          });
        });

      }
    }catch(e){
      print('this error owner 2 ${e.toString()}');

    }


}



  Future<void> weeklyAccount() async {
    ///for owner , partner

    try{
      final snapShot = await FirebaseFirestore.instance.collection
('ownerWeekly')
        .doc('${DateTime.now().year}')
          .collection('periods').doc('${DateTime.now().month}').collection('oWeekly').doc('${Jiffy().week}')
          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection
('ownerWeekly')
          .doc('${DateTime.now().year}')
            .collection('periods').doc('${DateTime.now().month}').collection('oWeekly').doc('${Jiffy().week}').set({

          'oc':1,
          'dt':DateTime.now().toString(),
          'wk':Jiffy().week,
          'amo':p3 + pcy3,
          'amp': p2 + pcy2,

          'amt':  Variables.transit!['amt'],
          'bz':p1 + pcy1,

          'va': Variables.transit!['df'] + pcy4,

        });
      }else{
        FirebaseFirestore.instance.collection('ownerWeekly')
          .doc('${DateTime.now().year}')
            .collection('periods').doc('${DateTime.now().month}').collection('oWeekly').doc('${Jiffy().week}').get().then((resultData) {
          resultData.reference.set({
            'oc': resultData.data()!['oc'] + 1,
            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,

            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'bz':resultData.data()!['bz'] + p1 + pcy1,
            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,


          },SetOptions(merge: true));
        });
      }
    }catch(e){
      print('this error owner 3 ${e.toString()}');

    }



    ///for business Daily

    try{
      final snapShot = await FirebaseFirestore.instance.collection
('businessWeekly')
        .doc(Variables.transit!['cbi'])

          .collection('weekly').doc('${DateTime.now().year}')
          .collection('countBW').doc('${Jiffy().week}')
          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection
('businessWeekly')
          .doc(Variables.transit!['cbi'])

            .collection('weekly').doc('${DateTime.now().year}')
            .collection('countBW').doc('${Jiffy().week}').set({

          'oc':1,
          'dt':DateTime.now().toString(),
          'wk':Jiffy().week,
          'amc':p1 + pcy1,
          'amo':p3 + pcy3,
          'amp': p2 + pcy2,
          'amt': Variables.transit!['amt'],
          'va': Variables.transit!['df'] + pcy4,
          'id':Variables.transit!['cbi']


        });
      }else{
        FirebaseFirestore.instance.collection
('businessWeekly')
          .doc(Variables.transit!['cbi'])
            .collection('weekly').doc('${DateTime.now().year}')
            .collection('countBW').doc('${Jiffy().week}').get().then((resultData) {
          resultData.reference.set({

            'oc': resultData.data()!['oc'] + 1,
            'amc': resultData.data()!['amc'] + p1 + pcy1,
            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,

            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,

          },SetOptions(merge: true));
        });
      }
    }catch(e){
      print('this error owner 4 ${e.toString()}');

    }



    ///for gas stations Daily

    try{
      final snapShot = await FirebaseFirestore.instance.collection
('stationWeekly')
        .doc(Variables.transit!['gd'])
          .collection('weekly').doc('${DateTime.now().year}')
          .collection('CountSW').doc('${Jiffy().week}')
          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection
('stationWeekly')
          .doc(Variables.transit!['gd'])
            .collection('weekly').doc('${DateTime.now().year}')
            .collection('CountSW').doc('${Jiffy().week}').set({

          'oc':1,
          'dt':DateTime.now().toString(),
          'amg':p1 + pcy1,
          'amo':p3 + pcy3,
          'amp': p2 + pcy2,
          'va': Variables.transit!['df'] + pcy4,
          'id':Variables.transit!['gd'],
          'amt':Variables.transit!['amt']


        });
      }else{
        FirebaseFirestore.instance.collection
('stationWeekly')
          .doc(Variables.transit!['gd'])
            .collection('weekly').doc('${DateTime.now().year}')
            .collection('CountSW').doc('${Jiffy().week}').get().then((resultData) {
          resultData.reference.set({

            'oc': resultData.data()!['oc'] + 1,
            'dt': DateTime.now().toString(),
            'amg': resultData.data()!['amg'] + p1 + pcy1,
            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,

            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,


          },SetOptions(merge: true));
        });

      }
    }catch(e){
      print('this error owner 5 ${e.toString()}');

    }


  }



  Future<void> monthlyAccount() async {
    ///for owner , partner

    try{
      final snapShot = await FirebaseFirestore.instance.collection
('ownerMonthly')
        .doc('${DateTime.now().year}')
          .collection('periodsOM').doc('${DateTime.now().month}')
          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection
('ownerMonthly')
          .doc('${DateTime.now().year}')
            .collection('periodsOM').doc('${DateTime.now().month}').set({

          'oc':1,
          'dt':DateTime.now().toString(),

          'amo':p3 + pcy3,
          'amp': p2 + pcy2,

          'amt':  Variables.transit!['amt'],
          'bz':p1 + pcy1,

          'va': Variables.transit!['df'] + pcy4,


        });
      }else{
        FirebaseFirestore.instance.collection
('ownerMonthly')
          .doc('${DateTime.now().year}')
            .collection('periodsOM').doc('${DateTime.now().month}').get().then((resultData) {
          resultData.reference.set({
            'oc': resultData.data()!['oc'] + 1,
            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,
            'bz': resultData.data()!['bz'] + p1 + pcy1,


            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,


          },SetOptions(merge: true));
        });
      }
    }catch(e){
      print('this error owner 6 ${e.toString()}');

    }



    ///for business Daily

    try{
      final snapShot = await FirebaseFirestore.instance.collection
('businessMonthly')
        .doc(Variables.transit!['cbi'])

          .collection('monthly').doc('${DateTime.now().year}')
          .collection('countBM').doc('${DateTime.now().month}')
          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection
('businessMonthly')
          .doc(Variables.transit!['cbi'])

            .collection('monthly').doc('${DateTime.now().year}')
            .collection('countBM').doc('${DateTime.now().month}').set({

          'oc':1,
          'dt':DateTime.now().toString(),

          'amc':p1 + pcy1,

          'amo':p3 + pcy3,
          'amp': p2 + pcy2,
          'va': Variables.transit!['df'] + pcy4,
          'id':Variables.transit!['cbi'],
          'amt':Variables.transit!['amt']


        });
      }else{
        FirebaseFirestore.instance.collection
('businessMonthly')
          .doc(Variables.transit!['cbi'])

            .collection('monthly').doc('${DateTime.now().year}')
            .collection('countBM').doc('${DateTime.now().month}').get().then((resultData) {
          resultData.reference.set({

            'oc': resultData.data()!['oc'] + 1,
            'amc': resultData.data()!['amc'] + p1 + pcy1,

            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,

            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,


          },SetOptions(merge: true));
        });
      }
    }catch(e){
      print('this error owner 7 ${e.toString()}');

    }



    ///for gas stations Daily

    try{
      final snapShot = await FirebaseFirestore.instance.collection
('stationMonthly')
        .doc(Variables.transit!['gd'])
          .collection('monthly').doc('${DateTime.now().year}')
          .collection('CountSM').doc('${DateTime.now().month}')
          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection
('stationMonthly')
          .doc(Variables.transit!['gd'])
            .collection('monthly').doc('${DateTime.now().year}')
            .collection('CountSM').doc('${DateTime.now().month}').set({

          'oc':1,
          'dt':DateTime.now().toString(),
          'amg':p1 + pcy1,

          'amo':p3 + pcy3,
          'amp': p2 + pcy2,
          'va': Variables.transit!['df'] + pcy4,
          'id':Variables.transit!['gd'],
          'amt':Variables.transit!['amt']


        });
      }else{
        FirebaseFirestore.instance.collection('stationMonthly')
          .doc(Variables.transit!['gd'])
            .collection('monthly').doc('${DateTime.now().year}')
            .collection('CountSM').doc('${DateTime.now().month}').get().then((resultData) {
          resultData.reference.set({

            'oc': resultData.data()!['oc'] + 1,
            'amg': resultData.data()!['amg'] + p1 + pcy1,

            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,

            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,


          },SetOptions(merge: true));
        });

      }
    }catch(e){
      print('this error owner 8 ${e.toString()}');

    }


  }


  Future<void> yearlyAccount() async {
    ///for owner , partner

    try{
      final snapShot = await FirebaseFirestore.instance.collection('ownerYearly')
        .doc('${DateTime.now().year}')
          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection('ownerYearly')
          .doc('${DateTime.now().year}').set({

          'oc':1,
          'dt':DateTime.now().toString(),

          'amo':p3 + pcy3,
          'amp': p2 + pcy2,

          'bz': p1 + pcy1,

          'va': Variables.transit!['df'] + pcy4,
          'amt':Variables.transit!['amt']


        });
      }else{
        FirebaseFirestore.instance.collection('ownerYearly')
          .doc('${DateTime.now().year}').get().then((resultData) {
          resultData.reference.set({
            'oc': resultData.data()!['oc'] + 1,
            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,

            'bz': resultData.data()!['bz'] + p1 + pcy1,


            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,


          },SetOptions(merge: true));
        });
      }
    }catch(e){
      print('this error owner 10 ${e.toString()}');

    }



    ///for business Daily

    try{
      final snapShot = await FirebaseFirestore.instance.collection
('businessYearly')
        .doc(Variables.transit!['cbi'])

          .collection('yearly').doc('${DateTime.now().year}')

          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection
('businessYearly')
          .doc(Variables.transit!['cbi'])

            .collection('yearly').doc('${DateTime.now().year}').set({

          'oc':1,
          'dt':DateTime.now().toString(),

          'amc':p1 + pcy1,
          'bz': p1 + pcy1,
          'amt':Variables.transit!['amt'],
          'amo':p3 + pcy3,
          'amp': p2 + pcy2,
          'va': Variables.transit!['df'] + pcy4,
          'id':Variables.transit!['cbi']


        });
      }else{
        FirebaseFirestore.instance.collection
('businessYearly')
          .doc(Variables.transit!['cbi'])

            .collection('yearly').doc('${DateTime.now().year}').get().then((resultData) {
          resultData.reference.set({

            'oc': resultData.data()!['oc'] + 1,
            'amc': resultData.data()!['amc'] + p1 + pcy1,

            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,
            'bz':resultData.data()!['bz'] + p1 + pcy1,
            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,


          },SetOptions(merge: true));

            });
      }
    }catch(e){
      print('this error owner 11 ${e.toString()}');

    }



    ///for gas stations Daily

    try{
      final snapShot = await FirebaseFirestore.instance.collection('stationYearly')
        .doc(Variables.transit!['gd'])
          .collection('yearly').doc('${DateTime.now().year}')
          .get();

      if (snapShot == null || !snapShot.exists) {


        FirebaseFirestore.instance.collection('stationYearly')
          .doc(Variables.transit!['gd'])
            .collection('yearly').doc('${DateTime.now().year}').set({

          'oc':1,
          'dt':DateTime.now().toString(),
          'amg':p1 + pcy1,

          'amt':Variables.transit!['amt'],
          'amo':p3 + pcy3,
          'amp': p2 + pcy2,
          'va': Variables.transit!['df'] + pcy4,
          'id':Variables.transit!['gd']


        });
      }else{
        FirebaseFirestore.instance.collection
('stationYearly')
          .doc(Variables.transit!['gd'])
            .collection('yearly').doc('${DateTime.now().year}').get().then((resultData) {
          resultData.reference.set({

            'oc': resultData.data()!['oc'] + 1,
            'amg': resultData.data()!['amg'] + p1 + pcy1,

            'amt': resultData.data()!['amt'] + Variables.transit!['amt'],

            'amo': resultData.data()!['amo'] + p3 + pcy3,
            'amp': resultData.data()!['amp'] + p2 + pcy2,
            'va': resultData.data()!['va'] + Variables.transit!['df'] + pcy4,



          },SetOptions(merge: true));
        });

      }
    }catch(e){
      print('this error owner 12 ${e.toString()}');

    }


  }


 /* void updateEarnings() {
    *//*update owner userReg wallet and earnings*//*
    FirebaseFirestore.instance
        .collection('userReg').doc(Variables.cloud!['ud']).get()
        .then((resultEarnings) {

      var totalEarning = resultEarnings.data()!['er'] + p3 + pcy3;
      var walletEarning = resultEarnings.data()!['wal'] + p3 + pcy3;

      resultEarnings.reference.set({
        'er':totalEarning,
        'wal':walletEarning,
      },SetOptions(merge: true));
    });


    *//*update partner userReg wallet and earnings*//*
    FirebaseFirestore.instance
        .collection('userReg').doc(Variables.cloud!['pud']).get()
        .then((resultEarnings) {

      var totalEarning = resultEarnings.data()!['er'] + p2 + pcy2;
      var walletEarning = resultEarnings.data()!['wal'] + p2 + pcy2;

      resultEarnings.reference.set({
        'er':totalEarning,
        'wal':walletEarning,
      },SetOptions(merge: true));
    });


    *//*update vendor userReg wallet and earnings*//*
    FirebaseFirestore.instance
        .collection('userReg').doc(Variables.transit!['vid']).get()
        .then((resultEarnings) {

      var totalEarning = resultEarnings.data()!['er'] + Variables.transit!['df'] + pcy4;
      var walletEarning = resultEarnings.data()!['wal'] + Variables.transit!['df'] + pcy4;

      resultEarnings.reference.set({
        'er':totalEarning,
        'wal':walletEarning,
      },SetOptions(merge: true));
    });


    *//*update business userReg wallet and earnings*//*
    FirebaseFirestore.instance
        .collection('userReg').doc(Variables.transit!['cbi']).get()
        .then((resultEarnings) {

      var totalEarning = resultEarnings.data()!['er'] + p1 + pcy1;
      var walletEarning = resultEarnings.data()!['wal'] + p1 + pcy1;

      resultEarnings.reference.set({
        'er':totalEarning,
        'wal':walletEarning,
      },SetOptions(merge: true));
    });
  }*/

}




