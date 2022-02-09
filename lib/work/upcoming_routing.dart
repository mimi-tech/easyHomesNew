import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/extacted_classes/map_info.dart';
import 'package:easy_homes/extacted_classes/details_list.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utils/newCylinderList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:page_transition/page_transition.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/utility/text.dart';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_homes/work/vendor_office.dart';
import 'package:url_launcher/url_launcher.dart';

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
class UpcomingRoute extends StatefulWidget {

  /*UpcomingRoute({
    required this.address,
    required this.pix,
    required this.phone,
    required this.gasAmount,
    required this.cylinderAmount,
    required this.total,
    required this.order,
    required this.payment,
    required this.kg,
    required this.qty,
    required this.images,
    required this.name,
    required this.customerId,
    required this.whenToDeliver,
  });

  final String address;
  final String pix;
  final String phone;
  final int gasAmount;
  final int cylinderAmount;
  final int total;
  final String order;
  final String payment;
  final List<dynamic> kg;
  final List<dynamic> qty;
  final List<dynamic> images;
  final String name;
  final String customerId;
  final String whenToDeliver;*/


  @override
  _UpcomingRouteState createState() => _UpcomingRouteState();
}

class _UpcomingRouteState extends State<UpcomingRoute> {


  //static List <dynamic> itemsData;

  double cameraZoom = 13;
  double cameraTilt = 0;
  double cameraBearing = 30;//192.8334901395799;
  LatLng sourceLocation =
  LatLng(Variables.vendorLocation.latitude!, Variables.vendorLocation.longitude!);
  LatLng destLocation = LatLng( Variables.upcoming!['la'],  Variables.upcoming!['lg']);

  late GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

// this set will hold my markers
  Set<Marker> _markers = {};

// this will hold the generated polylines
  Set<Polyline> _polylines = {};

// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = Variables.myKey;

// for my custom icons
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/imagesFolder/exchange4.png');
    //sourceIcon = await MapHelper.getMarkerImageFromUrl(Variables.userPix,targetWidth: VariablesOne.marker);


