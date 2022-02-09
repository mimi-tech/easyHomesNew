import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class GasTypeTitle extends StatefulWidget {
  GasTypeTitle({required this.title});
  final String title;

  @override
  _GasTypeTitleState createState() => _GasTypeTitleState();
}

class _GasTypeTitleState extends State<GasTypeTitle> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.04);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
              PlatformIconButton(
              onPressed: () => Navigator.pop(context),
              materialIcon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
              cupertinoIcon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
              ),


            SvgPicture.asset('assets/imagesFolder/pick_up.svg'),

            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ScreenUtil()
                      .setWidth(250),
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
      ],
    );
  }
}
