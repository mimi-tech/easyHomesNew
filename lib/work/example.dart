import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:angles/angles.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/count_down_animation.dart';
import 'package:easy_homes/utility/matrix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'dart:core';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';



class ExampleWork extends StatefulWidget {
  @override
  _ExampleWorkState createState() => _ExampleWorkState();
}


class _ExampleWorkState extends State<ExampleWork> {
  AudioPlayer audioPlayer = AudioPlayer();
var publicKey = 'pk_test_09b0ecaa48e18ae95f9ee55ffbb1da53c7a053a8';
var secretKey = 'sk_test_bd1c24037e0463d39f12133d3b8d096280f5d5a1';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //getMusic();
  }
 /* double lat = 5.4640508;
  double log = 7.0161656;
  void getMusic() async {
    String origin= '5.4640508,7.0161656';  // lat,long like 123.34,68.56
    String destination="5.780685999999999,7.0432764";
    Dio dio = new Dio();
    Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=5.4640508,7.0161656&destinations=5.780685999999999,7.0432764&key=${Variables.myKey}");
    print('this is matrix distance ${response.data.toString()}');*/

   /* if (Platform.isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/dir/?api=1&origin=" +
                  origin + "&destination=" + destination + "&travelmode=driving&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    }
    else {
      String url = "https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + destination + "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }*/




      @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Column(
        children: [
          Container(
            child: GestureDetector(
                onTap: () async {

                  String url = "https://api.paystack.co/bank/resolve?account_number=6019474019&bank_code=070";

                  http.Response res = await http.get(Uri.parse(url),
                      headers: {VariablesOne.authorizationBearer: 'Bearer $secretKey'});
                     //headers:{"Authorization: Bearer"});
                  print(res.body);

                  if (res.statusCode == 200) {
                    final Map<String,dynamic> jsonDecoded = jsonDecode(res.body);

                    print(jsonDecoded);

                  }else{
                    print(res.statusCode);
                    print(res);
                    print('failed request');
                  }

                  Map<String, dynamic> mapItems = json.decode(res.body);

                  //var videos = mapItems['rows'];

                  //print(mapItems);
                 /* for (var item in videos){ //iterate over the list
                    Map myMap = item; //store each map
                      final items = (myMap['elements'] as List).map((i) =>  Matrix.fromJson(i));
                      for (final item in items) {

                        print(item.distance['text']);
                        print(item.distance['value']);

                      }

                    }*/


                 /* var e = myMap['elements'];
                  for (var elements in e){ //iterate over the list
                    Map <String, dynamic> es = elements; //store each map
                    print(es);

                    var d = es['distance'];
                    var duration = es['duration'];
                    print(d['text']);
                    print(duration['text']);*/


                  //print('this is matrix distance ${response.data.toString()}');
                },
                child: Center(child: Text('djwkhjbd'))),
          ),


          Center(
            child: RaisedButton(
              onPressed: () async {
                final double distance = await Geolocator.distanceBetween(Variables.myPosition.latitude, Variables.myPosition.latitude,
                    Variables.matchedBusiness['lat'], Variables.matchedBusiness['log']);
                  print(distance);
                dynamic d = distance /1000;

                print('cccccc $d');

                //final Distance distancef = new Distance();


                final dynamic meter = Geolocator.distanceBetween(Variables.myPosition.latitude, Variables.myPosition.longitude,
                    Variables.matchedBusiness['lat'], Variables.matchedBusiness['log']);


               /* final dynamic km = distancef.as(LengthUnit.Kilometer,
                    new LatLng(Variables.myPosition.latitude, Variables.myPosition.latitude),new LatLng( Variables.matchedBusiness['lat'], Variables.matchedBusiness['log']));
                      print('hhhhhhhh$km');
               */
                print('lllll $meter');



                String url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${Variables.myPosition.latitude},${Variables.myPosition.longitude}&destinations=${Variables.matchedBusiness['lat']},${Variables.matchedBusiness['log']}&departure_time=now&key=${Variables.myKey}";

                http.Response res = await http.get(Uri.parse(url));
print(res.body);
              },
              child: Text('try'),
            ),
          )
        ],
      )),
    );
  }
}


class DrawGood extends StatefulWidget {
  final double? size;
  final VoidCallback? onComplete;

  DrawGood({this.size, this.onComplete});

  @override
  _DrawGoodState createState() => _DrawGoodState();
}

class _DrawGoodState extends State<DrawGood> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> curve;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    curve = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.addListener(() {
      setState(() {});
      if(_controller.status == AnimationStatus.completed && widget.onComplete != null){
        widget.onComplete!();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          height: widget.size ?? 100,
          width: widget.size ?? 100,
          color: Colors.transparent,
          child: CustomPaint(
            painter: CheckPainter(value: curve.value),
          ),
        ),
      );

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}

class CheckPainter extends CustomPainter {
  Paint? _paint;
  double value;

