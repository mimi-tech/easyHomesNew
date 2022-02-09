import 'dart:async';
import 'dart:typed_data';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/screens/search_location.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class CheckLocation extends StatefulWidget {
  @override
  _CheckLocationState createState() => _CheckLocationState();
}

class _CheckLocationState extends State<CheckLocation> {
late StreamSubscription _locationSubscription;
Location _locationTracker = Location();
late Marker marker;
late Circle circle;
late GoogleMapController _controller;

  static final CameraPosition initalLocation = CameraPosition(
    target:LatLng(5.4642961, 7.0159843),
    zoom:14.4746,
  );

  Future<Uint8List> getMarker() async{
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/heads/exchange.png");
    return byteData.buffer.asUint8List();
  }


  void updateMarkerAndCircle(LocationData newLocalData,Uint8List imageData){
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    this.setState((){
      marker = Marker(
        markerId :MarkerId("home"),
        position: latlng,
        rotation:newLocalData.heading!,
       draggable: false,
       zIndex:2,
        flat: true,
        anchor:Offset(0.5,0.5),
        icon:BitmapDescriptor.fromBytes(imageData));
        circle = Circle(
          circleId: CircleId("car"),
      radius:newLocalData.accuracy!,
      zIndex:1,
      strokeColor:kLightBrown,
      center:latlng,
      fillColor:Colors.blue

      );
    });
  }

  void getCurrentLocation()async{
    try{
      Uint8List imageData = await getMarker();
     var location = await _locationTracker.getLocation();

     updateMarkerAndCircle(location,imageData);
     if(_locationSubscription != null){
       _locationSubscription.cancel();

       _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData){
         if(_controller != null){
           _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
         bearing:192.8334901395799,
         target:LatLng(newLocalData.latitude!,newLocalData.longitude!),
         tilt:0,
         zoom:18.00
         )));
         }
       });

     }
    } on PlatformException catch (e){
      if(e.code == 'PERMISSION_DENIED'){
        debugPrint("Permission Denied");
      }

    }
  }

@override
void dispose(){
    super.dispose();
    if(_locationSubscription != null){
      _locationSubscription.cancel();
    }
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: PlatformScaffold(body: Container(

child: SingleChildScrollView(
  child:   Column(
    //alignment: Alignment.bottomCenter,
    children: <Widget>[
  Container(
    height:MediaQuery.of(context).size.height/2,
    width:MediaQuery.of(context).size.width,

    child:   GoogleMap(

      mapType:MapType.hybrid,

      initialCameraPosition: initalLocation,

      markers:Set.of((marker != null)?[marker]:[]),

      circles:Set.of((circle != null)?[circle]:[]),



      onMapCreated: (GoogleMapController controller){

        _controller = controller;

      }

      ),
  ),
Container(
  decoration: BoxDecoration(
      color: kWhiteColor,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(kmodalborderRadius),
        topLeft: Radius.circular(kmodalborderRadius),
      )),

  child:Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Image(
              image: AssetImage('assets/heads/location.png'),
              height: 50.h,
              width: 50.w
          ),
        ),
      ),


      TextWidget(name: kEnableLocation,
        textColor: kBlackColor,
        textSize: kFontSize,
        textWeight: FontWeight.normal,),

      Text(kEnableLocationText,
        textAlign: TextAlign.center,
        style:GoogleFonts.oxanium(
          fontWeight:FontWeight.normal,
          fontSize: ScreenUtil().setSp(kFontSize, ),
          color: kBlackColor,
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: LocationBtn(bgColor: kLightBrown,title: kTurnOn, nextFunction: (){
              getCurrentLocation();
            },)),
      ),
      SizedBox(height: 20.0.h,),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: LocationBtn(bgColor: kTurnOnBtn,title: kTurnOnManually, nextFunction: (){

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchLocation()));

            },)),
      )

    ]

  )

),

    ],
  ),
)
        )));
  }
}
