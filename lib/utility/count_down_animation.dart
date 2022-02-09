/*


import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_FirebaseFirestore/cloud_FirebaseFirestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/connect.dart';

import 'package:easy_homes/reg/screens/home2.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/matrix.dart';
import 'package:easy_homes/utility/paint.dart';

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

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:flinq/flinq.dart';

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


class CountDownTimer extends StatefulWidget {



  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  // bool isPlaying = false;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60)
        .toString()
        .padLeft(1, '0')}';
  }
 int sumQty;
  @override
  void initState() {
    super.initState();
    Variables.matchedVendorDoc.clear();
    getLocation();
    controller = AnimationController(
      vsync:this,
      value: 0.1,

      duration: Duration(minutes: 20),
    );


    startCount();
    rematchCustomer();
    //getMusic();
    controller.addListener(() {
      if ( controller.value == 0.0) {
        print('end point');
      }

    }) ;





    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  late GoogleMapController _controller;
  List<Marker> allMarkers = [];
  late CameraPosition initialSearchLocation;

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
      _controller.animateCamera(CameraUpdate.newCameraPosition(
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




  bool _publishModal = false;


  double lat = Variables.myPosition.latitude;
  double log = Variables.myPosition.longitude;
  static final now = DateTime.now();

  var currentDate = new DateTime.now();

  */
/*current date*//*

  static var date = new DateTime.now().toString();
  static var dateParse = DateTime.parse(date);
  var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";

  */
/*check if date of delivery is now or later*//*

  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);
  }

  bool checkDate = Variables.selectedDate.isBefore(now);

   FirebaseFirestore = FirebaseFirestore.instance;
  static Geoflutterfire geo = Geoflutterfire();
  final _random = new Random();
  Stream<dynamic> query;
  late StreamSubscription subscription;
  var itemsData = <dynamic>[];
  var id = <dynamic>[];
  var realData = <dynamic>[];
  var idSecond = <dynamic>[];
  GeoFirePoint point = geo.point(
      latitude: Variables.myPosition.latitude,
      longitude: Variables.myPosition.longitude);
  QuerySnapshot myQuery;

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();

    //controller.dispose();

    if (this.mounted) {
      setState(() {
        controller.dispose();
        controller.stop();
      });
    }

    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
  }


  GeoFirePoint center = geo.point(
      latitude: Variables.myPosition.latitude,
      longitude:
      Variables.myPosition.longitude);

//for business
  String bizField = 'pos';
  GeoFirePoint bizCenter = geo.point(
      latitude: Variables.myPosition.latitude,
      longitude:
      Variables.myPosition.longitude);



  var biz;
  var bizes;

  Stream stream;
  bool progress = false;








  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return  SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.white10,
        body: WillPopScope(
          onWillPop: () => Future.value(false),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.45,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                                        animation: controller,
                                        builder: (BuildContext context,
                                            Widget child) {
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
                                              animation: controller,
                                              builder: (BuildContext context,
                                                  Widget child) {
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
                                  animation: controller,
                                  builder: (BuildContext context, Widget child) {
                                    return  FloatingActionButton(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),

                                      onPressed: () {
                                        if (this.mounted) {
                                          setState(() {
                                            controller.dispose();
                                          });
                                        }
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
        ),
      ),
    );
  }

  void startCount() {


    controller.reverse(
        from: controller.value == 0.0
            ? 1.0
            : controller.value);





  }

  */
/*Future<void> getMusic() async {
    audioPlayer = await AudioCache().play("r4.mp3");
    //audioPlayer.setVolume(5.0);
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
     Future.delayed(const Duration(seconds: kCallDuration), () {
      setState(() {
        audioPlayer.stop();
      });
    });
  }*//*


  void rematchCustomer() {
    Future.delayed(const Duration(seconds: 20), (){
      */
/*setState(() {
        audioPlayer.stop();
      });*//*

      */
/*if (this.mounted) {
        setState(() {
          controller.dispose();
        });
      }*//*



      controller.reverse(
          from: controller.value == 0.0
              ? 1.0
              : controller.value);


      reMatchedVendor();

      //getMatchedVendor();
    } );
  }

  void reMatchedVendor() {


    setState(() {
      _publishModal = true;
      Variables.matchedVendorDoc.clear();
    });
    // ignore: close_sinks
    var radius = BehaviorSubject<int>.seeded(Variables.radius);

    */
