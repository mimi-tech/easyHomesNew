import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/page_drawer.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class VendorLocationOnMap extends StatefulWidget {
  @override
  _VendorLocationOnMapState createState() => _VendorLocationOnMapState();
}

class _VendorLocationOnMapState extends State<VendorLocationOnMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  var geoLocator = Geolocator();
  String address = '';
   GoogleMapController? _controller;
  List<Marker> allMarkers = [];

  List<dynamic> transitCount = <dynamic>[];

    StreamSubscription? _locationSubscription;
   BitmapDescriptor? sourceIcon;

  CameraPosition initalLocation = CameraPosition(
    target:
    LatLng(PageConstants.getVendor[0]['lat'] ,  PageConstants.getVendor[0]['log']),
    zoom: 14.4746,
  );

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/imagesFolder/exchange4.png');}

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
  bool progress = true;

  /*void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
  late BitmapDescriptor sourceIcon;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/imagesFolder/exchange4.png');}


  Future<void> getCurrentLocation() async {


    allMarkers.add(Marker(
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        markerId: MarkerId('myMarker'),
        draggable: false,
        position: LatLng(PageConstants.getVendor[0]['lat'] ,  PageConstants.getVendor[0]['log'])));

    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng( PageConstants.getVendor[0]['lat'] ,  PageConstants.getVendor[0]['log']),
              tilt: 0,
              zoom: 18.00)));
    }


    List<Placemark> newPlace = await Geolocator().placemarkFromCoordinates(PageConstants.getVendor[0]['lat'], PageConstants.getVendor[0]['log']);

    // this is all you need
    Placemark placeMark = newPlace[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;//Owerri
    String? administrativeArea = placeMark.administrativeArea;//Imo
  String? postalCode= placeMark.postalCode;
    String? country = placeMark.country;//country

    String? ns = placeMark.thoroughfare;

    setState(() {

      address = "$name $subLocality $ns $locality $administrativeArea $postalCode state, $country";

    });

  }*/
 late  bool isDrawerBeingShown;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

    setSourceAndDestinationIcons();

   // getCurrentLocation();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scaffoldKey.currentState!.openEndDrawer();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _locationSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(

        drawer: PageDrawer(),
        key: _scaffoldKey,
        body: Container(

      child: progress?Center(child:PlatformCircularProgressIndicator()):Stack(
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
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        alignment: Alignment.topLeft,
            child: GestureDetector(
                onTap: (){Navigator.pop(context);},
                child: SvgPicture.asset('assets/imagesFolder/back_circle.svg',)),
    ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 5,vertical: 100),
        alignment: Alignment.topLeft,
            child: OpeningDrawer(pix: PageConstants.getVendor[0]['pix'], pixColor: kDoneColor,),
    ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height * 0.35,
               width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 20,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kCardRadius),
                  topRight: Radius.circular(kCardRadius),
                  bottomLeft: Radius.circular(kCardRadius),
                  bottomRight: Radius.circular(kCardRadius),
                ),),
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          space(),
                          Row(
                            children: <Widget>[
                              Icon(Icons.arrow_upward,color: kDoneColor,),
                              TextWidget(
                                name: kVendorLocation.toUpperCase(),
                                textColor: kDoneColor,
                                textSize: kFontSize14,
                                textWeight: FontWeight.w500,
                              ),



                            ],
                          ),
                          TextWidget(
                            name: address,
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w500,
                          ),
                          Divider(color: kDoneColor,thickness: 1.5,),
                          space(),
                          Text("verified by".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.oxanium(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize14, ),
                              color: kDoneColor,
                            ),
                          ),
                          TextWidget(
                            name: '${PageConstants.getVendor[0]['biz']} Location'.toUpperCase(),
                            textColor: kLightBrown,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w500,
                          ),
                          space(),

                          Text("Joined on".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.oxanium(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize14, ),
                              color: kDoneColor,
                            ),
                          ),
                          TextWidget(
                            name: '${PageConstants.getVendor[0]['date']}'.toUpperCase(),
                            textColor: kDarkRedColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w500,
                          ),
                             space(),

                          Text("Home Address".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.oxanium(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize14, ),
                              color: kDoneColor,
                            ),
                          ),
                          TextWidget(
                            name: '${PageConstants.getVendor[0]['str']}'.toUpperCase(),
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w500,
                          ),

                          /* TextWidget(
                            name: '${transitCount[0]['bgt']} Location'.toUpperCase(),
                            textColor: kLightBrown,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w500,
                          ),

                          TextWidget(
                            name: '${transitCount[0]['ad']}',
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w500,
                          ),

                         space(),
                          TextWidget(
                            name: '${transitCount[0]['td']} ${transitCount[0]['tms']}',
                            textColor: kRadioColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w500,
                          ),*/
                          space(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )


        ],
      ),
    )));
  }

  Future<void> getData() async {

    _locationSubscription = FirebaseFirestore.instance
        .collectionGroup('companyVendors')
        .where('vId', isEqualTo: PageConstants.getVendor[0]['vId'])
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
              icon: sourceIcon!,

              position: LatLng(AdminConstants.point!.latitude, AdminConstants.point!.longitude)));



          if (_controller != null) {
            _controller!.animateCamera(CameraUpdate.newCameraPosition(
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
          String? postalCode = placeMark.postalCode;
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
