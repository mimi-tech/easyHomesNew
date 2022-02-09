import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';

class CheckText extends StatefulWidget {
  CheckText({required this.title});
  final String title;


  @override
  _CheckTextState createState() => _CheckTextState();
}

class _CheckTextState extends State<CheckText> with TickerProviderStateMixin{
  late  AnimationController _controller;
  late  Animation<Offset> _offsetFloat;


  @override
  void initState() {
    super.initState();

    //ToDo:second animation
    _controller = AnimationController(
      vsync:this,
      value: 0.1,
      duration: const Duration(milliseconds: 500),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener((){
      setState((){});
    });
    _controller.forward();



  }
  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetFloat,
      child: TextWidget(
        name: widget.title,
        textColor: kTextColor,
        textSize: kFontSize,
        textWeight: FontWeight.w400,
      ),
    );

  }
}



class CheckTextTwo extends StatefulWidget {
  CheckTextTwo({required this.title});
  final String title;

  @override
  _CheckTextTwoState createState() => _CheckTextTwoState();
}

class _CheckTextTwoState extends State<CheckTextTwo>with TickerProviderStateMixin {
 late  AnimationController _controller;
  late  Animation<Offset> _offsetFloat;


  @override
  void initState() {
    super.initState();

    //ToDo:second animation
    _controller = AnimationController(
      vsync:this,
      value: 0.1,
      duration: const Duration(milliseconds: 700),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener((){
      setState((){});
    });
    _controller.forward();



  }
  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetFloat,
      child: TextWidget(
        name: widget.title,
        textColor: kTextColor,
        textSize: kFontSize,
        textWeight: FontWeight.w400,
      ),
    );

  }
}






class CheckTextThree extends StatefulWidget {
  CheckTextThree({required this.title});
  final String title;

  @override
  _CheckTextThreeState createState() => _CheckTextThreeState();
}

class _CheckTextThreeState extends State<CheckTextThree> with TickerProviderStateMixin {
 late AnimationController _controller;
  late Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();

    //ToDo:second animation
    _controller = AnimationController(
      vsync:this,
      value: 0.1,
      duration: const Duration(milliseconds: 900),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener((){
      setState((){});
    });
    _controller.forward();



  }
  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetFloat,
      child: TextWidget(
        name: widget.title,
        textColor: kTextColor,
        textSize: kFontSize,
        textWeight: FontWeight.w400,
      ),
    );
  }
}


class CheckTextFour extends StatefulWidget {
  CheckTextFour({required this.title});
  final String title;

  @override
  _CheckTextFourState createState() => _CheckTextFourState();
}

class _CheckTextFourState extends State<CheckTextFour> with TickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();

    //ToDo:second animation
    _controller = AnimationController(
      vsync:this,
      value: 0.1,
      duration: const Duration(milliseconds: 1000),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener((){
      setState((){});
    });
    _controller.forward();



  }
  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetFloat,
      child: TextWidget(
        name: widget.title,
        textColor: kTextColor,
        textSize: kFontSize,
        textWeight: FontWeight.w400,
      ),
    );
  }
}



class CheckTextFive extends StatefulWidget {
  CheckTextFive({required this.title});
  final String title;

  @override
  _CheckTextFiveState createState() => _CheckTextFiveState();
}

class _CheckTextFiveState extends State<CheckTextFive> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();

    //ToDo:second animation
    _controller = AnimationController(
      vsync:this,
      value: 0.1,
      duration: const Duration(seconds: 1),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener((){
      setState((){});
    });
    _controller.forward();



  }
  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetFloat,
      child: TextWidget(
        name: widget.title,
        textColor: kTextColor,
        textSize: kFontSize,
        textWeight: FontWeight.w400,
      ),
    );
  }
}


class CheckTextSix extends StatefulWidget {

  CheckTextSix({required this.title});
  final String title;
  @override
  _CheckTextSixState createState() => _CheckTextSixState();
}

class _CheckTextSixState extends State<CheckTextSix> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();

    //ToDo:second animation
    _controller = AnimationController(
      vsync:this,
      value: 0.1,
      duration: const Duration(seconds: 2),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener((){
      setState((){});
    });
    _controller.forward();



  }
  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetFloat,
      child: TextWidget(
        name: widget.title,
        textColor: kTextColor,
        textSize: kFontSize,
        textWeight: FontWeight.w400,
      ),
    );
  }
}