/*check if kg booked is more than 12.5 or quantity of cylinder is more than 5*//*

    sumQty = Variables.cylinderCount + Variables.cylinderCountSecond;

    if ((sumQty >= 3) || Variables.totalGasKG >= 15) {
*/
/*match with vendor that has motor*//*

      print('greaterthan');
      Variables.matchedVendorDoc.clear();
      */
/*getting the wallet amount first*//*

      FirebaseFirestore.instance.collectionGroup("companyVendors")
          .where('wal', isGreaterThanOrEqualTo: 100)
          .where('appr', isEqualTo: true)
          .where('tr', isEqualTo: false)
          .where('ol', isEqualTo: true)
          .where('mt', isEqualTo: 'vehicle')
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print('this is num one ${querySnapshot.docs}');
          if(querySnapshot.docs.length == 0){

          }else {
            id.add(result.data()['vId']);

          }

          //getting vendor that is close
        });

        //getting vendor that is close

        var ref = FirebaseFirestore.instance
            .collectionGroup('companyVendors')
            .where('appr', isEqualTo: true)
            .where('tr', isEqualTo: false)
            .where('ol', isEqualTo: true);
        GeoFirePoint center = geo.point(latitude: Variables.myPosition.latitude,
            longitude: Variables.myPosition.longitude);

        // subscribe to query
        subscription = radius.switchMap((rad) {
          return geo.collection(collectionRef: ref).within(
              center: center,
              radius: rad.toDouble(),
              field: 'vPos',
              strictMode: true
          );
        }).listen(_updateMarker);
      });
    } else {
      print('lessthan');
      //Variables.matchedVendorDoc.clear();
      */
/*the booked gas is less than 12.5 and quantity is less 5*//*

      */
/*getting the wallet amount first*//*

      FirebaseFirestore.instance.collectionGroup("companyVendors")
          .where('wal', isGreaterThanOrEqualTo: 100)
          .where('appr', isEqualTo: true)
          .where('tr', isEqualTo: false)
          .where('ol', isEqualTo: true)
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {

          id.add(result.data()['vId']);
          print('this number one $id');

          //getting vendor that is close
        }

        );

        var ref = Firestore.instance
            .collectionGroup('companyVendors')
            .where('appr', isEqualTo: true)
            .where('tr', isEqualTo: false)
            .where('ol', isEqualTo: true);
        GeoFirePoint center = geo.point(
            latitude: Variables.myPosition.latitude,
            longitude: Variables.myPosition.longitude);

        // subscribe to query
        subscription = radius.switchMap((rad) {
          return geo.collection(collectionRef: ref)

              .within(
              center: center,
              radius: rad.toDouble(),
              field: 'vPos',
              strictMode: true
          );
        }).listen(_updateMarker);
      });
    }
  }

  void _updateMarker(List<DocumentSnapshot> documentList) {
    Variables.matchedVendorDoc.clear();
    documentList.forEach((DocumentSnapshot document) async {
      setState(() {
        //controller.dispose();
        Variables.customerData.add(document.data);
        itemsData.add(document.data);

        idSecond.add(document.data()[
'vId']);

      });
    });

*/
/*check if both list is not empty*//*

    if((id.length == 0) || (idSecond.length == 0)){
      setState(() {
        _publishModal = false;
        //controller.dispose();
      });
      ///Take the customer to waiting screen
      subscription.cancel();
      rematchCustomer();


    }else {

      final intersectedCollection = id.intersection(idSecond); // [5]
      Variables.matchedVendorDoc = intersectedCollection;

    }


    subscription.cancel();
    getMatchedVendor();
  }

  Future<void> getMatchedVendor() async {
         controller.reverse(
        from: controller.value == 0.0
            ? 1.0
            : controller.value);

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
     */
/* var element = Variables.matchedVendorDoc[_random.nextInt(
          Variables.matchedVendorDoc.length)];
*//*


           FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId', isEqualTo: Variables.matchedVendorDoc[0])
          .get().then((value) {
        value.documents.forEach((result) async {
          Variables.customerData.clear();
          Variables.customerData.add(result.data());

*/
/*get the time and distance it will take to cover the distance*//*

          String url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${Variables.customerData.first['lat']},${Variables.customerData.first['log']}&destinations=$lat,$log&departure_time=now&key=${Variables.myKey}";

          http.Response res = await http.get(url);

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
          }

          if (checkDate == true) {
            //delivery of gas is now


            */
