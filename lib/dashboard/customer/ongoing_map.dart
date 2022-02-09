import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/back_icon.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class OngoingMap extends StatefulWidget {
  OngoingMap({required this.doc});

  final String doc;

  @override
  _OngoingMapState createState() => _OngoingMapState();
}

class _OngoingMapState extends State<OngoingMap> {
  late CameraPosition initialSearchLocation;
  late GoogleMapController _controller;
  List<Marker> allMarkers = [];
  late StreamSubscription _locationSubscription;
  late CameraPosition initalLocation;
  var itemsData = <dynamic>[];
  String address = '';
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
bool progress = true;
  late BitmapDescriptor sourceIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    setSourceAndDestinationIcons();
  }


  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/imagesFolder/exchange4.png');}


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _locationSubscription.cancel();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: PlatformScaffold(
        body:   progress == true?Center(child: PlatformCircularProgressIndicator()):Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[

            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: initalLocation,
                  markers: Set.from(allMarkers),
                  onMapCreated: mapCreated,
                )),

            Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal) ,
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onTap: (){Navigator.pop(context);},
                    child: BackIcon())),


            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              alignment: Alignment.bottomCenter,

              child: Card(
                elevation: 20,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.h,),
                      TextWidget(
                        name: 'CURRENT LOCATION OF VENDOR'.toUpperCase(),
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                      Divider(color: kDoneColor,thickness: 1.5,),
                      space(),
                      TextWidget(
                        name: address,
                        textColor: kTextColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w500,
                      ),
                      space(),
                    ],
                  ),
                ),
              ),
            ),

          ]
      ),
      ),
    );
  }

  getLocation() async {

    /*allMarkers.add(Marker(
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        markerId: MarkerId('myMarker'),
        draggable: false,
        position: LatLng(AdminConstants.point!.latitude, AdminConstants.point!.longitude)));

    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(AdminConstants.point!.latitude, AdminConstants.point!.longitude),
              tilt: 0,
              zoom: 18.00)));
    }
*/




  }



  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  Future<void> getData() async {

    _locationSubscription = FirebaseFirestore.instance
        .collectionGroup('companyVendors')
        .where('vId', isEqualTo: widget.doc)
        .snapshots().listen((result) async {

    final List<DocumentSnapshot> vendorDoc = result.docs;

    if(vendorDoc.length == 0){
      setState(() {
        progress = true;
      });
    }else{

    for (DocumentSnapshot venList in vendorDoc) {
      Map<String, dynamic> data = venList.data() as Map<String, dynamic>;

      setState(() {
        AdminConstants.point = data['vPos']['geopoint'];

      });

      initalLocation = CameraPosition(
        target: LatLng(AdminConstants.point!.latitude, AdminConstants.point!.longitude),
        zoom: 14.4746,
      );
      List<Placemark> newPlace = await placemarkFromCoordinates(AdminConstants.point!.latitude, AdminConstants.point!.longitude);

      allMarkers.add(Marker(
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          markerId: MarkerId('myMarker'),
          draggable: false,
          icon: sourceIcon,

          position: LatLng(AdminConstants.point!.latitude, AdminConstants.point!.longitude)));



            if (_controller != null) {
        _controller.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(AdminConstants.point!.latitude, AdminConstants.point!.longitude),
                tilt: 0,
                zoom: 18.00)));


      }

      // this is all you need
      Placemark placeMark = newPlace[0];
      String? name = placeMark.name;
      String? subLocality = placeMark.subLocality;
      String? locality = placeMark.locality; //Owerri
      String? administrativeArea =
          placeMark.administrativeArea; //Imo
    String? postalCode= placeMark.postalCode;
      String? country = placeMark.country; //country
      String? ns = placeMark.thoroughfare;
      setState(() {
        address = "$name $subLocality $ns $locality $administrativeArea $postalCode state, $country";
        progress = false;

      });
    }}

  });


}
}
