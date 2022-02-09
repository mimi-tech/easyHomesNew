import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/utility/text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
class AnimationSlide extends StatefulWidget {
  AnimationSlide({required this.title});
  final Widget title;
  @override
  _AnimationSlideState createState() => _AnimationSlideState();
}

class _AnimationSlideState extends State<AnimationSlide>with TickerProviderStateMixin {

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
    return  Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: SlideTransition(
        position: _offsetFloat,
        child: widget.title
      ),
    );
  }
}



class FadeAnimation extends StatefulWidget {
  FadeAnimation({required this.title});
  final Widget title;
  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: const Duration(seconds: 20), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animation,
    child: widget.title
    );

  }
}
