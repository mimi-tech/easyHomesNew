import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GetMyCurrentLocation extends StatefulWidget {
  @override
  _GetMyCurrentLocationState createState() => _GetMyCurrentLocationState();
}

class _GetMyCurrentLocationState extends State<GetMyCurrentLocation> {
  bool progress = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: kHorizontal),
              alignment: Alignment.topCenter,
              child: LogoDesign()),

          TextWidgetAlign(name: 'Get My Location'.toUpperCase(),
            textColor: kLightBrown,
            textSize: 22,
            textWeight: FontWeight.bold,),

          Padding(
            padding: const EdgeInsets.only(left:10.0, right: 10),
            child: TextWidgetAlign(name: "We couldn't get your current location, please try again",
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.w500,),
          ),
          progress?Center(child: PlatformCircularProgressIndicator()): SizedBtn(nextFunction: (){
            setState(() {
              progress = true;
            });
            getLocation();}, bgColor: kLightBrown, title: 'Get Location'),


        ],
      ),
    ));
  }

  Future<void> getLocation() async {

    try {
      setState(() {
        progress = true;
      });


      final Geolocator _geolocator = Geolocator();

      Position position = await Geolocator.getCurrentPosition();
      Variables.myPosition = position;


      List<Placemark> newPlace = await placemarkFromCoordinates(position.latitude, position.longitude);

      // this is all you need
      Placemark placeMark = newPlace[0];
      String? name = placeMark.name;
      String ?subLocality = placeMark.subLocality;
      String? locality = placeMark.locality;//Owerri
      String? administrativeArea = placeMark.administrativeArea;//Imo
    String? postalCode= placeMark.postalCode;
      String? country = placeMark.country;//country

      String? ns = placeMark.thoroughfare;
      String address = "$name $subLocality $ns $locality $administrativeArea $postalCode state, $country";
      setState(() {
        Variables.myPosition = position;
        Variables.buyerAddress = address;
        AdminConstants.businessSubLocation = ns;
        Variables.locality = locality;
        Variables.administrative = administrativeArea;
        Variables.country = country;
        Variables.customerLat = position.latitude;
        VariablesOne.subLocality = subLocality;
        // update _address
        progress = false;
      });
      //when location has been gotten move the user back to home
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreenSecond(),
        ),
            (route) => false,
      );

    }catch(e){
      setState(() {
        progress = false;
      });
      VariablesOne.notifyErrorBot(title: 'Please check your internet and try again');

    }
  }
}
