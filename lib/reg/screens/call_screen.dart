/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/work/navigation_map.dart';
import 'package:easy_homes/work/vendor_office.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';


class ShowCustomer extends StatefulWidget {
  @override
  _ShowCustomerState createState() => _ShowCustomerState();
}

class _ShowCustomerState extends State<ShowCustomer> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05);
  }

  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getNavigation();
    getMusic();
  }


  void getMusic() async {
    audioPlayer = await AudioCache().play("sound.mp3");
    //audioPlayer.setVolume(5.0);
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    Future.delayed(const Duration(seconds: 60), () {
      setState(() {
        audioPlayer.stop();
      });

      */
/*update dateBase that not accepted is false*//*

*/
/*try {
  Firestore.instance
      .collectionGroup('companyVendors')
      .where('vId', isEqualTo: Variables.userUid)
      .getDocuments().then((value) {
    value.documents.forEach((result) {
      result.reference.update({
        'ac': Variables.vendorNotAccept,

      }).whenComplete(() {
        setState(() {
          Variables.missedCall++;
        });
        Navigator.pushReplacement(context,
            PageTransition(
                type: PageTransitionType
                    .scale,
                alignment: Alignment
                    .bottomCenter,
                child: VendorOffice()));
      }).catchError((onError) {
        print(onError.toString());
      });
    });
  });
}catch(e){
  print(e.toString());
}*//*

    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection
('Transit')
                  .where('ud',isEqualTo: Variables.userUid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: PlatformCircularProgressIndicator(),);
                } else {

                  return Column(
                    children: snapshot.data.documents.map((doc) {
                      List<dynamic> loadImages = doc['cyt'];
                      List<dynamic> loadKg = doc['cytKG'];
                      List<dynamic> loadQuantity = doc['cyQty'];
                      return Column(
                        children: <Widget>[

                          Text('njkjn'),
                          */
/*Stack(
               alignment: Alignment.bottomRight,
               children: <Widget>[

                 Container(
                   child: SvgPicture.asset('assets/imagesFolder/call_bg.svg',
                     width: MediaQuery
                         .of(context)
                         .size
                         .width,
                     //height: MediaQuery.of(context).size.height*1.5,
                   ),
                 ),

                 Container(
                   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.end,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           TextWidget(
                             name: 'Gas Order'.toUpperCase(),
                             textColor: kLightBrown,
                             textSize: kFontSize,
                             textWeight: FontWeight.w900,
                           ),

                           CircleAvatar(
                             backgroundColor: Colors.transparent,
                             //radius: 32,
                             child: ClipRRect(
                               borderRadius: BorderRadius.circular(8.0),
                               child: CachedNetworkImage(

                                 imageUrl:  Variables.userPix,
                                 placeholder: (context, url) => CircularProgressIndicator(),
                                 errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/user.svg'),
                                 fit: BoxFit.cover,
                                 width: 55.w,
                                 height: 60.h,

                               ),
                             ),
                           ),

                         ],
                       ),
                       TextWidget(
                         name: doc.data['add'],
                         textColor: kWhiteColor,
                         textSize: kFontSize,
                         textWeight: FontWeight.w500,
                       ),
                       TextWidget(
                         name: doc.data['dist'].toString() +
                             'Km' + " " + '( ' + doc.data['time'].toString() +
                             " " + 'mins' + ' )',
                         textColor: kYellow,
                         textSize: kFontSize,
                         textWeight: FontWeight.w400,
                       ),

                       TextWidget(
                         name: doc.data['fn'],
                         textColor: kWhiteColor,
                         textSize: kFontSize,
                         textWeight: FontWeight.bold,
                       ),

                       TextWidget(
                         name: doc.data['ln'],
                         textColor: kWhiteColor,
                         textSize: kFontSize,
                         textWeight: FontWeight.bold,
                       ),


                     ],


                   ),
                 ),

               ],
             ),*//*




                          */
/*Container(
               color: Colors.grey.withOpacity(0.2),
               child: AspectRatio(
                 aspectRatio: 3 / 2,

                 child: CachedNetworkImage(

                   imageUrl: doc.data['pix'],
                   placeholder: (context, url) => PlatformCircularProgressIndicator(),
                   errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/user.svg'),
                   fit: BoxFit.fitHeight,
                   width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height*0.3,


                 ),
               ),
             ),
*//*



                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              // SvgPicture.asset(doc.data['bgti']),


                              RichText(
                                text: TextSpan(
                                    text: ('shdbs' +'\n'.substring(0,12)),
                                    style:GoogleFonts.oxanium(
                                      fontWeight:FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(kFontSize2, ),
                                      color: kTextColor,
                                    ),

                                    children: <TextSpan>[
                                      TextSpan(
                                        text:doc.data['bgt'],
                                        style:GoogleFonts.oxanium(
                                          fontWeight:FontWeight.w500,
                                          fontSize: ScreenUtil().setSp(kFontSize, ),
                                          color: kProfile,
                                        ),
                                      )
                                    ]
                                ),
                              ),

                              spacer(),
*/
/*Container(

  child:ListView.builder(
    shrinkWrap: true,
    physics:  BouncingScrollPhysics(),
    itemCount: loadImages.length,
    itemBuilder: (context, int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CachedNetworkImage(

            imageUrl: loadImages[index]['cyt'],
            placeholder: (context, url) => PlatformCircularProgressIndicator(),
            errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/user.svg'),
            fit: BoxFit.fitHeight,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.3,


          ),

          TextWidget(
            name: loadKg[index]['cyKG'],
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),

          TextWidget(
            name: loadQuantity[index]['cyQty'],
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),


        ],
      );

            }
  )
)*//*



                            ],
                          ),

                          DividerLine(),
                          spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                  onTap:(){
                                    */
/*update the vendor database by setting accept to true*//*

                                    Firestore.instance
                                        .collectionGroup('companyVendors')
                                        .where('vId', isEqualTo: Variables.userUid)
                                        .getDocuments().then((value) {
                                      value.documents.forEach((result) {
                                        result.reference.update({
                                          'ac':Variables.vendorAccept,

                                        }).whenComplete(() {

                                          Navigator.pushReplacement(context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .scale,
                                                  alignment: Alignment
                                                      .bottomCenter,
                                                  child: NavigationRoute()));


                                        }).catchError((onError){
                                          print(onError.toString());
                                        });
                                      });



                                    });

                                  },

                                  child: SvgPicture.asset('assets/imagesFolder/accept.svg',)),

                              GestureDetector(
                                  onTap:(){
                                    */
/*move the vendor back to his office*//*


                                    Navigator.pushReplacement(context,
                                        PageTransition(
                                            type: PageTransitionType
                                                .scale,
                                            alignment: Alignment
                                                .bottomCenter,
                                            child: VendorOffice()));
                                  },
                                  child: SvgPicture.asset('assets/imagesFolder/decline.svg',)),


                              spacer(),


                            ],
                          )
                        ],







                      );

                    }).toList(),
                  );
                }
              }
          ),

          */
/*displaying the vendor profile picture*//*




        ],
      ),
    )));
  }
}
*/

/*


Column(
crossAxisAlignment: CrossAxisAlignment.stretch,

children: <Widget>[
ListView.builder(
shrinkWrap: true,
physics:  BouncingScrollPhysics(),
itemCount: loadImages.length,
itemBuilder: (context, int index) {
return IntrinsicHeight(
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: <Widget>[
SvgPicture.asset(loadImages[index],),

VerticalLine(),
TextWidget(
name: loadKg[index],
textColor: kTextColor,
textSize: kFontSize,
textWeight: FontWeight.bold,
),
VerticalLine(),
TextWidget(
name: loadQuantity[index],
textColor: kTextColor,
textSize: kFontSize,
textWeight: FontWeight.bold,
),


],
),
);

}
),
],
),*/


/*

spacer(),
DividerLine(),

Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: <Widget>[
TextWidget(
name: kCylinderHead,
textColor: kTextColor,
textSize: kFontSize,
textWeight: FontWeight.normal,
),
TextWidget(
name: kKGText,
textColor: kTextColor,
textSize: kFontSize,
textWeight: FontWeight.normal,
),
TextWidget(
name: kQuantitys,
textColor: kTextColor,
textSize: kFontSize,
textWeight: FontWeight.normal,
),
]
),

*/