   // destinationIcon = await MapHelper.getMarkerImageFromUrl( Variables.upcoming!['px'],targetWidth: VariablesOne.marker);

  }

  // Calculating to check that
  // southwest coordinate <= northeast coordinate

  Future<void> onMapCreated(GoogleMapController controller) async {
    //controller.setMapStyle(Utils.mapStyles);

    _controller.complete(controller);



    setMapPins();

  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(
        Marker(
          markerId: MarkerId('sourcePin'),
          position: sourceLocation,
          icon: sourceIcon,
          flat: true,
          anchor: Offset(0.5, 0.5),
          infoWindow: InfoWindow(
            title: 'Vendor',
            snippet: Variables.userFN!,
          ),
        ),
      );
      // destination pin
      _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destLocation,
        icon: destinationIcon,
        //icon: BitmapDescriptor.defaultMarker,
        flat: true,

        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
          title: Variables.upcoming!['fn'],
          snippet: 'Customer',
        ),
      ));
    });
  }





  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
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
          // ignore: unnecessary_null_comparison
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          // ignore: unnecessary_null_comparison
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
      await Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      );
    });
  }

 late  DateTime todayDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateUE();
    setSourceAndDestinationIcons();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }
  bool progress = false;
  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
      zoom: cameraZoom,
      bearing: cameraBearing,
      tilt: cameraTilt,
      target: sourceLocation,
    );

    return SafeArea(child: PlatformScaffold( body: progress == true
        ? Center(child: PlatformCircularProgressIndicator())
        : SingleChildScrollView(
          child: WillPopScope(
          onWillPop: () => Future.value(false),
    child: Column(


    children: <Widget>[

      Container(
          color: kLightBrown,
          height: Variables.upcoming!['acy'] != 0?
          MediaQuery.of(context).size.height * 0.34
              :
          MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          child:  Stack(

            children: <Widget>[


              GoogleMap(
                  myLocationEnabled: true,

                  tiltGesturesEnabled: false,
                  markers: _markers,
                  polylines: _polylines,
                  mapType: MapType.normal,
                  initialCameraPosition: initialLocation,
                  onMapCreated: onMapCreated
              ),

              Positioned(
                  top: ScreenUtil().setSp(50),
                  left: 0,
                  right: 0,
                  child: MapInfoWindow(time: Variables.upcoming!['tt'],address: Variables.upcoming!['ci'])),
            ],
          ),
      ),

    SingleChildScrollView(
      child: Container(
            height: MediaQuery.of(context).size.height ,
      width: MediaQuery.of(context).size.width,
      color: kBlackColor,
      child: Column(
      children: <Widget>[
          GestureDetector(
            onTap:() async {
              var url = "tel:${Variables.upcoming!['ph']}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: SvgPicture.asset(
              'assets/imagesFolder/calling.svg',
            ),
          ),
          spacer(),

          Variables.upcoming!['acy'] != 0
              ? Container(
            width:MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius:
                BorderRadius.circular(6.0),
                border: Border.all(
                  color: kRadioColor,
                  width: 1.0,
                )

            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: <Widget>[
                spacer(),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kOT,
                        textColor: kCartoonColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),

                      TextWidget(
                        name:  Variables.upcoming!['bgt'].toString(),
                        textColor: kLightBrown,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),

                    ],
                  ),
                ),
                spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kPT,
                        textColor: kCartoonColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),

                      TextWidget(
                        name:  Variables.upcoming!['mp'],
                        textColor: kLightBrown,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),

                    ],
                  ),
                ),

                spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kNC,
                        textColor: kCartoonColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),
                      TextWidget(
                        name: '#${Variables.upcoming!['acy'].toString()}',
                        textColor: kLightBrown,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),

                    ],
                  ),
                ),
                spacer(),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kGP,
                        textColor: kCartoonColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),
                      TextWidget(
                        name:  '#${Variables.upcoming!['aG'].toString()}',
                        textColor: kLightBrown,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),

                    ],
                  ),
                ),

                spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kDF,
                        textColor: kCartoonColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),
                      TextWidget(
                        name: '#' + Variables.upcoming!['df'].toString(),
                        textColor: kLightBrown,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),

                    ],
                  ),
                ),


                spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kTotal,
                        textColor: kCartoonColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),

                      TextWidget(
                        name:  '#${Variables.upcoming!['amt'].toString()}',
                        textColor: kSeaGreen,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),

                    ],
                  ),
                ),
                spacer(),



                Center(
                  child: GestureDetector(
                    onTap: () {
                      showDetails();
                    },
                    child: TextWidget(
                      name: kViewDetails.toUpperCase(),
                      textColor: kLightDoneColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),
                  ),
                ),
                spacer(),


              ],
            ),
          )
              : Container(
            width:MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius:
                BorderRadius.circular(6.0),
                border: Border.all(
                  color: kRadioColor,
                  width: 1.0,
                )
              /* shape:  RoundedRectangleBorder(
                                borderRadius:  BorderRadius.circular(4.0),
                                side: BorderSide(color: kWhiteColor)
                              ),*/
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: <Widget>[
                spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kTotal,
                        textColor: kCartoonColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                      TextWidget(
                        name: '#' +
                            Variables.upcoming!['amt'].toString(),
                        textColor: kSeaGreen,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),

                    ],
                  ),
                ),
                spacer(),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kPM,
                        textColor: kCartoonColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                      TextWidget(
                        name:  Variables.upcoming!['mp'],
                        textColor: kLightBrown,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),

                    ],
                  ),
                ),
                spacer(),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kOT,
                        textColor: kCartoonColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),

                      TextWidget(
                        name:  Variables.upcoming!['bgt'].toString(),
                        textColor: kLightBrown,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),

                    ],
                  ),
                ),
                spacer(),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      showDetails();
                    },
                    child: TextWidget(
                      name: kViewDetails.toUpperCase(),
                      textColor: kLightDoneColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),
                  ),
                ),
                spacer(),


              ],
            ),
          ),

          spacer(),
          GestureDetector(
            onTap: (){
              print(Variables.vendorLocation.longitude);
            },
            child: TextWidgetAlign(
              name: kDelivered.toUpperCase(),
              textColor: kRadioColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),
          ),

          spacer(),
          SizedBtn(
            nextFunction: () {
             setNotification();
            },
            bgColor: kLightBrown,
            title: 'ok'.toUpperCase(),
          ),
          spacer(),
          ]
      )

      ),
    )
      ]
    )
    ),
        )
    ));
  }

  void updateUE() {
    /*update the vendor database by setting accept to true*/
    setState(() {
      progress = true;

    });
    try {
      FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId', isEqualTo: Variables.userUid)
          .get().then((value) {
        value.docs.forEach((result) {
          result.reference.update({
            'acu':true,
            'ue': false,
            //'uuid': Variables.upcoming!['ud']
          });
          setState(() {
            todayDate  = DateTime.parse(Variables.upcoming!['dd']);


            progress = false;
          });
        });
      });
    }catch(e){
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }


  void showDetails() {
    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidgetAlign(
            name: Variables.upcoming!['fn'].toUpperCase() +
                " " +
                kBooking.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content: Column(children: <Widget>[
            HeadRow(),
            spacer(),
            Container(

              width: double.maxFinite,
              child: DetailsList(
                  length: Variables.upcoming!['cKG'],
                  kg: Variables.upcoming!['cKG'],
                  image: Variables.upcoming!['cyt'],
                  quantity: Variables.upcoming!['cQ']),
            ),
            spacer(),

            Variables.upcoming!['acy'] == 0
                ? Text('')
                : Container(

              width: double.maxFinite,
              child: DetailsListNew(
                length: Variables.upcoming!['nKG'],
                kg: Variables.upcoming!['nKG'],
                image: Variables.upcoming!['ncy'],
                quantity: Variables.upcoming!['ncQ'],
                amt: Variables.upcoming!['nam'],
              ),
            ),

          ]),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kDone),
              onPressed: () {
                Navigator.of(context).pop();
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
              name: Variables.upcoming!['fn'].toUpperCase() +
                  " " +
                  kBooking.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            HeadRow(),
            spacer(),
            Container(

              width: double.maxFinite,
              child: DetailsList(
                  length: Variables.upcoming!['cKG'],
                  kg: Variables.upcoming!['cKG'],
                  image: Variables.upcoming!['cyt'],
                  quantity: Variables.upcoming!['cQ']),
            ),


            Variables.upcoming!['acy'] == 0
                ? Text('')
                : Container(

              width: double.maxFinite,
              child: DetailsListNew(
                length: Variables.upcoming!['nKG'],
                kg: Variables.upcoming!['nKG'],
                image: Variables.upcoming!['ncy'],
                quantity: Variables.upcoming!['ncQ'],
                amt: Variables.upcoming!['nam'],
              ),
            ),
            spacer(),
            DetailsBtn()
          ],
        ));
  }

  Future<void> setNotification() async {

    /*notify the vendor that order has been cancelled by the customer*/

    var scheduledNotificationDateTime =  todayDate;
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
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(0,
        'Upcoming Order'.toUpperCase(),

        'Hi ${Variables.userFN!}, You have an upcoming booking in the next one hour.',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
setState(() {

});

    /*send the vendor bac to office*/


    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(
        builder: (BuildContext context) => VendorOffice(),
      ),
          (route) => false,
    );
  /*  Navigator.pushReplacement(context,
        PageTransition(
            type: PageTransitionType
                .scale,
            alignment: Alignment
                .bottomCenter,
            child: VendorOffice()));
*/
  }
}
