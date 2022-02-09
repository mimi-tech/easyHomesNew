import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/qty.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_vendor_map.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';

import 'package:easy_homes/utility/text.dart';

import 'package:easy_homes/utils/read_more.dart';
import 'package:easy_homes/utils/searchbar.dart';
import 'package:easy_homes/work/constructors/details_construct.dart';
import 'package:easy_homes/work/constructors/verify_construct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ScheduledScreen extends StatefulWidget {
  @override
  _ScheduledScreenState createState() => _ScheduledScreenState();
}

class _ScheduledScreenState extends State<ScheduledScreen> {
  String? filter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerDetails();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _stream!.cancel();
  }

  var itemsData = <dynamic>[];
  bool _itemLength = false;
  var itemsIndex = <int>[];
  bool showFirstContainer = true;
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);
  }
  bool progress = false;
 StreamSubscription? _stream;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;

  Widget bodyList(int index){
    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space(),
            Text("vendor's name",
              textAlign: TextAlign.center,
              style: GoogleFonts.oxanium(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil()
                    .setSp(kFontSize, ),
                color: kDoneColor,
              ),
            ),
            Row(
              children: [
                VendorPix(pix: itemsData[index]['vpi'], pixColor: Colors.transparent),
                Column(
                  children: [
                    TextWidget(
                      name: itemsData[index]['vfn'],
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                    TextWidget(
                      name: itemsData[index]['vln'],
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                  ],
                ),


                Spacer(),

                AnimatedSwitcher(
                  duration: Duration(seconds: 2),


                  child:  itemsIndex.contains(index)?Container(
                    key: UniqueKey(),

                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape:BoxShape.circle,
                        color: kRedColor
                    ),
                    child: IconButton(

                        onPressed:(){
                          setState(() {

                            getIndexClose(index);
                            showFirstContainer = !showFirstContainer;
                          });
                        },
                        icon: Icon(Icons.close,color: kWhiteColor,)
                    ),
                  ):
                  Container(
                    key: UniqueKey(),

                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape:BoxShape.circle,
                        color: kDoneColor
                    ),
                    child: IconButton(

                        onPressed:(){
                          getOrders(index);
                        },
                        icon: Icon(Icons.view_agenda_rounded,color: kWhiteColor,)
                    ),
                  ),

                  switchOutCurve: Curves.easeInOutCubic,
                  switchInCurve: Curves.fastLinearToSlowEaseIn,
                  transitionBuilder: (Widget child, Animation<double> animation) =>
                      ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                ),



              ],
            ),
            Divider(),
            Text("customer's name",
              textAlign: TextAlign.center,
              style: GoogleFonts.oxanium(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil()
                    .setSp(kFontSize, ),
                color: kDoneColor,
              ),
            ),

            TextWidget(
              name: '${itemsData[index]['fn']}  ${itemsData[index]['ln']}',
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.w500,
            ),


            Text("Gas station",
              textAlign: TextAlign.center,
              style: GoogleFonts.oxanium(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil()
                    .setSp(kFontSize, ),
                color: kDoneColor,
              ),
            ),

            Row(

              children: [
                TextWidget(
                  name: '${itemsData[index]['cm']}',
                  textColor: kTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),

                IconButton(icon: Icon(
                  Icons.location_on_rounded,color: kRedColor,
                ), onPressed: (){_getBizLocation(index);})
              ],
            ),


            space(),


            Visibility(
              visible: itemsIndex.contains(index)?true:false,
              child: AnimatedOpacity(
                opacity: itemsIndex.contains(index) ? 1.0 : 0.0,
                duration: Duration(seconds: 4),
                child: Container(
                  //margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Text("Service",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.oxanium(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kDoneColor,
                        ),
                      ),
                      ReadMoreTextConstruct(title: itemsData[index]['bgt'], colorText: kLightBrown),

                      Divider(),

                      RichText(
                        text: TextSpan(
                            text: 'Initial cylinder weight: ',
                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil()
                                  .setSp(14, ),
                              color: kListTileColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: itemsData[index]['trw'].toString(),
                                style: GoogleFonts.oxanium(
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil()
                                      .setSp(kFontSize, ),
                                  color: kProfile,
                                ),
                              )
                            ]),
                      ),


                      RichText(
                        text: TextSpan(
                            text: 'Expected cylinder weight: ',
                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil()
                                  .setSp(14, ),
                              color: kListTileColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: itemsData[index]['ew'].toString(),
                                style: GoogleFonts.oxanium(
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil()
                                      .setSp(kFontSize, ),
                                  color: kProfile,
                                ),
                              )
                            ]),
                      ),
                      OrdersRow(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          DateBookings(date:itemsData[index]['date'],
                            time: itemsData[index]['by'] == true?'0 TKG':'${itemsData[index]['gk'].toString()} TKG',
                          ),


                          Column(
                            children: <Widget>[
                              itemsData[index]['by'] == true?
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  TextWidget(
                                    name: '0 TKG',
                                    textColor: kBlackColor,
                                    textSize: kFontSize14,
                                    textWeight: FontWeight.bold,
                                  ),

                                  NewBookingDetails(
                                      rent: '',
                                      kgs:  '${itemsData[index]['cKG']} Kg',

                                      quantity:  itemsData[index]['cQ'],
                                      qty: ''.toString(), 
                                    number: ''.toString(),
                                    amt: ''.toString(),
                                    kg: ''.toString(),
                                    type: ''.toString(),
                                  )
                                ],
                              )
                                  :
                              BookingDetails(
                                kg: '${itemsData[index]['gk']}'.toString(),
                                rent: itemsData[index]['re'] == true?'(RENT)':'', type: '', qty: ''.toString(), number: ''.toString(),
                              ),

                              itemsData[index]['acy'] == null?Text(''):NewBookingDetails(
                                  rent: itemsData[index]['re'] == true?'(RENT)':'',

                                  kgs:  itemsData[index]['cKG'],

                                  quantity: itemsData[index]['cQ'],
                                  qty: ''.toString(),
                                  number: ''.toString(),
                                  amt: ''.toString(),
                                  kg: ''.toString(),
                                  type: ''.toString(),
                              )


                            ],
                          ),



                          itemsData[index]['by'] == true?
                          AmountOrderStations( gas: itemsData[index]['amt']  ,mop: itemsData[index]['mp'],)
                              :
                          itemsData[index]['acy'] == null? AmountOrderStations( gas: itemsData[index]['aG'],mop: itemsData[index]['mp'] ,)
                              :AmountOrderNewStation(
                            gas: itemsData[index]['aG'],
                            cylinder: itemsData[index]['acy'],
                            mop: itemsData[index]['mp'],
                            total: itemsData[index]['aG'] + itemsData[index]['acy'],
                          )

                        ],
                      ),


                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: progress,
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
        child: Container(

          height: MediaQuery.of(context).size.height * kModalHeight,
          child:itemsData.length == 0 && _itemLength == false
              ? Center(child: PlatformCircularProgressIndicator())
              : itemsData.length == 0 && _itemLength == true
              ? NoOnGoing(title: 'Sorry there is no ongoing order',)
              : SingleChildScrollView(
            child: Column(
              children: [
                StickyHeader(
                    header:SearchBar(title: 'Ongoing order',),
                    content:  ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: itemsData.length,
                        itemBuilder: (context, int index) {
                          return filter == null || filter == "" ?bodyList(index):
                          '${itemsData[index]['biz']}'.toLowerCase()
                              .contains(filter!.toLowerCase())

                              ?bodyList(index):Container();
                        }),


                ),
                progress == true ||
                    progress == true ||
                    _loadMoreProgress == true ||
                    itemsData.length < Variables.limit
                    ? Text('')
                    : moreData == true
                    ? PlatformCircularProgressIndicator()
                    : GestureDetector(
                    onTap: () {
                      loadMore();
                    },
                    child: SvgPicture.asset(
                      'assets/imagesFolder/load_more.svg',
                    ))
              ],

            ),
          ),
        ),
      ),
    );
  }
  Future<void> getCustomerDetails() async {

    _stream =  FirebaseFirestore.instance.collection('customer')
        .where('gv',isEqualTo: false )
        .limit(Variables.limit)

        .snapshots().listen((result) async {
    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
      setState(() {
        _itemLength = true;
      });
    } else {

       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;
        itemsData.clear();

        setState(() {

          itemsData.add(document.data());

        });
      }
    }
  });}



  Future<void> loadMore() async {
    _stream =  FirebaseFirestore.instance.collection('customer')
        .where('gv',isEqualTo: false )
        .startAfterDocument(_lastDocument)
        .limit(Variables.limit)
        .snapshots().listen((result) async {
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        _loadMoreProgress = true;
      });
    } else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          itemsData.add(document.data());

          moreData = false;
        });
      }
    }
  });}


  void getOrders(int index) {

    if(itemsIndex.contains(index)){
      setState(() {
        itemsIndex.remove(index);

      });
    }else{
      setState(() {
        itemsIndex.add(index);

      });
    }

    setState(() {
      showFirstContainer = !showFirstContainer;
    });
  }

  void getIndexClose(int index) {
    if(itemsIndex.contains(index)){
      setState(() {
        itemsIndex.remove(index);

      });
    }else{
      setState(() {
        itemsIndex.add(index);

      });
    }
  }

  Future<void> _getBizLocation(int index) async {


    final QuerySnapshot result = await FirebaseFirestore.instance
.collectionGroup('companyVendors')
        .where('vId', isEqualTo:itemsData[index]['vid'])


        .get();

    final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){

    }else{

      PageConstants.getVendor.clear();
      for (DocumentSnapshot document in documents) {
        PageConstants.getVendor.add(document.data());
      }
    }
    Navigator.push(context, PageTransition(type: PageTransitionType.fade,  child: BizVendorMap(index:index)));
  }



}

























