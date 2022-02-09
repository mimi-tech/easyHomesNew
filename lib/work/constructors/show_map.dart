import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/vendor/today_earning.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/map_info.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/work/vendor_office.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';

class ShowMap extends StatefulWidget {

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
bool _publishModal = false;
  LatLng sourceLocation = LatLng(Variables.transit!['vl'], Variables.transit!['vlo']);
  LatLng destLocation = LatLng(Variables.transit!['la'], Variables.transit!['lg']);


  double cameraZoom = 13;
  double cameraTilt = 0;
  double cameraBearing = 30;
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
    //final BitmapDescriptor sourceIcon = await MapHelper.getMarkerImageFromUrl(Variables.userPix,targetWidth: VariablesOne.marker);
    //destinationIcon = await MapHelper.getMarkerImageFromUrl(Variables.userPix,targetWidth: VariablesOne.marker);

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/imagesFolder/dest.png');
  }

  // Calculating to check that
  // southwest coordinate <= northeast coordinate

  Future<void> onMapCreated(GoogleMapController controller) async {
    //controller.setMapStyle(Utils.mapStyles);

    _controller.complete(controller);

    setMapPins();
    //setPolyLines();
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
          title: Variables.transit!['fn'],
          snippet: 'Customer',
        ),
      ));
    });
  }
  bool progress = false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSourceAndDestinationIcons();

}
  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
      zoom: cameraZoom,
      bearing: cameraBearing,
      tilt: cameraTilt,
      target: sourceLocation,
    );

    return   Container(
      color: kLightBrown,
      height: Variables.transit!['acy'] != 0
          ? MediaQuery.of(context).size.height * 0.34
          : MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialLocation,
              onMapCreated: onMapCreated),

          Positioned(
              top: ScreenUtil().setSp(50),
              left: 0,
              right: 0,
              child: MapInfoWindow(time: Variables.transit!['tm'], address: Variables.transit!['ci'])),
        ],
      ),
    );
  }


  Future<void> notifyCustomer() async {
    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidget(
            name: kCancelOrder2,
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: TextWidgetAlign(
              name: kCancelOrder3,
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kNo),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kYes),
              onPressed: () {
                removeOrder();
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
            child: TextWidget(
              name: kCancelOrder2,
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: TextWidgetAlign(
                name: kCancelOrder3,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,
              ),
            ),
            spacer(),
            YesNoBtn(
              no: () {
                Navigator.pop(context);
              },
              yes: () {
                removeOrder();
              },
            ),
          ],
        ));
  }



  Future<void> removeOrder() async {
    Navigator.pop(context);

/*update customer details to cancel true*/

    setState(() {
      progress = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('customer')
          .doc(Variables.userUid)
          .set({
        'can': true,
        //'gv':true,
      },SetOptions(merge: true));

      /*update vendor connection false*/
      await FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId', isEqualTo: Variables.userUid)
          .get()
          .then((value) {
        value.docs.forEach((result) async {
          result.reference.update({
            'con': false,
            'tr': false,
            'ac': "",
          });

          /*notify the company that there vendor canceled an order*/
          await FirebaseFirestore.instance.collection
                 ('cancelOrder').add({
            'fn': Variables.userFN!,
            'ln': Variables.userLN,
            'px': Variables.userPix,
            'ph': Variables.userPH,
            'dt': DateFormat('EEEE, d MMM, yyyy').format(DateTime.now()),
            'vid': Variables.userUid,
            'cbi': result.data()['cuid'],
            'cn': result.data()['cn'],
            'tm': DateFormat('h:mm:a').format(DateTime.now()),
            'ts': DateTime.now(),
            'yr': DateTime.now().year,
            'wk': Jiffy().week,
            'ad': Variables.transit!['ad'],
            'bz': Variables.transit!['ph']['bz'],
          });
        });
      });

      /*update user delivery to true*/
      await FirebaseFirestore.instance
          .collection('userReg')
          .doc(Variables.userUid)
          .update({
        'dl': true,
      });

      /*update customer del  delivery to true*/
      await FirebaseFirestore.instance
          .collection('userReg')
          .doc(Variables.transit!['cud'])
          .update({
        'del': true,
      });

      setState(() {
        progress = false;
      });
      /*move the vendor back to his office*/
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => VendorOffice(),
        ),
            (route) => false,
      );

    } catch (e) {
      setState(() {
        progress = false;
      });
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }

  void removeUpcoming() {
    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidget(
            name: kCancelOrder2,
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: TextWidgetAlign(
              name: kCancelOrder3,
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kNo),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kYes),
              onPressed: () {
                removeOrder();
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
            child: TextWidget(
              name: kCancelOrder2,
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: TextWidgetAlign(
                name: kCancelOrder3,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,
              ),
            ),
            spacer(),
            YesNoBtn(
              no: () {
                Navigator.pop(context);
              },
              yes: () {
                removeScheduled();
              },
            ),
          ],
        ));
  }

  void removeScheduled() {
    try {
      /* FirebaseFirestore.instance.collection
('customer').doc(Variables.userUid)

       .delete();*/

      /*update vendor that order has been canceled*/

      FirebaseFirestore.instance
          .collection('Upcoming')
          .doc(VariablesOne.documentData['doc']).update({
        'vf':true,
      });





      setState(() {
        _publishModal = false;
      });
      Navigator.pop(context, 'Done');



      setState(() {
        _publishModal = false;
      });



    }catch (e){
      setState(() {
        _publishModal = false;

      });

      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);




    }
  }

}
