import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/read_more.dart';
import 'package:easy_homes/utils/shimmer_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:readmore/readmore.dart';

class BusinessOnline extends StatefulWidget {
  @override
  _BusinessOnlineState createState() => _BusinessOnlineState();
}

class _BusinessOnlineState extends State<BusinessOnline> {
  static  List<dynamic> itemsData = <dynamic>[];
  bool progress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStations();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: Container(
      height: MediaQuery.of(context).size.height * 0.5,

      child: itemsData.length == 0 && progress == false
          ? Center(child: PlatformCircularProgressIndicator())
          : itemsData.length == 0 && progress == true
          ? Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextWidgetAlign(
                name:'Hello ${Variables.userFN!}',
                textColor: kLightBrown,
                textSize: 20,
                textWeight: FontWeight.bold,
              ),

              Image.asset(
                "assets/imagesFolder/stop.gif",
                height: 125.0,
                width: 125.0,
              ),



              Center(
        child: ShimmerBgSecond(title: 'Sorry you have no gas station',)
      ),
              SizedBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kDoneColor, title: 'Close')

            ],
          ):Column(
      children: [
        AnimationSlide(title: TextWidgetAlign(
          name:'Your gas stations and address',
          textColor: kTextColor,
          textSize: kFontSize,
          textWeight: FontWeight.w500,
        ),),



      ListView.builder(
      shrinkWrap: true,
      itemCount: itemsData.length,
      itemBuilder: (context, int index) {
        return  Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidgetAlign(
                name:itemsData[index]['biz'],
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
              ReadMoreTextConstruct(title: itemsData[index]['add'],colorText: kLightBrown,),
              Spacer(),
              itemsData[index]['ol'] == true?IconButton(icon: Icon(
                Icons.radio_button_unchecked,
              ), onPressed: (){}):

              IconButton(icon: Icon(
                Icons.radio_button_checked,color: kGreenColor,
              ), onPressed: (){})
            ],
          ),
        );
      })

      ],
      ),
    )
        )
    );
  }

  Future<void> getStations() async {

    try{
      final QuerySnapshot result = await FirebaseFirestore.instance

          .collection("AllBusiness")
          .where('ud',isEqualTo: Variables.userUid)
          .get();
      final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {

    setState(() {
      progress = true;
    });
      } else {

        for (DocumentSnapshot document in documents) {

          itemsData.add(document.data());

          setState(() {

          });
          /*

          Variables.cylinderCount = document.data()[
'ca'];

          Variables.grandTotal = Variables.totalGasKG *Variables.cloud!['gas'];*/

        }
      }
    }catch (e){
    }
  }
}
