import 'dart:io';

import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/search.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/admin_change_station.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/all_business.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/all_users.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/all_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/awaiting_booking.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/blocked_users.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/comment.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/get_txn.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/rejected_confirmation.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/removed_vendor.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/rent.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/suspended_vendor.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/verify_biz_owner.dart';
import 'package:easy_homes/admins/pages/appbar_title.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/admins/transactions/paymentList.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class MainAdminAppBar extends StatefulWidget implements PreferredSizeWidget{
  MainAdminAppBar({required this. title});
  final String title;

  @override
  _MainAdminAppBarState createState() => _MainAdminAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _MainAdminAppBarState extends State<MainAdminAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          TextWidget(
            name: widget.title,
            // AdminConstants.bizName!.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          GestureDetector(
              onTap: () {
                Platform.isIOS
                    ? CupertinoActionSheet(
                  actions: <Widget>[SelectType()],
                )
                    : showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => SelectType());
              },
              child: SvgPicture.asset(
                'assets/imagesFolder/add_circle.svg',
              )),



        ],
      ),
    );
  }
}







class EasyAppBarSecond extends StatefulWidget implements PreferredSizeWidget {
  @override
  _EasyAppBarSecondState createState() => _EasyAppBarSecondState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _EasyAppBarSecondState extends State<EasyAppBarSecond> {
  @override
  Widget build(BuildContext context) {
    return  AppBar(
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
          AppBarTitle(),
          AdminConstants.category == AdminConstants.admin.toLowerCase()?Text(''): GestureDetector(
              onTap: () {
                Platform.isIOS
                    ? CupertinoActionSheet(
                  actions: <Widget>[SelectType()],
                )
                    : showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => SelectType());
              },
              child: SvgPicture.asset(
                'assets/imagesFolder/add_circle.svg',
              )),
        ],
      ),
    );
  }
}



class SearchMainAdminAppBar extends StatefulWidget implements PreferredSizeWidget{
  SearchMainAdminAppBar({required this. title});
  final String title;

  @override
  _SearchMainAdminAppBarState createState() => _SearchMainAdminAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _SearchMainAdminAppBarState extends State<SearchMainAdminAppBar> {

  Icon actionIcon =  Icon(Icons.search,color: kRadioColor,size: 25,);
  bool checkSearch = true;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: kWhiteColor,
      title:checkSearch ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(
            name: widget.title,
            // AdminConstants.bizName!.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          GestureDetector(
              onTap: () {
                Platform.isIOS
                    ? CupertinoActionSheet(
                  actions: <Widget>[SelectType()],
                )
                    : showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => SelectType());
              },
              child: SvgPicture.asset(
                'assets/imagesFolder/add_circle.svg',
              )),

          GestureDetector(
              onTap: (){
                setState(() {
                  checkSearch = false;
                });
              },
              child: SearchIcon())


        ],
      ):Container(

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child: TextFormField(
                  controller: PageConstants.searchController,
                  style: Fonts.textSize,
                  autocorrect: true,
                  autofocus: true,
                  cursorColor: kBlackColor,
                  keyboardType: TextInputType.text,
                  decoration: Variables.searchInput),
            ),

            GestureDetector(
                onTap: (){
                  setState(() {
                    checkSearch = true;
                  });
                },
                child: CancelIcon())
          ],
        ),
      ),
    );
  }
}










class SearchEasyAppBar extends StatefulWidget implements PreferredSizeWidget{

  @override
  _SearchEasyAppBarState createState() => _SearchEasyAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _SearchEasyAppBarState extends State<SearchEasyAppBar> {

  Icon actionIcon =  Icon(Icons.search,color: kRadioColor,size: 25,);
  bool checkSearch = true;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: kWhiteColor,
      title:checkSearch ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppBarTitle(),
          GestureDetector(
              onTap: () {
                Platform.isIOS
                    ? CupertinoActionSheet(
                  actions: <Widget>[SelectType()],
                )
                    : showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => SelectType());
              },
              child: SvgPicture.asset(
                'assets/imagesFolder/add_circle.svg',
              )),
          GestureDetector(
              onTap: (){
                setState(() {
                  checkSearch = false;
                });
              },
              child: SearchIcon())


        ],
      ):Container(

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child: TextFormField(
                  controller: PageConstants.searchController,
                  style: Fonts.textSize,
                  autocorrect: true,
                  autofocus: true,
                  cursorColor: kBlackColor,
                  keyboardType: TextInputType.text,
                  decoration: Variables.searchInput),
            ),

            GestureDetector(
                onTap: (){
                  setState(() {
                    checkSearch = true;
                  });
                },
                child: CancelIcon())
          ],
        ),
      ),
    );
  }
}





