import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class NewCylinderCount extends StatefulWidget {
  NewCylinderCount({ required this.title});

  final String title;
  @override
  _NewCylinderCountState createState() => _NewCylinderCountState();
}

class _NewCylinderCountState extends State<NewCylinderCount> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.04);
  }
  TextEditingController _quantity = TextEditingController();
int count = 1;
int checkCount = 1;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quantity.text = count.toString();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Column(
          children: [
            spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: TextWidgetAlign(
                name: widget.title,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ),
            Divider(),
            spacer(),
            Container(
              /*width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: kLightBrown)
              ),*/
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        if( count > 1){
                          count--;
                          _quantity.text = count.toString();
                        }

                      });
                    },
                    backgroundColor: kWhiteColor,
                    elevation: 5,
                    child:  Icon(Icons.remove,color: kBlackColor,),

                    ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: kRadioColor),
                        color: kLightBrown
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: TextField(
                          controller: _quantity,
                          autocorrect: true,
                            textAlign: TextAlign.center,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.emailAddress,
                            key: ValueKey<int>(count),
                          cursorColor: (kTextFieldBorderColor),
                          style: Fonts.countSize,
                         decoration: InputDecoration(
                             enabledBorder: OutlineInputBorder(
                                 borderSide: BorderSide(color:Colors.transparent),
                                 borderRadius: BorderRadius.circular(kBorder)),
                             focusedBorder: OutlineInputBorder(
                                 borderSide: BorderSide(
                                     color: Colors.transparent))

                         ),
                         onChanged: (String value) {
                           count = int.parse(value);
                         }
                        )
                      ),
                    ),
                  ),

                  FloatingActionButton(
                    onPressed: () {
                      setState(() {

                          count += 1;
                          _quantity.text = count.toString();
                        }
                      );
                    },
                    backgroundColor: kWhiteColor,
                    elevation: 5,
                    child:  Icon(Icons.add,color: kBlackColor,),

                  ),






                ],
              ),
            ),
            spacer(),
            SizedBtn(nextFunction: (){_addQuantity();}, bgColor: kDoneColor, title: 'Done'),
            spacer()
          ],
        ),
      ),
    );
  }

  void _addQuantity() {
  setState(() {
    int total = int.parse(_quantity.text) * Variables.cP;
    //this add the quantity for each cylinder
    Variables.headQuantityText.add(_quantity.text);

    Variables.checkCountShow = Variables.checkCount  + int.parse(_quantity.text);
    Variables.selectedAmount.add(total);
    List<double> lint = Variables.kGItems.map(double.parse).toList();
//adding the quantity for each added cylinder
   dynamic cc = lint.last * int.parse(_quantity.text);
    Variables.cytCounting.add(cc);


    Navigator.pop(context);
  });
}
}

