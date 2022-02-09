import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/messages/general.dart';
import 'package:easy_homes/reg/constants/variables.dart';
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

class MessageVendorScreen extends StatefulWidget {
  @override
  _MessageVendorScreenState createState() => _MessageVendorScreenState();
}

class _MessageVendorScreenState extends State<MessageVendorScreen> {
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }



  StreamController<List<DocumentSnapshot>> _streamController =
  StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool isLoading = false;
  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        _products.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else {

        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            _products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });

    if(isChange) {
      _streamController.add(_products);
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance.collection('message')
        .where('yr', isEqualTo: DateTime.now().year)
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },

    child: SafeArea(child: PlatformScaffold(
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
              TextWidget(name: Variables.currentUser[0]['biz'].toUpperCase(),// AdminConstants.bizName!.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),


            ],
          ),
        ),

        body: SingleChildScrollView(
          child: Container(
          child: Column(
              children: <Widget>[
              spacer(),




    StreamBuilder<List<DocumentSnapshot>>(
    stream: _streamController.stream,

    builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
      if(snapshot.data == null){
        return TextWidgetAlign(
          name: kNews,
          textColor: kTextColor,
          textSize: kFontSize,
          textWeight: FontWeight.w500,
        );
    } else {
    return Column(
    children: snapshot.data!.map((doc) {
                                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Column(
      children: <Widget>[
          Card(
            elevation:29,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: Column(
                children: <Widget>[
                  spacer(),
                Row(
                  children: <Widget>[
                    spacer(),
                    TextWidget(
                      name: kDate,
                      textColor: kRadioColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                    TextWidget(
                    name: data['dtm'],
      textColor: kLogoColor2,
      textSize: kFontSize,
      textWeight: FontWeight.w500,
    ),
                  ],
                ),

                  spacer(),
                  /*TextWidget(
                    name: doc.data['hd'],
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w400,
                  ),

                  spacer(),*/
                  Container(
                    alignment: Alignment.topLeft,
                    child: TextWidget(
                      name: kMessage2.toUpperCase(),
                      textColor: kDoneColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),
                  ),
                  spacer(),

                  Container(
                    alignment: Alignment.topLeft,
                    child: ConstrainedBox(

                      constraints: BoxConstraints(
                        maxWidth: double.infinity,
                        minHeight: ScreenUtil()
                            .setHeight(kConstrainedHeight),
                      ),
                      child: ReadMoreText( '${data['hd'].toString().toUpperCase()} \n \n ${data['ms']}',

                        trimLines: 2,
                        colorClickableText:kRedColor,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' ...',
                        trimExpandedText: ' \n show less...',
                        style: GoogleFonts.oxanium(
                          textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(kFontSize, ),
                            color: kTextColor,
                              fontWeight:FontWeight.bold,
                          )
                        )
                      ),
                    ),
                  ),

                  spacer(),
                ],
              ),
            ),
          )
      ],
    );



    }).toList()
    );
    }
    }
    ),

                _isFinish == false?
                isLoading == true ?PlatformCircularProgressIndicator():Text('')

                    :Text('')



              ]
    )

    ),
        )
    )
    )
    );

  }


  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;

      if (_products.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance.collection('message')

            .where('yr', isEqualTo: DateTime.now().year)
            .orderBy('ts',descending: true)
            .limit(20)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await FirebaseFirestore.instance.collection('message')

            .where('yr', isEqualTo: DateTime.now().year)
            .orderBy('ts',descending: true)
            .startAfterDocument(_products[_products.length - 1])
            .limit(20)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _products.length;
        _products.addAll(querySnapshot.docs);
        int newSize = _products.length;
        if (oldSize != newSize) {
          _streamController.add(_products);
        } else {
          setState(() {
            _isFinish = true;
            isLoading = false;
          });
        }
      }
      _isRequesting = false;
    }
  }
}
