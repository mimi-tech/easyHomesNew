import 'package:easy_homes/dashboard/customer/customer_upcoming.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  SecondScreen(this.payload);

  final String payload;

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String? _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HomeScreenSecond(),
    );
  }
}


class CustomerUpcomingPayLoad extends StatefulWidget {
  CustomerUpcomingPayLoad(this.payload);
  final String payload;
  @override
  _CustomerUpcomingPayLoadState createState() => _CustomerUpcomingPayLoadState();
}

class _CustomerUpcomingPayLoadState extends State<CustomerUpcomingPayLoad> {
  String? _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomerUpcomingBookings(),
    );
  }
}