  double? _length;
  double? _offset;
  double ?_secondOffset;
  double? _startingAngle;

  CheckPainter({required this.value}) {
    _paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    assert(value != null);

    _length = 60;
    _offset = 0;
    _startingAngle = 205;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Background canvas
    var rect = Offset(0, 0) & size;
    _paint!.color = Colors.green.withOpacity(.05);

    double line1x1 = size.width / 2 +
        size.width * cos(Angle.fromDegrees(_startingAngle!).radians) * .5;
    double line1y1 = size.height / 2 +
        size.height * sin(Angle.fromDegrees(_startingAngle!).radians) * .5;
    double line1x2 = size.width * .45;
    double line1y2 = size.height * .65;

    double line2x1 =
        size.width / 2 + size.width * cos(Angle.fromDegrees(320).radians) * .35;
    double line2y1 = size.height / 2 +
        size.height * sin(Angle.fromDegrees(320).radians) * .35;

    canvas.drawArc(rect, Angle.fromDegrees(_startingAngle!).radians,
        Angle.fromDegrees(360).radians, false, _paint!);
    canvas.drawLine(Offset(line1x1, line1y1), Offset(line1x2, line1y2), _paint!);
    canvas.drawLine(Offset(line2x1, line2y1), Offset(line1x2, line1y2), _paint!);

    // animation painter

    double circleValue, checkValue;
    if (value < .5) {
      checkValue = 0;
      circleValue = value / .5;
    } else {
      checkValue = (value - .5) / .5;
      circleValue = 1;
    }

    _paint!.color = const Color(0xff72d0c3);
    double firstAngle = _startingAngle! + 360 * circleValue;

    canvas.drawArc(
        rect,
        Angle.fromDegrees(firstAngle).radians,
        Angle.fromDegrees(
            getSecondAngle(firstAngle, _length!, _startingAngle! + 360))
            .radians,
        false,
        _paint!);

    double line1Value = 0, line2Value = 0;
    if (circleValue >= 1) {
      if (checkValue < .5) {
        line2Value = 0;
        line1Value = checkValue / .5;
      } else {
        line2Value = (checkValue - .5) / .5;
        line1Value = 1;
      }
    }

    double auxLine1x1 = (line1x2 - line1x1) * getMin(line1Value, .8);
    double auxLine1y1 =
        (((auxLine1x1) - line1x1) / (line1x2 - line1x1)) * (line1y2 - line1y1) +
            line1y1;

    if (_offset! < 60) {
      auxLine1x1 = line1x1;
      auxLine1y1 = line1y1;
    }

    double auxLine1x2 = auxLine1x1 + _offset! / 2;
    double auxLine1y2 =
        (((auxLine1x1 + _offset! / 2) - line1x1) / (line1x2 - line1x1)) *
            (line1y2 - line1y1) +
            line1y1;

    if (checkIfPointHasCrossedLine(Offset(line1x2, line1y2),
        Offset(line2x1, line2y1), Offset(auxLine1x2, auxLine1y2))) {
      auxLine1x2 = line1x2;
      auxLine1y2 = line1y2;
    }

    if (_offset! > 0) {
      canvas.drawLine(Offset(auxLine1x1, auxLine1y1),
          Offset(auxLine1x2, auxLine1y2), _paint!);
    }

    // SECOND LINE

    double auxLine2x1 = (line2x1 - line1x2) * line2Value;
    double auxLine2y1 =
        ((((line2x1 - line1x2) * line2Value) - line1x2) / (line2x1 - line1x2)) *
            (line2y1 - line1y2) +
            line1y2;

    if (checkIfPointHasCrossedLine(Offset(line1x1, line1y1),
        Offset(line1x2, line1y2), Offset(auxLine2x1, auxLine2y1))) {
      auxLine2x1 = line1x2;
      auxLine2y1 = line1y2;
    }
    if (line2Value > 0) {
      canvas.drawLine(
          Offset(auxLine2x1, auxLine2y1),
          Offset(
              (line2x1 - line1x2) * line2Value + _offset! * .75,
              ((((line2x1 - line1x2) * line2Value + _offset! * .75) - line1x2) /
                  (line2x1 - line1x2)) *
                  (line2y1 - line1y2) +
                  line1y2),
          _paint!);
    }
  }

  double getMax(double x, double y) {
    return (x > y) ? x : y;
  }

  double getMin(double x, double y) {
    return (x > y) ? y : x;
  }

  bool checkIfPointHasCrossedLine(Offset a, Offset b, Offset point) {
    return ((b.dx - a.dx) * (point.dy - a.dy) -
        (b.dy - a.dy) * (point.dx - a.dx)) >
        0;
  }

  double getSecondAngle(double angle, double plus, double max) {
    if (angle + plus > max) {
      _offset = angle + plus - max;
      return max - angle;
    } else {
      _offset = 0;
      return plus;
    }
  }

  @override
  bool shouldRepaint(CheckPainter old) {
    return old.value != value;
  }
}
