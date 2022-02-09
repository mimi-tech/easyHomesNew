import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class OrderVieDetails extends StatefulWidget {
  OrderVieDetails({required this.docs});

  final DocumentSnapshot docs;

  @override
  _OrderVieDetailsState createState() => _OrderVieDetailsState();
}

class _OrderVieDetailsState extends State<OrderVieDetails> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  int? kgTotal;
  int? cylinderTotal;
  late List<dynamic> loadKg;
  late List<dynamic> loadKg2;
  List<Widget> getImages(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < loadKg.length; i++){
      Widget w = Column(
        children: [
          SizedBox(width: 100,),
          TextWidgetAlign(
            name: '${loadKg[i].toString()}Kg',
            textColor: kDoneColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,
          ),

          widget.docs['cQ'].length == 0 ?Visibility(visible:false,child: Text('')): TextWidgetAlign(
            name: '${widget.docs['cQ'][i].toString()}',
            textColor: kTextColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,
          ),
        ],

      );
      list.add(w);
    }
    return list;
  }

  List<Widget> getSecondKG(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < loadKg2.length; i++){
      Widget w = Column(
        children: [
          SizedBox(width: 100,),
          TextWidgetAlign(
            name: '${loadKg2[i].toString()}Kg',
            textColor: kDoneColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,
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
    getDetails();

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: StickyHeader(
    header:  Stack(
      alignment: Alignment.center,
      children: [
        AdminHeader(title: 'Order Details'.toUpperCase(),),

        Align(
            alignment: Alignment.topRight,

            child: IconButton(icon: Icon(Icons.cancel), onPressed: (){Navigator.pop(context);}))
      ],
    ),


    content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               /* spacer(),
                TextWidgetAlign(
                  name:'Order details'.toUpperCase(),
                  textColor: kLightBrown,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                ),
                spacer(),*/

                Column(
                  children: [
                    AnimationSlide(title: TextWidgetAlign(
                      name:widget.docs['by'] == true?'No of cylinder(s) you are buying': kCylinderQtyText,
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),),
                    spacer(),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.065,
                        decoration: BoxDecoration(
                          border: Border.all(color: kRadioColor,),

                        ),

                        child:  Center(
                          child: TextWidgetAlign(
                            name: cylinderTotal.toString(),
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,
                          ),
                        ),

                      ),
                    )
                  ],
                ),
                Divider(),
                Center(
                  child:  AnimationSlide(title:
                  widget.docs['re'] == true?TextWidgetAlign(
                    name:   'Rented cylinder sizes & quantity',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ):


                  TextWidgetAlign(
                    name:   loadKg2.length == 0 ?'Selected  cylinder size(s)':'Selected new cylinder sizes & quantity',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                  ),
                ),
                spacer(),

                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: getImages(),

                ),
                Center(
                  child:  AnimationSlide(title:
                  TextWidgetAlign(
                    name:   loadKg2.length == 0 ?'':'Selected own cylinder size(s)',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                  ),
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: getSecondKG(),

                ),
                Divider(),
                //spacer(),
                widget.docs['by'] == true?Text(''): Column(
                  children: [
                    AnimationSlide(title:
                    TextWidgetAlign(
                      name: 'Total gas kg ( LPG )',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                    ),
                    spacer(),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.065,
                        decoration: BoxDecoration(
                          border: Border.all(color: kRadioColor,),

                        ),



                        child:  Center(
                          child: TextWidgetAlign(
                            name: Variables.transit!['gk'].toString(),
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    spacer(),
                  ],
                ),

                widget.docs['by'] == true?Text(''): Column(
                  children: [
                    AnimationSlide(title:
                    TextWidgetAlign(
                      name: 'Tare Weight (initial cylinder weight)',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                    ),
                    spacer(),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.065,
                        decoration: BoxDecoration(
                          border: Border.all(color: kRadioColor,),

                        ),



                        child:  Center(
                          child: TextWidgetAlign(
                            name:  Variables.transit!['trw'].toString(),
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    spacer(),
                  ],
                ),

                widget.docs['by'] == true?Text(''): Column(
                  children: [
                    AnimationSlide(title:
                    TextWidgetAlign(
                      name: 'Expected total kg after refilling',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                    ),
                    spacer(),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.065,
                        decoration: BoxDecoration(
                          border: Border.all(color: kRadioColor,),

                        ),



                        child:  Center(
                          child: TextWidgetAlign(
                            name:  Variables.transit!['ew'].toString(),
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    spacer(),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    ));
  }
  Future<void> getDetails() async {
    setState(() {
      cylinderTotal =  widget.docs['ca'];
      loadKg = widget.docs['cKG'];
      loadKg2 = widget.docs['cKG2'];
      kgTotal = loadKg.length + loadKg2.length;
    });


    final QuerySnapshot result = await FirebaseFirestore.instance
.collection('customer')
        .where('vid', isEqualTo: Variables.currentUser[0]['ud'])
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {

    } else {

     for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {Variables.transit = document;


        });
      }
    }
  }

  }



