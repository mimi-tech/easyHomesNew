import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class ChoosePhoto extends StatefulWidget {
  ChoosePhoto({required this.camera, required this.gallery});

  final Function camera;
  final Function gallery;

  @override
  _ChoosePhotoState createState() => _ChoosePhotoState();
}

class _ChoosePhotoState extends State<ChoosePhoto> {
  Widget space(){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: Column(
    children: <Widget>[
      space(),
      Text('Get your picture from'.toUpperCase(),
        style:GoogleFonts.oxanium(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(kFontSize, ),
          color: kDoneColor,
        ),
      ),
      Divider(),
      space(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              PlatformIconButton(
                icon: Icon(Icons.camera,color: kLightBrown,size: 30,),
                onPressed: widget.camera as void Function()
              ),
              space(),
              Text('Camera',
                style:GoogleFonts.oxanium(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(kFontSize, ),
                  color: kTextColor,
                ),
              ),
            ],
          ),

          Column(
            children: <Widget>[
              Platform.isIOS?
                    PlatformIconButton(
                    icon: Icon(Icons.photo_library_rounded,size: 30,),
                    onPressed: widget.gallery as void Function()
                    )
                  :IconButton(
                  icon: Icon(Icons.photo_library_rounded,color: kLightBrown,size: 30,),
                  onPressed: widget.gallery as void Function()
              ),
              space(),
              Text('Gallery',
                style:GoogleFonts.oxanium(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(kFontSize, ),
                  color: kTextColor,
                ),
              ),
            ],
          )
        ],
      ),

      space(),


    ]
    )
        )
    );
  }
}