class SearchBottomAdminAppBar extends StatefulWidget implements PreferredSizeWidget{
  SearchBottomAdminAppBar({required this. title});
  final String title;

  @override
  _SearchBottomAdminAppBarState createState() => _SearchBottomAdminAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _SearchBottomAdminAppBarState extends State<SearchBottomAdminAppBar> {

  Icon actionIcon =  Icon(Icons.search,color: kRadioColor,size: 25,);
  bool checkSearch = true;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: kLightBrown,
      title:checkSearch ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(
            name: widget.title,
            // AdminConstants.bizName!.toUpperCase(),
            textColor: kWhiteColor,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,
          ),

          IconButton(icon: Icon(Icons.reply), onPressed: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: RejectedConfirmation()));

          }),

          IconButton(icon: Icon(Icons.change_history_sharp), onPressed: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ChangeStationDetails()));

          }),

          GestureDetector(
              onTap: (){
                setState(() {
                  checkSearch = false;
                });
              },
              child: SearchIcon())


        ],
      ):Container(

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child: TextFormField(
                  controller: PageConstants.searchController,
                  style: Fonts.textSize,
                  autocorrect: true,
                  autofocus: true,
                  cursorColor: kBlackColor,
                  keyboardType: TextInputType.text,
                  decoration: Variables.searchInput),
            ),

            GestureDetector(
                onTap: (){
                  setState(() {
                    checkSearch = true;
                  });
                },
                child: CancelIcon())
          ],
        ),
      ),
    );
  }
}



class CancelAppBar extends StatefulWidget implements PreferredSizeWidget{
  CancelAppBar({required this. title});
final String title;
  @override
  _CancelAppBarState createState() => _CancelAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _CancelAppBarState extends State<CancelAppBar> {
  Icon actionIcon =  Icon(Icons.search,color: kRadioColor,size: 25,);
  bool checkSearch = true;

  @override
  Widget build(BuildContext context) {
    return AppBar(

      leading: IconButton(
        icon: SvgPicture.asset('assets/imagesFolder/go_back.svg',color: kWhiteColor,),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: kLightBrown,
      title:checkSearch ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(
            name: widget.title,
            // AdminConstants.bizName!.toUpperCase(),
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),



          GestureDetector(
              onTap: (){
                setState(() {
                  checkSearch = false;
                });
              },
              child: SearchIcon())


        ],
      ):Container(

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child: TextFormField(
                  controller: PageConstants.searchController,
                  style: Fonts.textSize,
                  autocorrect: true,
                  autofocus: true,
                  cursorColor: kBlackColor,
                  keyboardType: TextInputType.text,
                  decoration: Variables.searchInput),
            ),

            GestureDetector(
                onTap: (){
                  setState(() {
                    checkSearch = true;
                  });
                },
                child: CancelIcon())
          ],
        ),
      ),
    );
  }
}










class RemovedAppBar extends StatefulWidget implements PreferredSizeWidget{
  RemovedAppBar({required this. title});
  final String title;
  @override
  _RemovedAppBarState createState() => _RemovedAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _RemovedAppBarState extends State<RemovedAppBar> {
  Icon actionIcon =  Icon(Icons.search,color: kRadioColor,size: 25,);
  bool checkSearch = true;

  @override
  Widget build(BuildContext context) {
    return AppBar(

      leading: IconButton(
        icon: SvgPicture.asset('assets/imagesFolder/go_back.svg',color: kBlackColor,),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: kWhiteColor,
      title:checkSearch ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(
            name: widget.title,
            // AdminConstants.bizName!.toUpperCase(),
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),

         IconButton(icon: Icon(
           Icons.remove_moderator,color: kBlackColor,size: 30,
         ), onPressed: null),

          GestureDetector(
              onTap: (){
                setState(() {
                  checkSearch = false;
                });
              },
              child: SearchIcon())


        ],
      ):Container(

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child: TextFormField(
                  controller: PageConstants.searchController,
                  style: Fonts.textSize,
                  autocorrect: true,
                  autofocus: true,
                  cursorColor: kBlackColor,
                  keyboardType: TextInputType.text,
                  decoration: Variables.searchInput),
            ),

            GestureDetector(
                onTap: (){
                  setState(() {
                    checkSearch = true;
                  });
                },
                child: CancelIcon())
          ],
        ),
      ),
    );
  }
}



