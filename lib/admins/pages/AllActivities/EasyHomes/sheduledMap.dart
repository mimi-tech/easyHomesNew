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
class ScheduleMap extends StatefulWidget {
  ScheduleMap({required this.doc});

  final DocumentSnapshot doc;

  @override
  _ScheduleMapState createState() => _ScheduleMapState();
}

class _ScheduleMapState extends State<ScheduleMap> {
  late CameraPosition initialSearchLocation;
  late GoogleMapController _controller;
  List<Marker> allMarkers = [];
  String address = '';
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PlatformScaffold(
        body: Stack(
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
                          name: kAddresss.toUpperCase(),
                          textColor: kTextColor,
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

    allMarkers.add(Marker(
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




   setState(() async {
     List<Placemark> newPlace = await placemarkFromCoordinates(AdminConstants.point!.latitude, AdminConstants.point!.longitude);

     // this is all you need
     Placemark placeMark = newPlace[0];
     String? name = placeMark.name;
     String? subLocality = placeMark.subLocality;
     String? locality = placeMark.locality; //Owerri
     String? administrativeArea = placeMark.administrativeArea; //Imo
     String? postalCode = placeMark.postalCode;
     String? country = placeMark.country; //country
     String? ns = placeMark.thoroughfare;
     address = "$name $subLocality $ns $locality $administrativeArea $postalCode state, $country";

   });


  }

  CameraPosition initalLocation = CameraPosition(
    target: LatLng(AdminConstants.point!.latitude, AdminConstants.point!.longitude),
    zoom: 14.4746,
  );

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }


}
