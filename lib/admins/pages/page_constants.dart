import 'package:flutter/material.dart';

class PageConstants{
  static  List<dynamic> vendorCount = <dynamic>[];
  static  List<dynamic> getVendor = <dynamic>[];
  static  List<dynamic> getVendorCount = <dynamic>[];
  static  List<dynamic> getCompanies = <dynamic>[];
  static  List<dynamic> getUpcoming = <dynamic>[];
  static  List<dynamic> getComUpcoming = <dynamic>[];

  //list for all company online offline vendors

  //list of comment for a vendor
  static  List<dynamic> comments = <dynamic>[];

  /*list for blocked users*/
  static  List<dynamic> blockedUsers = <dynamic>[];
/*list of all sectaries*/
  static  List<dynamic> sectaries = <dynamic>[];

  //for searching in admin
  static TextEditingController searchController = TextEditingController();

  /*for the online offline count*/
  static  List<dynamic> getLoginCount = <dynamic>[];
  static  List<dynamic> getLogOutCount = <dynamic>[];
  static  List<dynamic> getWorkingCount = <dynamic>[];


   static int vendorNumber = 0;
  static int? partnerVendorNumber;

  /*getting the count of vendors*/
  static  List<dynamic> allVendorCount = <dynamic>[];

  //ud of the company selected
static String? companyUD;
  //name of the company
static String? companyName = '';


//company vendor filtered
  static  List<dynamic> filteredCompanyVendors = <dynamic>[];
  static  List<dynamic> allItems = <dynamic>[];
static int? companyVendorCount;

//get the vendor vid for vendor logs
static String?  vendorID;
static String? vv;

//get the vendor name
  static String? venName;


//getting the working count of every vendor

  static  List<dynamic> getWorkingForAllVendor = <dynamic>[];



  static bool onlineColor = false;

}