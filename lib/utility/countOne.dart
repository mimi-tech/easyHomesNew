
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/cancel_booking.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/connect.dart';
import 'package:easy_homes/reg/screens/customer_upcoming_screen.dart';

import 'package:easy_homes/reg/screens/home2.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/matrix.dart';
import 'package:easy_homes/utility/paint.dart';
import 'package:easy_homes/utility/ripple_animation.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:flinq/flinq.dart';



class OneCountDownTimer extends StatefulWidget {



  @override
  _OneCountDownTimerState createState() => _OneCountDownTimerState();
}

class _OneCountDownTimerState extends State<OneCountDownTimer> with TickerProviderStateMixin {
   AnimationController? controller;
  GeoFirePoint point = geo.point(
      latitude: Variables.myPosition.latitude,
      longitude: Variables.myPosition.longitude);

  bool _publishModal = false;
  static Geoflutterfire geo = Geoflutterfire();
  final _random = new Random();
Widget space(){
  return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);
}
  double lat = Variables.myPosition.latitude;
  double log = Variables.myPosition.longitude;
  static final now = DateTime.now();
  int sumQty = 0;
  var currentDate = new DateTime.now();

  /*current date*/
  static var date = new DateTime.now().toString();
  static var dateParse = DateTime.parse(date);
  var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";

  /*check if date of delivery is now or later*/

  bool checkDate = Variables.selectedDate.isBefore(now);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var p1 = VariablesOne.deliveryFee *Variables.cloud!['df']['bky2'] / 100.round();
  var id = <dynamic>[];
  var idSecond = <dynamic>[];
   Stream<dynamic>? query;
   StreamSubscription? subscription;

  String get timerString {
    Duration duration = controller!.duration! * controller!.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60)
        .toString()
        .padLeft(1, '0')}';
  }
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    Variables.matchedVendorDoc.clear();
    getLocation();
    controller = AnimationController(
      vsync:this,
      duration: Duration(minutes: 20),
    );

    // ..addStatusListener((status) {
    //     if (controller.status == AnimationStatus.dismissed) {
    //       setState(() => isPlaying = false);
    //     }

    //     print(status);
    //   })
    //startCount();

    awaitingBooking();

    rematchCustomer();


  }

   GoogleMapController? _controller;
  List<Marker> allMarkers = [];
   CameraPosition? initialSearchLocation;

  getLocation() async {
    allMarkers.add(Marker(
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        markerId: MarkerId('myMarker'),
        draggable: false,
        position: LatLng(
            Variables.myPosition.latitude, Variables.myPosition.longitude)));

    if (_controller != null) {
      _controller!.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(Variables.myPosition.latitude,
                  Variables.myPosition.longitude),
              tilt: 0,
              zoom: 18.00)));
    }
  }

  CameraPosition initalLocation = CameraPosition(
    target:
    LatLng(Variables.myPosition.latitude, Variables.myPosition.longitude),
    zoom: 14.4746,
  );

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription!.cancel();
    awaitingBookingMatched();
    /*if (this.mounted) {
      setState(() {
        controller.dispose();
        controller.stop();
      });
    }*/

  }



  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      //backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    mapType: MapType.terrain,
                    initialCameraPosition: initalLocation,
                    markers: Set.from(allMarkers),
                    onMapCreated: mapCreated,
                    myLocationEnabled: true,
                  )),


              SingleChildScrollView(
                child: Container(

                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      space(),
                      Center(child: Container(height: 2.h,color: kHintColor,width: 50.w,)),
                      space(),
                      Center(child: SvgPicture.asset(Variables.buyingGasTypeImage.toString())),

                      space(),
                  TextWidget(
                    name: kHold,
                    textColor: kDoneColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,
                  ),
                      space(),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: AnimatedBuilder(
                                    animation: controller!,
                                    builder: (BuildContext context,
                                        Widget? child) {
                                      return CustomPaint(
                                          painter: TimerPainter(
                                            animation: controller,
                                            backgroundColor: Colors.white,
                                            color: themeData.indicatorColor,
                                          ));
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>[

                                      AnimatedBuilder(
                                          animation: controller!,
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return TextWidget(
                                              name: timerString,
                                              textColor: kTextColor,
                                              textSize: 22,
                                              textWeight: FontWeight.normal,
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            AnimatedBuilder(
                              animation: controller!,
                              builder: (BuildContext context, Widget? child) {
                                return FloatingActionButton(
                                  backgroundColor: kHintColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
                                  onPressed: () {

                                    // if (controller != null) {
                                    //   setState(() {
                                    //     controller!.dispose();
                                    //   });
                                    // }
                                    setState(() {
                                      Variables.matchedVendorDoc.clear();

                                    });

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => HomeScreenSecond(),
                                      ),
                                          (route) => false,
                                    );
                                  },
                                  child: Icon(
                                    Icons.clear, color: kWhiteColor,size: 30,),
                                );

                                // Icon(isPlaying
                                // ? Icons.pause
                                // : Icons.play_arrow);
                              },
                            ),
                          ],
                        ),
                      ),
                      space(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*void startCount() {
    controller.reverse(
        from: controller.value == 0.0
            ? 1.0
            : controller.value);
  }*/



  void rematchCustomer() {




      controller!.reverse(
          from: controller!.value == 0.0
              ? 1.0
              : controller!.value);

      getCloseVendor();

      //getMatchedVendor();

  }

  Future<void> getCloseVendor() async {
    setState(() {
      _publishModal = true;
      Variables.matchedVendorDoc.clear();
      Variables.customerData.clear();
    });
    // ignore: close_sinks
    var radius = BehaviorSubject<int>.seeded(Variables.radius!);

    /*check if kg booked is more than 12.5 or quantity of cylinder is more than 5*/
  /*  List<int> lint = Variables.usedDetailsQuantity.map(int.parse).toList();
     sumQty = lint.fold(0, (previous, current) => previous + current);

    //adding the kg
    List <double> kg = Variables.usedDetailsCylinder.map(double.parse).toList();
    double sumKg = kg.fold(0, (previous, current) => previous + current);*/
    if( VariablesOne.doubleOrder == true){
      sumQty =  Variables.cylinderCount + Variables.cylinderCountSecond;

    }else{
      sumQty =  Variables.cylinderCount;
    }
    if ((sumQty >= 15) || Variables.totalGasKG >= 15) {
/*match with vendor that has motor*/
      print('greaterthan');
      Variables.matchedVendorDoc.clear();
      //getting vendor that is close

      try{
//getting the vendor that has money in his wallet

        final QuerySnapshot result = await FirebaseFirestore.instance

            .collectionGroup("companyVendors")
            .where('wal', isGreaterThanOrEqualTo: p1.round())
            .where('ol', isEqualTo: true)
            .where('appr', isEqualTo: true)
            .where('tr', isEqualTo: false)
            .where('mt', isEqualTo: 'vehicle')
            .get();

        final List <DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          subscription!.cancel();
          controller!.reverse(
              from: controller!.value == 0.0
                  ? 1.0
                  : controller!.value);
          rematchCustomer();
        } else {

          for (DocumentSnapshot document in documents) {

            id.add(document['vId']);
          }


//get vendor that is close

          var ref = FirebaseFirestore.instance
              .collectionGroup('companyVendors')
              .where('appr', isEqualTo: true)
              .where('tr', isEqualTo: false)
              .where('ol', isEqualTo: true)
              .where('mt', isEqualTo: 'vehicle');
          GeoFirePoint center = geo.point(
              latitude: Variables.myPosition.latitude,
              longitude: Variables.myPosition.longitude);

          // subscribe to query
          subscription = radius.switchMap((rad) {
            return geo.collection(collectionRef: ref).within(
                center: center,
                radius: rad.toDouble(),
                field: 'vPos',
                strictMode: true);
          }).listen(_updateMarker);
        }

      }catch(e){
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    } else {
      print('lessthan');
      /*the booked gas is less than 12.5 and quantity is less 5*/
      try{
//getting the vendor that has money in his wallet

        final QuerySnapshot result = await FirebaseFirestore.instance

            .collectionGroup("companyVendors")
            .where('wal', isGreaterThanOrEqualTo: p1.round())
            .where('ol', isEqualTo: true)
            .where('appr', isEqualTo: true)
            .where('tr', isEqualTo: false)
            .where('mt', isEqualTo: 'vehicle')
            .get();

        final List <DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          subscription!.cancel();
          controller!.reverse(
              from: controller!.value == 0.0
                  ? 1.0
                  : controller!.value);
          rematchCustomer();
        } else {

          for (DocumentSnapshot document in documents) {

            id.add(document['vId']);
          }


//get vendor that is close

          var ref = FirebaseFirestore.instance
              .collectionGroup('companyVendors')
              .where('appr', isEqualTo: true)
              .where('tr', isEqualTo: false)
              .where('ol', isEqualTo: true)
              .where('mt', isEqualTo: 'vehicle');
               GeoFirePoint center = geo.point(
              latitude: Variables.myPosition.latitude,
              longitude: Variables.myPosition.longitude);

          // subscribe to query
          subscription = radius.switchMap((rad) {
            return geo.collection(collectionRef: ref).within(
                center: center,
                radius: rad.toDouble(),
                field: 'vPos',
                strictMode: true);
          }).listen(_updateMarker);
        }

      }catch(e){
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
  }}}

  void _updateMarker(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) async {
      idSecond.add(document['vId']);
    });
    if ((id.length == 0) || (idSecond.length == 0)) {

      ///getting the customer waiting for next vendor if there is no vendor avalible

      setState(() {
        _publishModal = false;
      });
      subscription!.cancel();
      controller!.reverse(
          from: controller!.value == 0.0
              ? 1.0
              : controller!.value);
      rematchCustomer();

    } else {

      final intersectedCollection = id.intersection(idSecond); // [5]
      Variables.matchedVendorDoc = intersectedCollection;

      getMatchedVendor();



    }

  }






  Future<void> getMatchedVendor() async {

    if (Variables.matchedVendorDoc.length == 0) {
      setState(() {
        _publishModal = false;

      });

      ///Take the customer to waiting screen

      rematchCustomer();



    } else {
      setState(() {
        _publishModal = true;
        Variables.bookingDate = DateTime.now();
      });



      FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId', isEqualTo: Variables.matchedVendorDoc[0])
          .get().then((value) {
        value.docs.forEach((result) async {
          Variables.customerData.clear();
          Variables.customerData.add(result.data());



          /*get the time and distance it will take to cover the distance*/

          String url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${Variables.customerData[0]['lat']},${Variables.customerData[0]['log']}&destinations=$lat,$log&departure_time=now&key=${Variables.myKey}";

          http.Response res = await http.get(Uri.parse(url));
          if(res.statusCode == 200){

            Map<String, dynamic> mapItems = json.decode(res.body);

            var videos = mapItems['rows']; //returns a List of Maps
            for (var item in videos) { //iterate over the list
              Map myMap = item; //store each map
              final items = (myMap['elements'] as List).map((i) =>
                  Matrix.fromJson(i));
              for (final item in items) {
                Variables.timeTaken = item.traffic['text'];
                Variables.timeTakenValues = item.traffic['value'];
                Variables.distance = item.distance['text'];

              }
            }}else{
            Variables.timeTaken = '5';
            Variables.timeTakenValues = '10';
            Variables.distance = '4.0';
          }

          if (checkDate == true) {
            //delivery of gas is now


            /*send the customer data to the vendor*/
            FirebaseFirestore.instance
                .collection('customer')
                .doc(Variables.customerData[0]['vId'])
                .set({
              'fn': Variables.userFN!,
              'ln': Variables.userLN,
              'px': Variables.userPix,
              'ph': Variables.buyerMobileNumber,
              'ad': Variables.buyerAddress,
              'cud': Variables.userUid, //customer uid
              'ud': Variables.userUid,
              'pos': point.data,
              'la': lat,
              'lg': log,
              //new cylinder number
              'vf':false,
              'gv':false,
              'cKG': Variables.kGItems,
              'cQ': Variables.headQuantityText,
              'ca':sumQty,
              'pz':Variables.checkRent?Variables.selectedAmount:'',

              'gk':Variables.totalGasKG,
              'cKG2': Variables.secondKGItems,
              'nam': Variables.selectedAmount,
              'by':Variables.buyCylinder,
              're':Variables.checkRent,
              'amt': Variables.grandTotal + VariablesOne.deliveryFee,
              'aG': Variables.gasEstimatePrice,
              'acy': Variables.sumCylinder, //amount cylinder
              'mp':Variables.currentUser[0]['mp'],
              'dd': Variables.selectedDate,
              'ts': now,
              'bgt': Variables.buyingGasType,
              'uo':false,
              'gas':Variables.matchedBusiness['gas'],

              'wd': checkDate ? 'Now' : 'Later',
              'tm': Variables.timeTaken,
              'dt': Variables.distance,
              'trw':kUnknown,
              'ew':kUnknown,
              'df': VariablesOne.deliveryFee,
              'cm':Variables.matchedBusiness['biz'],
              'ga':Variables.matchedBusiness['add'],
              'gu':Variables.matchedBusiness['ud'],
              'ci': VariablesOne.subLocality,
              'gd':Variables.matchedBusiness['id'],
              'vl':Variables.customerData[0]['lat'],
              'vlo':Variables.customerData[0]['log'],

              'wkm': Jiffy().week,
              'yr': DateTime.now().year,
              'mth': DateTime.now().month,

              'day': DateTime.now().day,
              'tms': DateFormat('h:mm a').format(currentDate),
              'td': formattedDate,
              'wk': DateTime.now().weekday,
              'date': "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",

              //'cid': customerData[0]['vId'],
              'del': false,
              'can': false, //deli
              'tc': Variables.totalCylinder,



              'vid': Variables.customerData[0]['vId'],
              'vfn': Variables.customerData[0]['fn'],
              'vln': Variables.customerData[0]['ln'],
              'vem': Variables.customerData[0]['email'],
              'vpi': Variables.customerData[0]['pix'],
              'vph': Variables.customerData[0]['ph'],
              'biz': Variables.matchedBusiness['biz'],
              'cbi': Variables.matchedBusiness['ud'],


              //new cylinder number
              'tt': Variables.timeTaken, //time taken to deliver

            });

/*update the vendor database connection to true*/


            /*update the vendor database connection to true*/

            FirebaseFirestore.instance
                .collectionGroup('companyVendors')
                .where('vId', isEqualTo: Variables.customerData[0]['vId'])
                .get().then((value) {
              value.docs.forEach((res) {
                res.reference.set({
                  'con': true,
                  'cuid': Variables.userUid //should be added by the vendor
                },SetOptions(merge: true));
              });
            });




             subscription = FirebaseFirestore.instance
                  .collectionGroup('companyVendors')
                  .where('vId', isEqualTo: Variables.customerData[0]['vId'])
                  .snapshots()
                  .listen((result) {

                if ((result.docs[0]['ac'] == Variables.vendorAccept) &&
                    (result.docs[0]['cuid'] == Variables.userUid)) {



                  /*check if vendor canceled the order*/


                  FirebaseFirestore.instance
                      .collection("customer")
                      .doc(Variables.customerData[0]['vId'])
                      .snapshots()
                      .listen((result) {
                    if (result.data()!['can'] == true) {
                      setState(() {
                        Variables.matchedVendorDoc.remove(Variables.matchedVendorDoc[0]);
                      });

                      askToContinue();

                    }
                  });

                  /*if the vendor accept the booking*/
                  setState(() {
                    _publishModal = false;
                  });
                  if(subscription != null){
                    subscription!.cancel();

                  }
                  //update the awaiting booking that customer has been matched
                  awaitingBookingMatched();
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ConnectVendor()));

                } else {

                  /*change the missed vendor con to true*/
                  Future.delayed(const Duration(seconds: kCallDuration), () {
                    if (Constant1.checkPickedCall == false) {
                      FirebaseFirestore.instance.collectionGroup(
                          'companyVendors')
                          .where(
                          'vId', isEqualTo: Variables.matchedVendorDoc[0])
                          .get()
                          .then((value) {
                        value.docs.forEach((result) {
                          result.reference.update({
                            'con': false,
                          });
                        });
                      });
                      setState(() {
                        Variables.matchedVendorDoc.remove(
                            Variables.matchedVendorDoc[0]);
                      });
                      /*removing the  vendor*/


                      getMatchedVendor();
                    }

                  });
                }
              });




          } else {
/*this is an upcoming booking*/

            getUpcomingBookings();
          }
        });
      });






}

    }




  void getUpcomingBookings() {

    /*this is an upcoming booking*/
    setState(() {
      _publishModal = true;
    });


    try {

      FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId', isEqualTo: Variables.matchedVendorDoc[0])
          .get().then((value) {
        value.docs.forEach((result) {
          result.reference.set({

            //'acu':false,//accepting upcoming
            'ue': true,
            'dv':Variables.selectedDate.toString(),
            'uuid': Variables.userUid //should be added by the vendor

          },SetOptions(merge:true));
        });
      });


      subscription =  FirebaseFirestore.instance
            .collectionGroup('companyVendors')
            .where('vId', isEqualTo: Variables.customerData[0]['vId'])
           .snapshots()
           .listen((result) {
            if ((result.docs[0]['acu'] == true) &&
                result.docs[0]['uuid'] == Variables.userUid) {

              Constant1.checkPickedCall = true;
              /*getting the upcoming booking details for vendor*/
              upcomingDetails();

              /*move the customer to see matched vendor details*/
              setState(() {
                if(subscription != null){
                  subscription!.cancel();
                }
                _publishModal = false;
              });
              //update the awaiting booking that customer has been matched
              awaitingBookingMatched();

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CustomerUpcomingScreen()));

            }else {
              //update ue to false for removed vendor

              Future.delayed(const Duration(seconds: kCallDuration), () {
                if (Constant1.checkPickedCall == false) {
                  FirebaseFirestore.instance
                      .collectionGroup('companyVendors')
                      .where('vId', isEqualTo: Variables.customerData[0]['vId'])
                      .get().then((value) {
                    value.docs.forEach((result) {
                      result.reference.update({

                        'ue': false,

                      });
                    });
                  });
                  /*rematch the customer to another customer for upcoming bookings*/
                  setState(() {
                    Variables.matchedVendorDoc.remove(
                        Variables.matchedVendorDoc[0]);
                  });
                  getMatchedVendor();
                }
              });
            }
          });


    }catch(e){

    }

  }



  void upcomingDetails() {
    var date = DateTime.now();
    try {
      /*push to the vendor database*/

      DocumentReference documentReference =
      FirebaseFirestore.instance.collection
('Upcoming').doc();
      documentReference.set({
        'doc': documentReference.id,
        'day':  DateFormat('d').format(Variables.selectedDate),
        'mth': DateFormat('MM').format(Variables.selectedDate),
        'yr': DateFormat('yyyy').format(Variables.selectedDate),
        'df': VariablesOne.deliveryFee,
        'cm':Variables.matchedBusiness['biz'],
        'ga':Variables.matchedBusiness['add'],
        'gas':Variables.matchedBusiness['gas'],

        'vl':Variables.customerData[0]['lat'],
        'vlo':Variables.customerData[0]['log'],
        'vid': Variables.customerData[0]['vId'],
        'vfn': Variables.customerData[0]['fn'],
        'vln': Variables.customerData[0]['ln'],
        'vem': Variables.customerData[0]['email'],
        'vpi': Variables.customerData[0]['pix'],
        'vph': Variables.customerData[0]['ph'],
        'biz': Variables.matchedBusiness['biz'],
        'cbi':Variables.matchedBusiness['ud'],
        'ad': Variables.buyerAddress,
        'dl': false,
        'tm': Variables.timeTaken, //time taken to deliver
        //new cylinder number
        'pz':Variables.checkRent?Variables.selectedAmount:'',
        'tc': Variables.totalCylinder,
        'trw':kUnknown,
        'ew':kUnknown,
        'vf':false,
        'uo':false,

        'gv':false,
        'cKG': Variables.kGItems,
        'cQ': Variables.headQuantityText,
        'ca':sumQty,
        'gk':Variables.totalGasKG,
        'cKG2': Variables.secondKGItems,
        'nam': Variables.selectedAmount,
        'by':Variables.buyCylinder,
        're':Variables.checkRent,
        'amt': Variables.grandTotal + VariablesOne.deliveryFee,
        'aG': Variables.gasEstimatePrice,
        'acy': Variables.sumCylinder, //amount cylinder

       'dod': Variables.selectedDate.toString(),
        'bgt': Variables.buyingGasType,
        'bg': Variables.buyingGasTypeImage,
        'fn': Variables.userFN!,
        'ln': Variables.userLN,
        'px': Variables.userPix,
        'cud': Variables.userUid,
        'ud':Variables.userUid,
        'ph': Variables.buyerMobileNumber,
        'pos': point.data,
        'la': lat,
        'lg': log,
        'bz': Variables.matchedBusiness['biz'],
        'ci': VariablesOne.subLocality,
        'st': Variables.administrative,
        'cty': Variables.country,
        'tt': Variables.timeTaken,
        'gu':Variables.matchedBusiness['ud'],
        'gd':Variables.matchedBusiness['id'],
        'mp':Variables.currentUser[0]['mp'],
        'dd': Variables.selectedDate.toString(),
        'ts': now,
        'dt': Variables.distance

      });
      VariablesOne.upcomingDocId = documentReference.id;

    } catch (e) {
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }

  void askToContinue() {
    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          CancellingBooking(no: (){
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreenSecond(),
              ),
                  (route) => false,
            );


          },

            yes: (){
              Navigator.pop(context);
              getMatchedVendor();},
          )


        ],
      );
    })

        : showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => CancellingBooking(no: (){
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreenSecond(),
            ),
                (route) => false,
          );


        },

          yes: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: RipplesAnimation()));
            getMatchedVendor();},
        )
    );

  }

  void awaitingBooking() {
try{
    FirebaseFirestore.instance.collection('awaitBooking').doc(Variables.currentUser[0]['ud']).set({
      'fn':Variables.currentUser[0]['fn'],
      'ln':Variables.currentUser[0]['ln'],
      'pix':Variables.currentUser[0]['pix'],
      'ph':Variables.currentUser[0]['ph'],
      'dt':DateFormat('EE d MMM, yyyy, h:mma').format(DateTime.now()),
      'ud':Variables.currentUser[0]['ud'],
      'add': Variables.buyerAddress,
      'mat':false,
      'ts':DateTime.now()
    },SetOptions(merge: true));
  }catch(e){

  }
  }

  void awaitingBookingMatched() {
try{
    FirebaseFirestore.instance.collection('awaitBooking').doc(Variables.currentUser[0]['ud']).set({
      'mat':true,
    },SetOptions(merge: true));
  }catch(e){

  }
  }


}







