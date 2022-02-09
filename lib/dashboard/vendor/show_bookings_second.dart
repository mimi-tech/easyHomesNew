import 'dart:async';

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/work/constructors/check_cylinder.dart';
import 'package:easy_homes/work/constructors/delivered.dart';
import 'package:easy_homes/work/constructors/map_direction.dart';
import 'package:easy_homes/work/constructors/show_map.dart';
import 'package:easy_homes/work/constructors/text_construct.dart';
import 'package:easy_homes/work/stations/confirm_gas_station.dart';

import 'package:easy_homes/work/vendor_office.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ShowBookingsSecond extends StatefulWidget {
  @override
  _ShowBookingsSecondState createState() => _ShowBookingsSecondState();
}

class _ShowBookingsSecondState extends State<ShowBookingsSecond> {
  //static List <dynamic> itemsData;
  Geoflutterfire geo = Geoflutterfire();

  bool checkVerify = false;
  double cameraZoom = 13;
  double cameraTilt = 0;
  double cameraBearing = 30;
  var p2;
  var p3;
  var p1;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  bool verifyBtn = false;
  bool progress = false;
  var date = DateTime.now();
late StreamSubscription streaming;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateUserAcceptance();

    getVerifyOrder();

  }
  void getVerifyOrder(){
    //check if customer has verify the order
    FirebaseFirestore.instance
        .collection('Upcoming').doc(Variables.transit!['doc'])
        .snapshots()
        .listen((result) {
        if (result.data()!['vf'] == true) {
          setState(() {
            verifyBtn = true;
          });
        }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(streaming != null){
      streaming.cancel();
    }

  }

  bool _publishModal = false;

  @override
  Widget build(BuildContext context) {

    Widget spacer() {
      return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
    }

    return SafeArea(
      child: PlatformScaffold(
          backgroundColor: kBlackColor,
          body: progress == true
              ? Center(child: PlatformCircularProgressIndicator())
              : ModalProgressHUD(
            inAsyncCall: _publishModal,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ShowMap(),
                  Container(
                    //alignment: Alignment.bottomCenter,

                    width: MediaQuery.of(context).size.width,
                    color: kBlackColor,
                    child: Column(
                      children: <Widget>[
                        MapDirection(),


                        TextConstruct(title: 'Service',),
                        TextConstructSecond(title:Variables.transit!['bgt']),

                        TextConstruct(title: 'Gas station',),
                        TextConstructSecond(title:Variables.transit!['cm']),

                        TextConstruct(title: 'Gas station address',),
                        TextConstructSecond(title:Variables.transit!['ga']),

                        spacer(),

                        checkVerify|| Variables.transit!['gv'] == true?ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(kLightBrown)

                          ),

                          onPressed:(){confirmGaStation();},
                          child:TextWidget(
                            name: 'Verify gas station',
                            textColor: kWhiteColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,
                          ), ):Text(''),


                        CheckCylinder(),

                        spacer(),
                        verifyBtn== false?Text(''):TextWidgetAlign(
                          name: kDelivered.toUpperCase(),
                          textColor: kRadioColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w500,
                        ),
                        spacer(),
                        verifyBtn == false?Text(''): DeliverGas(),
                        spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> updateUserAcceptance() async {


//listen when gas station has delivered gas to vendor
    streaming = FirebaseFirestore.instance
        .collection('Upcoming').doc(Variables.transit!['doc'])
        .snapshots()
        .listen((result) {
        if (result.data()!['gv'] == true) {
          setState(() {
            checkVerify = true;
            streaming.cancel();
          });
          confirmGaStation();
        }else if (result.data()!['gv'] == false) {
          setState(() {
            checkVerify = false;
          });
        }

      });




  }













  void confirmGaStation() {

    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => ConfirmGasStation(docs:Variables.transit!)
    );
  }




}


