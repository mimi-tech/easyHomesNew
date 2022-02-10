
import 'dart:async';
import 'package:easy_homes/utility/circle_painter.dart';

import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/curve_wave.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/utils/read_more.dart';
import 'package:easy_homes/work/stations/station_office.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';

import 'package:audioplayers/audioplayers.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/work/navigation_map.dart';
import 'package:easy_homes/work/vendor_office.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock/wakelock.dart';

class AcceptOrder extends StatefulWidget {
  const AcceptOrder({ this.size = 80.0, this.color = kSeaGreen,
    required this.onPressed, required this.pix,});
  final double size;
  final Color color;
  final Widget pix;
  final VoidCallback onPressed;
  @override
  _AcceptOrderState createState() => _AcceptOrderState();
}

class _AcceptOrderState extends State<AcceptOrder> with TickerProviderStateMixin {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  Widget spacerWidth() {
    return SizedBox(width: MediaQuery.of(context).size.width * 0.03);
  }



late DocumentSnapshot document;

  AudioPlayer audioPlayer = AudioPlayer();


  late AnimationController _controller;
  @override
  void initState() {
    super.initState();

    getMusic();
    _controller = AnimationController(
      vsync:this,
      value: 0.1,
      duration: const Duration(milliseconds: 500),

    )..repeat();
  }
  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    _controller.dispose();


    audioPlayer.dispose();
  }
  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(

              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .05) as Color
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: const CurveWave(),
              ),
            ),
            child: SvgPicture.asset('assets/imagesFolder/pick_up.svg'),
          ),
        ),
      ),
    );
  }





  void getMusic() async {

    audioPlayer = await AudioCache().play("r2.mp3");

    Future.delayed(const Duration(seconds: kCallDuration), () async {

      if(VariablesOne.playState == false){
        audioPlayer.stop();
        try {
          FirebaseFirestore.instance
              .collection('AllBusiness').doc(Variables.currentUser[0]['ca']).update({
                'con': false,

              });

              if(VariablesOne.decline == true){
                setState(() {
                  Variables.missedCall++;
                });
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => StationOffice(),
                  ),
                      (route) => false,
                );


              }else{
                VariablesOne.decline = true;
                Variables.missedCall++;
              }

//print('ddddddddddddd${ VariablesOne.decline}');



        } catch (e) {
          if(VariablesOne.decline == true){
            setState(() {
              Variables.missedCall++;
            });
            Navigator.pop(context);

          }else{
            Variables.missedCall++;
            VariablesOne.decline = true;
          }
        }
      }


    });

  }


  bool _publishModal = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(

      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Container(
color: kBlackColor.withOpacity(0.4),
          child: Stack(

            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height,

                child: CachedNetworkImage(

                  imageUrl: '${widget.pix}',
                  placeholder: (context, url) => Center(child: PlatformCircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 50.0.w,
                  height: 70.0.h,
                  fit: BoxFit.cover,

                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Icon(Icons.speaker_phone, size: 44,color: kLightBrown,)),

              Center(
                child: CustomPaint(
                  painter: CirclePainter(
                    _controller,
                    color: widget.color,
                  ),
                  child: SizedBox(
                    width: widget.size * 4.125,
                    height: widget.size * 4.125,
                    child: _button(),
                  ),
                ),
              ),

              Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBtn(nextFunction: (){notifyCustomer();}, bgColor: kDoneColor, title: 'ok')),

              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    )
    );
  }

  Future<void> notifyCustomer() async {
/*update customer details to cancel true*/
    setState(() {
      audioPlayer.stop();
      _publishModal = true;
      VariablesOne.playState = false;
      VariablesOne.decline = false;
    });
    try{
      /*update vendor connection false*/

      FirebaseFirestore.instance
          .collection('AllBusiness').doc(Variables.currentUser[0]['ca']).update({
        'con': false,

      });
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => StationOffice(),
        ),
            (route) => false,
      );



    }catch (e){
     print(e);
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }




}
