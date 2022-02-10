
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:flinq/flinq.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:rxdart/rxdart.dart';


class ReportStation extends StatefulWidget {
  @override
  _ReportStationState createState() => _ReportStationState();
}

class _ReportStationState extends State<ReportStation> {
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }
bool progress = false;
  Color btnColor = kTextFieldBorderColor;
  TextEditingController _gasPrize = new TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  late Stream<dynamic> query;
  late StreamSubscription subscription;


  bool _publishModal = false;
  static List<dynamic> matchedBusiness = <dynamic>[];
  var id = <dynamic>[];
  var idSecond = <dynamic>[];
  bool warning = false;
  bool block = false;
  var distance = 0;
  //final Distance distanceLat = new Distance();
  // ignore: close_sinks
  var radius = BehaviorSubject<int>.seeded(Variables.radius!);
  var p1 = Variables.transit!['aG'] * 20 / 100.round();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SingleChildScrollView(
        child: Column(
            children: [
        AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Container(
         margin: EdgeInsets.symmetric(horizontal: kHorizontal),
          //height: MediaQuery.of(context).size.height * 0.4,
            child: SingleChildScrollView(

        child: Column(
        children: [

          spacer(),
          spacer(),
          TextWidgetAlign(
            name:kStationReport.toUpperCase(),
            textColor: kDoneColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          spacer(),
          spacer(),
         TextField(
            keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
            controller: _gasPrize,
            maxLines: null,
            autocorrect: true,
            autofocus: true,
            maxLength: 100,

            cursorColor: (kTextFieldBorderColor),
            style: Fonts.textSize,
            decoration: VendorConstants.stationReportInput,
            onChanged: (String value) {


              if (_gasPrize.text.length <= 0) {
                setState(() {
                  btnColor = kTextFieldBorderColor;
                });
              } else {
                setState(() {
                  btnColor = kLightBrown;
                });
              }
            },

          ),
          spacer(),


          spacer(),


        _publishModal?
            Center(child: PlatformCircularProgressIndicator())
            :YesNoBtnDynamic(no: (){Navigator.pop(context);}, yes: (){moveToNext();}, yesText: kChangeStation, noText: kCancel),


          spacer(),
        ],
      ))
        )
      )
      ])),
    );
  }

  Future<void> moveToNext() async {
    if(( _gasPrize.text == '')  || ( _gasPrize.text == null)){
      Fluttertoast.showToast(
          msg: kStationReport,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 6,
          textColor: kRedColor);
    } else{
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      //change the station
setState(() {
  _publishModal = true;
});
      final QuerySnapshot result = await FirebaseFirestore.instance

          .collection("AllBusiness")
          .where('wal', isGreaterThanOrEqualTo: p1.round())
          .where('ol', isEqualTo: true)
          .where('apr', isEqualTo: true)
          .get();

      final List <DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {

        print('this is num one empty');
        setState(() {
          progress = false;
        });
        print('uyuyu');
        notClose();

      } else {
        for (DocumentSnapshot document in documents) {

          id.add(document['id']);
        }

        try{
          //getting business that is close

          var ref = FirebaseFirestore.instance
              .collection('AllBusiness')
              .where('ol', isEqualTo: true);
          GeoFirePoint center = geo.point(latitude: Variables.myPosition.latitude, longitude: Variables.myPosition.longitude);

          // subscribe to query
          subscription = radius.switchMap((rad) {
            return geo.collection(collectionRef: ref).within(
                center: center,
                radius: rad.toDouble(),
                field: 'pos',
                strictMode: true);

          }).listen(_updateMarkerCash);
        }catch(e){
          print('ppppp${e.toString()}');
        }}
    }
  }

  Future<void> _updateMarkerCash(List<DocumentSnapshot> documentList) async {
    try{
      print('9292929');
      documentList.forEach((DocumentSnapshot document) async {
        idSecond.add(document['id']);
      });

/*check if both list is not empty*/
      if ((id.length == 0) || (idSecond.length == 0)) {
        subscription.cancel();
        setState(() {
          progress = false;
          //controller.dispose();
        });
        print('moving oooooo');

        notClose();
        //getCustomerWaitingCash();

      } else {
        subscription.cancel();
        final intersectedCollection = id.intersection(idSecond); // [5]
        matchedBusiness = intersectedCollection;




//get the business details
        final QuerySnapshot result = await  FirebaseFirestore.instance
            .collection('AllBusiness')
            .where('id', isEqualTo: matchedBusiness[0])
            .get();
        final List <DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          print('empty doc');
        } else {
          print('not empty');
          print('yyyyyy${matchedBusiness[0]}');
          for (DocumentSnapshot document in documents) {
            Variables.matchedBusiness = document;

            print('lellll${Variables.matchedBusiness}');
            updateCustomerTable();

          }

        }}

    }catch(e){
      setState(() {
        _publishModal = false;
      });
      Navigator.pop(context);
      VariablesOne.notifyFlutterToastError(title: 'sorry something went wrong');


    }

  }

  void notClose() {}

  Future<void> updateCustomerTable() async {

    //send to database the reason why change of station
    FirebaseFirestore.instance.collection('changeStation').doc().set({

      'ud':Variables.currentUser[0]['ud'],
      'fn':Variables.currentUser[0]['fn'],
      'ln':Variables.currentUser[0]['ln'],
      'ph':Variables.currentUser[0]['ph'],
      'pix':Variables.currentUser[0]['pix'],
      'cm':Variables.transit!['biz'],
      'ad':Variables.transit!['ad'],
      'gd':Variables.transit!['gd'],
      'ts':DateTime.now().toString(),
      'msg':_gasPrize.text,

    },SetOptions(merge: true));

    //update the customer collection with the new gas station
    FirebaseFirestore.instance.collection('customer').doc(Variables.currentUser[0]['ud']).set({

      'cm':Variables.matchedBusiness['biz'],
      'ga':Variables.matchedBusiness['add'],
      'gd':Variables.matchedBusiness['id'],
    },SetOptions(merge: true));

//re fetch the customers collection
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('customer')
        .where('vid', isEqualTo: Variables.currentUser[0]['ud'])
        .get();

    final List <DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {

    } else {

     for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {Variables.itemsData.clear();
          Variables.itemsData.add(document.data());

          Variables.transit = document;


        });
      }
    }
Navigator.pop(context);
    VariablesOne.notify(title: 'Station has been changed');
    setState(() {
      _publishModal = false;
    });


  }

}
