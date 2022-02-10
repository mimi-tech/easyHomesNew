import 'dart:io';

//import 'package:android_intent/android_intent.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class MapDirection extends StatefulWidget {
  @override
  _MapDirectionState createState() => _MapDirectionState();
}

class _MapDirectionState extends State<MapDirection> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      //margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
      child: SvgPicture.asset(
        'assets/imagesFolder/call.svg',
      ),
            onTap: () async {
              var url =
                  "tel:${Variables.transit!['ph']}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }),
          PopupMenuButton(

                child: SvgPicture.asset(
                  'assets/imagesFolder/dir2.svg',
                ),

                itemBuilder: (context) =>
                [
                  PopupMenuItem(
                    child: GestureDetector(

                      onTap: () {

                        openNavigation();
                        Navigator.pop(context);

                      },
                      child: TextWidget(
                        name: 'To customer',
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      ),

                    ),
                  ),

                  PopupMenuItem(
                    child: GestureDetector(

                      onTap: () {
                        stationDirection();
                        Navigator.pop(context);

                      },
                      child: TextWidget(
                        name: 'To gas station',
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      ),

                    ),
                  ),


                ]
            )

        ]
      ),
    );
  }

  void openNavigation() async {
    String origin =
        '${Variables.vendorLocation.latitude},${Variables.vendorLocation.longitude}'; // lat,long like 123.34,68.56
    String destination =
        "${Variables.itemsData[0]['la']},${Variables.itemsData[0]['lg']}";

    if (Platform.isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/dir/?api=1&origin=" +
                  origin +
                  "&destination=" +
                  destination +
                  "&travelmode=driving&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    } else {
      String url = "https://www.google.com/maps/dir/?api=1&origin=" +
          origin +
          "&destination=" +
          destination +
          "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Future<void> stationDirection() async {

try{
  // From a query
  final query = Variables.transit!['ga'];
  List<Location> addresses = await locationFromAddress(query);

  //var addresses = await Geocoder.local.findAddressesFromQuery(query);
  var first = addresses.first;


  String origin = '${Variables.itemsData[0]['la']},${Variables.itemsData[0]['la']}'; // lat,long like 123.34,68.56
  String destination =
      "${first.latitude},${first.longitude}";

  if (Platform.isAndroid) {
    final AndroidIntent intent = new AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull(
            "https://www.google.com/maps/dir/?api=1&origin=" +
                origin +
                "&destination=" +
                destination +
                "&travelmode=driving&dir_action=navigate"),
        package: 'com.google.android.apps.maps');
    intent.launch();
  } else {
    String url = "https://www.google.com/maps/dir/?api=1&origin=" +
        origin +
        "&destination=" +
        destination +
        "&travelmode=driving&dir_action=navigate";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}catch (e){
print(e);

  }
  }
}
