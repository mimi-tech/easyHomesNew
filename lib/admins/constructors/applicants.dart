import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ApplicantAppBar extends StatefulWidget {
  ApplicantAppBar({required this.camera, required this.add,required this.upload});
  final Function camera;
  final Function add;
  final Function upload;

  @override
  _ApplicantAppBarState createState() => _ApplicantAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);
}

class _ApplicantAppBarState extends State<ApplicantAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        shape:  RoundedRectangleBorder(
            borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
            )
        ),
        backgroundColor: kWhiteColor,
        pinned: true,
        automaticallyImplyLeading: false,
        elevation: 5,
        forceElevated: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[

              GestureDetector(
                onTap: widget.add as void Function(),
                child: SvgPicture.asset(

                  'assets/imagesFolder/add_vendor.svg',
                  height: 25.h,
                  width: 25.w,
                  color: kDoneColor,
                ),
              ),

              GestureDetector(
                onTap: widget.upload as void Function(),
                child: SvgPicture.asset('assets/imagesFolder/camera.svg',
                  height: 20.h,
                  width: 20.w,
                  color: kYellow,
                ),
              ),

              GestureDetector(
                onTap: widget.camera as void Function(),
                child: Icon(Icons.add_a_photo,

                  color: kDoneColor,
                ),
              ),

              GestureDetector(
                  onTap: () async {
                    var url = "tel:${AdminConstants.vendorDetails[0]['ph'].trim()}";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';


                    }
                  },
                  child: Icon(Icons.call,color: kDoneColor,))


            ]
        )
    );
  }
}
