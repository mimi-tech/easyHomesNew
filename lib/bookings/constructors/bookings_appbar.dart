import 'dart:io';

import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/blocked_users.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';

class BookingAppBar extends StatefulWidget implements PreferredSizeWidget{
  BookingAppBar({required this. title});
  final String title;

  @override
  _BookingAppBarState createState() => _BookingAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _BookingAppBarState extends State<BookingAppBar> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: kWhiteColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          SvgPicture.asset('assets/imagesFolder/pick_up.svg'),
          Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ScreenUtil()
                    .setWidth(200),
                minHeight: ScreenUtil()
                    .setHeight(20),
              ),
              child: ReadMoreText(widget.title.toUpperCase(),
                trimLines: 1,
                colorClickableText: kLightBrown,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' ...',
                trimExpandedText: '  less',
                style: GoogleFonts.oxanium(
                    fontSize: ScreenUtil().setSp(kFontSize, ),
                    color: kLightBrown,
                    fontWeight: FontWeight.w500

                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}


class BookingsBottomAppBar extends StatefulWidget {
  BookingsBottomAppBar({required this.next, required this.nextColor});
  final Function next;
  final Color nextColor;

  @override
  _BookingsBottomAppBarState createState() => _BookingsBottomAppBarState();
}

class _BookingsBottomAppBarState extends State<BookingsBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 5)]),
      child: BottomAppBar(

        shape: CircularNotchedRectangle(),
        child: GestureDetector(
          onTap: widget.next as void Function(),
          child: Container(
            height: 56.0,
            color: widget.nextColor,
            width: double.infinity,
            child:  Center(
              child: TextWidget(
                name: kNextBtn.toUpperCase(),
                textColor: kWhiteColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class CupertinoTextAppbar extends StatelessWidget {
  CupertinoTextAppbar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[

        SvgPicture.asset('assets/imagesFolder/pick_up.svg'),
        Container(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ScreenUtil()
                  .setWidth(200),
              minHeight: ScreenUtil()
                  .setHeight(20),
            ),
            child: ReadMoreText(title.toUpperCase(),
              trimLines: 1,
              colorClickableText: kLightBrown,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' ...',
              trimExpandedText: '  less',
              style: GoogleFonts.oxanium(
                  fontSize: ScreenUtil().setSp(kFontSize, ),
                  color: kLightBrown,
                  fontWeight: FontWeight.w500

              ),
            ),
          ),
        ),


      ],
    );
  }
}
