import 'dart:io';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/first_modal.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
class SecScreen extends StatefulWidget {
  @override
  _SecScreenState createState() => _SecScreenState();
}

class _SecScreenState extends State<SecScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          leading: IconButton(
            icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: kWhiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextWidget(name:  AdminConstants.bizName!.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),

              GestureDetector(
                  onTap: (){

                    Platform.isIOS?CupertinoActionSheet(

                      actions: <Widget>[
                        SelectType()
                      ],
                    ):showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => SelectType()
                    );



                  },
                  child: SvgPicture.asset('assets/imagesFolder/add_circle.svg',)),
            ],
          ),
        ),
        body: Container(

        ),
      ),
    );
  }
}
