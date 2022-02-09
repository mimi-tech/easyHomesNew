import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class GasCompanyList extends StatefulWidget {
  @override
  _GasCompanyListState createState() => _GasCompanyListState();
}

class _GasCompanyListState extends State<GasCompanyList> {
  @override
  Widget build(BuildContext context) {

    return Drawer(

        child: Column(
          children: <Widget>[
            SizedBox(height: 30,),
            TextWidget(
              name: 'List of company',
              textColor: kBlackColor,
              textSize: kFontSize,
              textWeight: FontWeight.w600,
            ),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:  FirebaseFirestore.instance.collection
("AllBusiness").where('st',isEqualTo:  Variables.administrative)

            .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
            return
              Center(child: PlatformCircularProgressIndicator(),);
      } else {
            if (!snapshot.hasData) {
              return Center(child:TextWidget(
                name: 'Sorry no gas outlet is within your locality, we are still in the process',
                textColor: kBlackColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),);
            } else {
              final List<Map<String,dynamic>> documents = snapshot.data!.docs as List<Map<String, dynamic>>;

              return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (context, int index) {

                    return ListTile(
                      onTap: (){
                        selectedCompany(context, documents[index],index);

                      },

                      leading: Container(
                        decoration: BoxDecoration(
                          color: kLightBrown,

                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2.0,
                            color: kStatusColor,
                          ),

                        ),
                        height: 30,
                        width:  30,
                      ),

                      title: TextWidget(
                        name: documents[index]['name'],
                        textColor: kBlackColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w600,
                      ),


                    );
                  }

              );
            }
      }
    }
    ),
          ],
        )
    );

  }

  void selectedCompany(BuildContext context, Map<String, dynamic> document, int index) {

    setState(() {
      Variables.companySelected = document['name'];
      Variables.selectedCompanyDocId = document['ud'];

    });
    print('selected uid' +Variables.selectedCompanyDocId );

    Navigator.pop(context);
  }

}
