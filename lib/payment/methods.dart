import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/transfer_modal.dart';
import 'package:easy_homes/payment/cash_construct.dart';
import 'package:easy_homes/payment/new_card_form.dart';
import 'package:easy_homes/payment/promo_card.dart';
import 'package:easy_homes/payment/wallet_construct.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethods extends StatefulWidget {
  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  Widget spaceWidth() {
    return SizedBox(width: MediaQuery
        .of(context)
        .size
        .width * 0.05);
  }
  var itemsData = <dynamic>[];
   var _documents = <DocumentSnapshot>[];

  bool showCard = false;
  double elevation = 10.0;
  double horizontal = 10.0;
  double left = 70.0;
  bool showFirstContainer = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsersCard();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(

        appBar: PlatformAppBar(

          backgroundColor: kWhiteColor,
          leading: PlatformIconButton(

            materialIcon: Icon(Icons.close,color: kBlackColor,),
            cupertinoIcon: Icon(
              CupertinoIcons.clear_thick,
              color: kBlackColor,
            ),
            onPressed:(){
              setState(() {
                showFirstContainer = !showFirstContainer;

              });
              Navigator.pop(context);
            },
          ),





          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextWidget(
                name: kPaymentMethod,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w900,
              ),

              AnimatedSwitcher(
                duration: Duration(seconds: 2),


                child: showFirstContainer?Text('',key: UniqueKey(),):ElevatedButton(
                  key: UniqueKey(),

                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kDoneColor)

                  ),

                  onPressed:(){Navigator.pop(context);},
                  child:TextWidget(
                    name: 'Done',
                    textColor: kWhiteColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,
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



        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: horizontal),
            child: Column(

              children: <Widget>[
                space(),

                Visibility(
                  visible: VariablesOne.checkPayment?true:false,
                  child: AnimationSlide(
                    title: TextWidgetAlign(
                      name: 'You have insufficient balance in your wallet, please select how you want to make payment for your gas order',
                      textColor: kDoneColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                  ),
                ),
                space(),


                GestureDetector(
                  child: Card(
                      elevation: elevation,
                      color: kLightBrown,
                      child:
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: horizontal),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            space(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                space(),
                                Variables.currentUser[0]['mp'] == kCard?
                                IconButton(icon: Icon(
                                    Icons.radio_button_checked,color: kBlackColor,
                                ), onPressed: (){_card();})

                                    :IconButton(icon: Icon(
                                  Icons.radio_button_unchecked,color: kWhiteColor,
                                ), onPressed: (){_card();}),
                                GestureDetector(
                                  onTap: (){_card();},

                                  child: SvgPicture.asset(
                                      'assets/imagesFolder/credit_card2.svg'),
                                ),

                                Row(
                                  children: <Widget>[
                                    SvgPicture.asset('assets/imagesFolder/visa2.svg'),
                                    SvgPicture.asset(
                                        'assets/imagesFolder/master_card.svg'),

                                  ],
                                )

                              ],
                            ),
                            space(),
                            space(),
                            VariablesOne.showCard?
                            Align(
                              alignment: Alignment.topRight,
                              child: NewBtn( nextFunction: () {
                                setState(() {
                                  VariablesOne.showCard = false;
                                });}, bgColor: kBlackColor,title: 'Hide',

                                )
                            )
                           :Container(
                               margin: EdgeInsets.only(left: ScreenUtil().setSp(left)),
                                child: GestureDetector(
                                    onTap: (){
                                      getUsersCard();

                                      setState(() {
                                        VariablesOne.showCard = true;
                                      });
                                    },
                                    child: SvgPicture.asset('assets/imagesFolder/card_btn.svg'))

                            ),
                            space(),

    Visibility(
      visible: VariablesOne.showCard,
      child:
      Column(
        children: [
          itemsData.length == 0?
          Text(''):

          Divider(color: kWhiteColor,),

         ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _documents.length,
                    itemBuilder: (context, int index) {
                      return ListTile(
                        leading: itemsData[index]['cv'] ==
                            Variables.currentUser[0]['ccv'] ?
                        IconButton(icon: Icon(
                          Icons.radio_button_on, color: kWhiteColor,),
                            onPressed: () {})
                            : IconButton(icon: Icon(
                          Icons.radio_button_unchecked, color: kWhiteColor,),
                            onPressed: () {
                              resetCurrentCard(index);
                            }),
                        title: GestureDetector(
                          onTap: (){
                            resetCurrentCard(index);
                            },
                          child: Row(
                            children: [
                              itemsData[index]['ty'] == kVisa ? SvgPicture.asset(
                                'assets/imagesFolder/visa2.svg', height: 10,
                                width: 10,) :  itemsData[index]['ty'] == kMaster?SvgPicture.asset(
                                'assets/imagesFolder/master_card.svg',):Text(''),
                              TextWidget(
                                name: '${itemsData[index]['fd'].toString()} .. .... ${itemsData[index]['la']}',
                                textColor: kWhiteColor,
                                textSize: kFontSize14,
                                textWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.cancel, color: kWhiteColor,),
                            onPressed: () {
                              _removeCard(index,_documents);
                            }),
                      );

              }
    ),
          Divider(color: kWhiteColor,),

          Padding(
            padding: const EdgeInsets.only(left:28.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/imagesFolder/card_logo.svg'),
                SizedBox(width: 20,),

                TextWidget(
                  name: 'Add new card',
                  textColor: kWhiteColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),

              ],
            ),
          ),

          NewCardForm(),

        ],
      ),
    ),



                          ],
                        ),
                      )
                  ),
                ),



                WalletConstruct(),

                CashConstruct(),



                //space(),
                PromoConstruct(),






              ],

            ),),
        )
    )
    );
  }



  void _card() {

    try{
      FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid).set({
        'mp':kCard,
      },SetOptions(merge: true));

setState(() {
  Variables.currentUser[0]['mp'] = kCard;
  Variables.mop = kCard;
  showFirstContainer = false;
});

      BotToast.showSimpleNotification(title: '$kPMtext $kCard',
          backgroundColor: kBlackColor,
          duration: Duration(seconds: 7),
        titleStyle: GoogleFonts.oxanium(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil()
              .setSp(kFontSize, ),
          color: kGreenColor,
        ));
if( Variables.currentUser[0]['pay'] == true){
  Navigator.pop(context);

}else{
  showAddError();
}



    }catch (e){
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }

  void _removeCard(int index, List<DocumentSnapshot> itemsData) {
    if(itemsData[index]['cv'] == Variables.currentUser[0]['ccv']){

      try{
        FirebaseFirestore.instance.collection
('stack').doc(itemsData[index]['id']).delete();
        setState(() {
          _documents.removeAt(index);

        });

        FirebaseFirestore.instance.collection
('userReg').doc(Variables.currentUser[0]['ud']).update({
          'pay':false,
        });
        setState(() {
          Variables.currentUser[0]['pay'] = false;
          _documents.removeAt(index);

        });
        Fluttertoast.showToast(
            msg: kCardDelete,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: kBlackColor,
            textColor: kGreenColor);

      }catch(e){

      }

    }else{
      try{
        FirebaseFirestore.instance.collection
('stack').doc(itemsData[index]['id']).delete();
        setState(() {
          _documents.removeAt(index);

        });
        Fluttertoast.showToast(
            msg: kCardDelete,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: kBlackColor,
            textColor: kGreenColor);

      }catch(e){

      }}
  }

  void resetCurrentCard(int index) {
    FirebaseFirestore.instance.collection('userReg').doc(Variables.currentUser[0]['ud']).set({
      'ccn': itemsData[index]['cc'],
      'ccv':itemsData[index]['cv'],
      'cyr': itemsData[index]['yr'],
      'cmt': itemsData[index]['mt'],
      'aut':  itemsData[index]['aut'],


    },SetOptions(merge: true));

    setState(() {
      Variables.currentUser[0]['ccn'] = itemsData[index]['cc'];
      Variables.currentUser[0]['ccv'] = itemsData[index]['cv'];
      Variables.currentUser[0]['cyr'] = itemsData[index]['cyr'];
      Variables.currentUser[0]['cmt'] = itemsData[index]['mt'];
      Variables.currentUser[0]['aut'] = itemsData[index]['aut'];

    });

  }



  Future<void> getUsersCard() async {
    itemsData.clear();
    _documents.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance
.collection('stack')
        .where('ud', isEqualTo: Variables.currentUser[0]['ud'])
        //.where('su',isEqualTo: true)
        .orderBy('dt',descending: true)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {

    } else {

      for (DocumentSnapshot document in documents) {
        setState(() {
          itemsData.add(document.data());
          _documents.add(document);
        });
      }
    }
}

  YYDialog showAddError() {
      return YYDialog().build(context)
        ..width = 220
        ..borderRadius = 4
        ..gravityAnimationEnable = true
        ..gravity = Gravity.right
        ..duration = Duration(milliseconds: 600)



        ..text(
          padding: EdgeInsets.all(18),
          text: 'Add Card'.toUpperCase(),
          color: kLightBrown,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          alignment: Alignment.center,

        )
        ..text(
          padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
          text: 'Hello ${Variables.userFN!}, please tap on Add New Card to add your card. Thanks',
          color: kTextColor,
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          alignment: Alignment.center,
        )
        ..doubleButton(
          onTap1: (){},
          padding: EdgeInsets.only(right: 10.0),
          gravity: Gravity.right,
          text1: "OK, Got it",
          color1: kDoneColor,
          fontSize1: 18.0,
          fontWeight1: FontWeight.bold,

        )
        ..show();
    }
  }




