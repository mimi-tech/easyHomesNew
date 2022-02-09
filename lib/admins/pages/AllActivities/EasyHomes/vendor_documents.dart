import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/bookings/first_check/qty_each.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
class VendorDocument extends StatefulWidget {
  VendorDocument({required this.doc});
  final DocumentSnapshot doc;

  @override
  _VendorDocumentState createState() => _VendorDocumentState();

}

class _VendorDocumentState extends State<VendorDocument> with TickerProviderStateMixin{
  double _height = 70.0.h;
  double _width = 50.0.w;
  bool _resized = false;
  List<Widget> getImages(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < widget.doc['reg'].length; i++){
      print(widget.doc['reg'].length);
      Widget w = Column(
        children: [

          GestureDetector(
            onTap: (){
              getSizes(i);
            },
            child: AnimatedSize(
              curve: Curves.easeIn,
              vsync: this,
              duration: Duration(milliseconds: 500),
              child: Container(
                width: _width,
                height:_height,
                child: FadeInImage.assetNetwork(

                  image: '${ Variables.cylinderImage[i]}'.toString(),
                  placeholder: 'assets/imagesFolder/loading4.gif',

                  //placeholder: (context, url) => SvgPicture.asset('assets/imagesFolder/loading4.gif'),
                  imageErrorBuilder: (context, url, error) => SvgPicture.asset('assets/imagesFolder/loading4.gif'),
                  width: 50.0.w,
                  height: 70.0.h,
                  fit: BoxFit.cover,

                ),
              ),
            ),
          ),


        ],

      );
      list.add(w);
    }
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print()
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          title: TextWidget(
            name: '${widget.doc['fn']} documents',
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.w500,
          ),
        ),
        body: Wrap(
          direction: Axis.horizontal,
          children: getImages(),

        ),
      ),
    );
  }


  void getSizes(int i) {
    //reSize.clear();
    if(_resized ){
      setState(() {
        _resized = false;
        _height = 70.0;
        _width = 50.0;
      });
    }else{

      setState(() {
        _resized = true;

        _height = 150.0;
        _width = 100.0;
      });
    }
  }
}
