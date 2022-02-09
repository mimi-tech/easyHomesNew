import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class VendorMap extends StatefulWidget {



  @override
  _VendorMapState createState() => _VendorMapState();
}

class _VendorMapState extends State<VendorMap> {

  /*var geoLocator = Geolocator();

  late GoogleMapController _controller;
  List<Marker> allMarkers = [];


  CameraPosition initalLocation = CameraPosition(
    target:
    LatLng( Variables.vendorLocation.latitude,  Variables.vendorLocation.longitude),
    zoom: 14.4746,
  );

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  Future<void> getCurrentLocation() async {


    allMarkers.add(Marker(
        zIndex: 2,
        flat: true,

        anchor: Offset(0.5, 0.5),
        markerId: MarkerId('myMarker'),
        draggable: false,
        position: LatLng(
            Variables.vendorLocation.latitude,  Variables.vendorLocation.longitude)));

    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng( Variables.vendorLocation.latitude,
                  Variables.vendorLocation.longitude),
              tilt: 0,
              zoom: 18.00)));
    }

  }*/

   StreamSubscription? _locationSubscription;
  Location _locationTracker = Location();
   Marker? marker;
  Circle? circle;
   GoogleMapController? _controller;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(Variables.vendorLocation == null?Constant1.venLat:Variables.vendorLocation.latitude,  Variables.vendorLocation == null?Constant1.venLog:Variables.vendorLocation.longitude),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/imagesFolder/exchange4.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!.toDouble(), newLocalData.longitude!.toDouble());
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading!.toDouble(),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy!.toDouble(),
          zIndex: 1,
          strokeColor: kLightBrown,
          center: latlng,
          fillColor: Colors.orangeAccent.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller!.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude!.toDouble(), newLocalData.longitude!.toDouble()),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentLocation();


  }

  @override
  Widget build(BuildContext context) {
    return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          // child: GoogleMap(
          //   mapType: MapType.normal,
          //   initialCameraPosition: initalLocation,
          //   markers: Set.from(allMarkers),
          //   onMapCreated: mapCreated,
          // )

     child:GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        markers: Set.of((marker != null) ? [marker!] : []),
        //circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },

      ),

    );


  }




}
