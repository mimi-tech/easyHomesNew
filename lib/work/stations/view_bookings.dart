import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/qty.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/earnings_construct.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/splash.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/utils/read_more.dart';
import 'package:easy_homes/utils/searchbar.dart';
import 'package:easy_homes/utils/shimmer_bg.dart';
import 'package:easy_homes/work/constructors/details_construct.dart';
import 'package:easy_homes/work/constructors/verify_construct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ViewBookings extends StatefulWidget {
  @override
  _ViewBookingsState createState() => _ViewBookingsState();
}

class _ViewBookingsState extends State<ViewBookings> {
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
  var itemsData = <dynamic>[];
bool _itemLength = false;
  var itemsIndex = <int>[];
  bool showFirstContainer = true;
Widget space(){
  return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);
}
bool progress = false;

Widget bodyList(int index){
  return Card(
    elevation: 5,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(icon: Icon(Icons.refresh,color: kRedColor,), onPressed: (){
              setState(() {
                itemsData.clear();
              });
              getCustomerDetails();
            }),
          ),

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
                      icon: Icon(Icons.arrow_drop_down_sharp,color: kWhiteColor,)
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


                    Divider(),
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

                    Divider(),
                    space(),
                    Align(
                      alignment: Alignment.topRight,
                      child: RaisedButton(
                        color: kDoneColor,
                        onPressed: (){_verifyBooking(index);},
                        child:  TextWidget(
                          name: kSold,
                          textColor: kWhiteColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.w500,
                        ),
                      ),
                    )
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
    return ProgressHUDFunction(
      inAsyncCall: progress,
      child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(seconds: 1),
          curve: Curves.decelerate,
          child: Container(

            height:VariablesOne.searchHeight? MediaQuery.of(context).size.height * 0.5: MediaQuery.of(context).size.height * kModalHeight,
            child:itemsData.length == 0 && _itemLength == false
                ? Center(child: PlatformCircularProgressIndicator())
                : itemsData.length == 0 && _itemLength == true
                ? NoOnGoing(title: 'Sorry you have no ongoing order for your gas station',)
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
        '${itemsData[index]['fn']}'.toLowerCase()
            .contains(filter!.toLowerCase())

            ?bodyList(index):Container();
      })
                  )],
          ),
                ),
          ),
      ),
    );
  }
  Future<void> getCustomerDetails() async {
    itemsData.clear();

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('customer')
        .where('gd', isEqualTo: Variables.currentUser[0]['ca'])
        .where('gv',isEqualTo: false )
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
      setState(() {
        _itemLength = true;
      });
    } else {

     for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {itemsData.add(document.data());

        });
      }
    }
  }

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

  void _verifyBooking(int index) {

    showDialog(
        context: context,
        builder: (context) => Platform.isIOS ?
        CupertinoAlertDialog(
          title: TextWidget(
            name: kCancelOrder.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),

          content:VerifyConstruct(title: itemsData[index]['cm'], msg:'${itemsData[index]['gk']}Tkg refilled.\n Delivery vendor - ',name:'${itemsData[index]['vfn']} ${itemsData[index]['vln']}',),




          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                //deleteOrder(index);
                if(itemsData[index]['uo'] == true){
                  deleteOrder(index);
                }else{
                  VariablesOne.notifyErrorBot(title: 'Please wait let customer put initial weight');
                }
              },
            ),
          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child: TextWidgetAlign(
              name: 'Gas refilled'.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          )
          ,
          children: <Widget>[
             VerifyConstruct(title: itemsData[index]['cm'], msg:'${itemsData[index]['gk']}Tkg refilled.\n Delivery vendor - ',name: '${itemsData[index]['vfn']} ${itemsData[index]['vln']}',),

            YesNoBtn(no: (){Navigator.pop(context);},yes: (){
              //check if customer has updated the initial weight
              if(itemsData[index]['uo'] == true){
                deleteOrder(index);
              }else{
                VariablesOne.notifyErrorBot(title: 'Please wait let customer put initial weight');
              }

            }

              ,),
          ],
        ));





  }

  void deleteOrder(int index) {

Navigator.pop(context);
    setState(() {
      progress = true;
    });
    //updating customer that gas has be delivered to vendor
    try {
      FirebaseFirestore.instance.collection('customer').doc(itemsData[index]['vid'])
          .update({
        'gv': true,
        'pid':Variables.currentUser[0]['outId']
      });


      //updating the gas station ongoing has ended
      FirebaseFirestore.instance.collection('AllBusiness')
          .doc(itemsData[index]['gd'])
          .update({
        'tr': false,
      });

      //update count for the sales lady
      FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid).get().then((resultEarnings) {

        var totalCount = resultEarnings.data()!['co'] + 1;

        resultEarnings.reference.set({
          'co':totalCount,
        },SetOptions(merge: true));
      });
      itemsData.removeAt(index);
      setState(() {
        VariablesOne.gasOrderCount--;
      });

Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Confirmed successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
    }catch (e){
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
    setState(() {
      progress = false;
    });

  }

}