class SilverAppBarCancel extends StatefulWidget implements PreferredSizeWidget{
  SilverAppBarCancel({
    required this.block,
    required this.editPin,
    required this.remove,
    required this.suspend,

  });
  final Color block;
  final Color editPin;
  final Color remove;
  final Color suspend;


  @override
  _SilverAppBarCancelState createState() => _SilverAppBarCancelState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _SilverAppBarCancelState extends State<SilverAppBarCancel> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
          )
      ),
      backgroundColor: kWhiteColor,
      pinned: false,
      automaticallyImplyLeading: false,
      forceElevated: true,
      floating: true,

      elevation: 5.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(

              child:  IconButton(icon: Icon(
                Icons.block,color: widget.block,
              ), onPressed: (){

                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: UnBlockUsers()));

              })
          ),

          AdminConstants.category == AdminConstants.owner!.toLowerCase()? GestureDetector(
              child:  IconButton(icon: Icon(
                Icons.create,color: widget.editPin,
              ), onPressed: (){
                Platform.isIOS ?
                /*show ios bottom modal sheet*/
                showCupertinoModalPopup(
                    context: context, builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    actions: <Widget>[
                      VerifyBusinessOwner()
                    ],
                  );
                })

                    : showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => VerifyBusinessOwner()
                );
              })
          ):Text(''),

          IconButton(icon: Icon(
            Icons.remove_circle,color: widget.remove,
          ), onPressed: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: EasyRemovedVendor()));

          }),

          IconButton(icon: Icon(
            Icons.receipt_long,color: widget.suspend,
          ), onPressed: (){

            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: EasySuspendedVendor()));

          })


        ],),
    );
  }
}





class SilverAppBarUsers extends StatefulWidget implements PreferredSizeWidget{
  SilverAppBarUsers({
    required this.block,
    required this.editPin,
    required this.remove,
    required this.suspend,

  });
  final Color block;
  final Color editPin;
  final Color remove;
  final Color suspend;


  @override
  _SilverAppBarUsersState createState() => _SilverAppBarUsersState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _SilverAppBarUsersState extends State<SilverAppBarUsers> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
          )
      ),
      backgroundColor: kWhiteColor,
      pinned: false,
      floating: true,
      automaticallyImplyLeading: false,
      forceElevated: true,
      elevation: 5.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: Icon(
            Icons.verified_user,color: widget.block,
          ), onPressed: (){

            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllUsers()));

          }),

          IconButton(icon: Icon(
            Icons.drive_eta_rounded,color: widget.remove,
          ), onPressed: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllVendors()));

          }),

          IconButton(icon: Icon(
            Icons.business,color: widget.suspend,
          ), onPressed: (){

            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllBusiness()));

          }),


          IconButton( icon: SvgPicture.asset('assets/imagesFolder/small_cy.svg',color: widget.editPin,),
          onPressed: (){

            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllRentUsers()));

          })


        ],),
    );
  }
}






class SilverAppBarComments extends StatefulWidget implements PreferredSizeWidget{
  SilverAppBarComments({
    required this.block,
    required this.editPin,
    required this.remove,
    required this.suspend,

  });
  final Color block;
  final Color editPin;
  final Color remove;
  final Color suspend;


  @override
  _SilverAppBarCommentsState createState() => _SilverAppBarCommentsState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _SilverAppBarCommentsState extends State<SilverAppBarComments> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
          )
      ),
      backgroundColor: kWhiteColor,
      pinned: false,
      floating: true,
      automaticallyImplyLeading: false,
      forceElevated: true,
      elevation: 5.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: Icon(
            Icons.comment,color: widget.block,
          ), onPressed: (){

            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: EasyComment()));

          }),
          IconButton(icon: Icon(
            Icons.book_online,color: widget.suspend,
          ), onPressed: (){

            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: EasyAwaitingBooking()));

          }),
          IconButton(icon: Icon(
            Icons.monetization_on,color: widget.remove,
          ), onPressed: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllPaymentTrans()));

          }),




          IconButton( icon:Icon(Icons.rate_review,color: widget.editPin,),
              onPressed: (){

                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: GetMyTxn()));

              })


        ],),
    );
  }
}