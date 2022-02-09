import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sticky_headers/sticky_headers.dart';
class ShowCommentModalSheet extends StatefulWidget {
  ShowCommentModalSheet({required this.id, required this.vendorsData});
  final String id;
  final dynamic vendorsData;
  @override
  _ShowCommentModalSheetState createState() => _ShowCommentModalSheetState();
}

class _ShowCommentModalSheetState extends State<ShowCommentModalSheet> {

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  String? filter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }
   var _documents = <DocumentSnapshot>[];

  var itemsData = <dynamic>[];

  var vendorData = <dynamic>[];
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  Widget bodyList(int index){
    return  Column(

      children: <Widget>[
        space(),

      Card(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(

                children: <Widget>[
                  VendorPix(pix: itemsData[index]['pix'],pixColor: Colors.transparent,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextWidgetAlign(
                name: '${itemsData[index]['fn']} ${itemsData[index]['ln']}',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
              TextWidgetAlign(
                name: '${itemsData[index]['dt']}',
                textColor: kDarkRedColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),

            ],
          )
                ],
              ),
                   space(),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ScreenUtil()
                        .setWidth(250),
                    minHeight: ScreenUtil()
                        .setHeight(20),
                  ),
                  child: ReadMoreText(itemsData[index]['tt'],
                    //doc.data['desc'],
                    trimLines: 4,
                    colorClickableText: kLightBrown,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' ...',
                    trimExpandedText: '  less',
                    style: GoogleFonts.oxanium(
                      fontSize: ScreenUtil().setSp(kFontSize14, ),
                      color: kBlackColor,

                    ),
                  ),
                ),
              ),
                 space(),
            ],
          ),
        ),
      ),


        space(),



      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: Container(
        height: MediaQuery.of(context).size.height * kModalHeight,

      child: itemsData.length == 0 && progress == false
          ? Center(child: PlatformCircularProgressIndicator())
          : itemsData.length == 0 && progress == true
          ? ErrorTitle(errorTitle: kNoComment.toString(),):
    SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StickyHeader(
          header:  CommentHeader(title: '${widget.vendorsData['fn']} Comments',length: _documents.length,),

          content: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _documents.length,
                itemBuilder: (context, int index) {


                  return filter == null || filter == "" ?bodyList(index):
                  '${itemsData[index]['dt']}'.toLowerCase()
                      .contains(filter!.toLowerCase())

                      ?bodyList(index):Container();



                }),
          ),
          progress == true ||
              _loadMoreProgress == true ||
              _documents.length < Variables.limit
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


    ));
  }

  Future<void> getComments() async {
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collection("comments").where('vid',isEqualTo:widget.id)
        .orderBy('ts', descending: true)
        .limit(Variables.limit)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;
        setState(() {
          _documents.add(document);
          itemsData.add(document.data());
        });
      }
    }
  }

  Future<void> loadMore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collection("comments").where('vid',isEqualTo:widget.id)
        .orderBy('ts', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(Variables.limit)
        .get();
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
          _documents.add(document);
          itemsData.add(document.data());

          moreData = false;
        });
      }
    }
  }

}