/*send the customer data to the vendor*//*

            FirebaseFirestore.instance
                .collection('customer')
                .document(Variables.customerData.first['vId'])
                .set({
              'fn': Variables.userFN!,
              'ln': Variables.userLN,
              'px': Variables.userPix,
              'ph': Variables.buyerMobileNumber,
              'ad': Variables.buyerAddress,
              'cud': Variables.userUid, //customer uid
              'ud': result.data()['vId'],
              'pos': point.data,
              'la': lat,
              'lg': log,


              //new cylinder number
              'vf':false,
         'gv':'false',
              'cKG': Variables.kGItems,
              'cQ': Variables.headQuantityText,
              'ca':sumQty,
              'gk':Variables.totalGasKG,
              'cKG2': Variables.secondKGItems,
              'nam': Variables.selectedAmount,
              'by':Variables.buyCylinder,
              're':Variables.checkRent,
              'amt': Variables.grandTotal,
              'aG': Variables.gasEstimatePrice,
              'acy': Variables.sumCylinder, //amount cylinder

              'mp':Variables.currentUser[0]['mp'],
              'dd': Variables.selectedDate,
              'ts': now,
              'bgt': Variables.buyingGasType,

              'wd': checkDate ? 'now' : 'later',
              'tm': Variables.timeTaken,
              'dt': Variables.distance,


              'ci': VariablesOne.subLocality,

             'vl':Variables.customerData.first['lat'],
          'vlo':Variables.customerData.first['log'],

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



              'vid': Variables.customerData.first['vId'],
              'vfn': Variables.customerData.first['fn'],
              'vln': Variables.customerData.first['ln'],
              'vem': Variables.customerData.first['email'],
              'vpi': Variables.customerData.first['pix'],
              'vph': Variables.customerData.first['ph'],
              'biz': Variables.customerData.first['biz'],
              'cbi': Variables.customerData.first['cbi'],


              //new cylinder number
              'tt': Variables.timeTaken, //time taken to deliver









            });


            */
/*update the vendor database connection to true*//*



            */
/*update the vendor database connection to true*//*

            result.reference.set({
              'con': true,
              'cuid': Variables.userUid //should be added by the vendor
            }, merge: true);




            Future.delayed(const Duration(seconds: kCallDuration), () {
              FirebaseFirestore.instance
                  .collectionGroup('companyVendors')
                  .where('vId', isEqualTo: Variables.customerData.first['vId'])
                  .get().then((value) {
                value.documents.forEach((result) {
                  if ((result.data()['ac'] == Variables.vendorAccept) &&
                      (result.data()['cuid'] == Variables.userUid)) {


                    */
/*check if vendor canceled the order*//*



                    FirebaseFirestore.instance
                        .collection("customer")
                        .document(Variables.customerData.first['vId'])
                        .snapshots()
                        .listen((result) {
                      if (result.data()['can'] == true) {

                        setState(() {
                          Variables.matchedVendorDoc.remove(Variables.matchedVendorDoc[0]);
                        });


                        getMatchedVendor();
                      } else {
                        print('did not work');
                        return;
                      }
                    });

                    */
/*if the vendor accept the booking*//*

                    setState(() {

                      _publishModal = false;
                      subscription.cancel();
                    });
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ConnectVendor()));

                  } else {
                    */
/*rematch the customer to next vendor*//*


                    */
/*change the missed vendor con to true*//*


                         FirebaseFirestore.instance
                        .collectionGroup('companyVendors')
                        .where('vId', isEqualTo: Variables.customerData.first['vId'])
                        .get().then((value) {
                      value.documents.forEach((result) {
                        result.reference.updateDate({

                          'con': false,

                        });
                      });
                    });

                    setState(() {
                      Variables.matchedVendorDoc.remove(Variables.matchedVendorDoc[0]);
                    });

                    getMatchedVendor();
                  }
                });
              });
            });
          } else {
*/
/*this is an upcoming booking*//*

            getUpcomingBookings(result);
          }
        });
      });
    }
  }

  void getUpcomingBookings(DocumentSnapshot result) {

    */
/*this is an upcoming booking*//*

    setState(() {
      _publishModal = true;
    });
    */
/*getting the upcoming booking details for vendor*//*

    upcomingDetails();

    try {
      result.reference.set({
        //'acu':true,//accepting upcoming
        'ue': true,
        'uuid': Variables.userUid //should be added by the vendor
      }, SetOptions(merge: true));
       Future.delayed(const Duration(seconds: kCallDuration), () {
        FirebaseFirestore.instance
            .collectionGroup('companyVendors')
            .where('vId', isEqualTo: Variables.customerData.first['vId'])
            .get().then((value) {
          value.documents.forEach((result) {
            if ((result.data()['acu'] == true) &&
                result.data()['uuid'] == Variables.userUid) {


              */
/*store the upcoming event in flutter local notification*//*

              getCustomerNotification();


              */
/*move the customer to see matched vendor details*//*

              setState(() {
                _publishModal = false;
                subscription.cancel();
              });
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ConnectVendor()));


            }else{
              //update ue to false for removeed vendor
              FirebaseFirestore.instance
                  .collectionGroup('companyVendors')
                  .where('vId', isEqualTo: Variables.customerData.first['vId'])
                  .get().then((value) {
                value.documents.forEach((result) {
                  result.reference.update({

                    'ue': false,

                  });
                });
              });
              */
/*rematch the customer to another customer for upcoming bookings*//*

              setState(() {
                Variables.matchedVendorDoc.remove(Variables.matchedVendorDoc[0]);
              });
              getMatchedVendor();
            }
          });
        });
      });
    }catch(e){

    }

  }



  void upcomingDetails() {
    var date = DateTime.now();
    try{
      */
/*push to the vendor database*//*

      DocumentReference documentReference = FirebaseFirestore.instance.collection
('Upcoming').doc(Variables.customerData.first['vId']);
      documentReference.set({
        'doc': documentReference.id,
        'wkd': DateFormat('EEEE').format(date),
        'day': DateTime.now().day,
        'mth': DateTime.now().month,
        'yr': DateTime.now().year,

        'tm': DateFormat('EEEE, d MMM, yyyy').format(date),
        'time': DateFormat('h:mm a').format(Variables.selectedDate),
        'vid': Variables.customerData.first['vId'],
        'vfn': Variables.customerData.first['fn'],
        'vln': Variables.customerData.first['ln'],
        'vem': Variables.customerData.first['email'],
        'vpi': Variables.customerData.first['pix'],
        'vph': Variables.customerData.first['ph'],
        'biz': Variables.customerData.first['biz'],
        'cbi': Variables.customerData.first['cbi'],
        'ad': Variables.buyerAddress,
        'dl': false,
        'tt': Variables.timeTaken, //time taken to deliver

        //new cylinder number
        'vf':false,
         'gv':'false',
        'cKG': Variables.kGItems,
        'cQ': Variables.headQuantityText,
        'ca':sumQty,
        'gk':Variables.totalGasKG,
        'cKG2': Variables.secondKGItems,
        'nam': Variables.selectedAmount,
        'by':Variables.buyCylinder,
        're':Variables.checkRent,
        'amt': Variables.grandTotal,
        'aG': Variables.gasEstimatePrice,
        'acy': Variables.sumCylinder, //amount cylinder

       'dod': Variables.selectedDate.toString(),

        'bgt': Variables.buyingGasType,


        'fn': Variables.userFN!,
        'ln': Variables.userLN,

        'px': Variables.userPix,
        'ud': Variables.userUid,
        'ph': Variables.buyerMobileNumber,
        'pos': point.data,
        'la': lat,
        'lg': log,
        'bz': Variables.customerData.first['biz'],
        'ci': VariablesOne.subLocality,
        'st': Variables.administrative,
        'cty': Variables.country,


        'mp':Variables.currentUser[0]['mp'],
        'dd': Variables.selectedDate.toString(),
        'ts': now,

        'wd': checkDate ? 'now' : 'later',
        'tms': Variables.timeTaken,
        'dt': Variables.distance

      });

    }catch(e){
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }

  Future<void> getCustomerNotification() async {

    */
/*notify the vendor that order has been cancelled by the customer*//*


    var scheduledNotificationDateTime =  Variables.selectedDate;
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'secondary_icon',
        sound:
        RawResourceAndroidNotificationSound(
            'slow_spring_board'),
        largeIcon: DrawableResourceAndroidBitmap(
            'sample_large_icon'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color:
        const Color.fromARGB(255, 255, 0, 0),
        ledColor:
        const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(
        sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics =
    NotificationDetails(
        androidPlatformChannelSpecifics,
        iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Upcoming Order'.toUpperCase(),

        'Hi ${Variables.userFN!},you have a gas order now',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }



}





*/
