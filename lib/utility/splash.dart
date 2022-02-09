
import 'package:easy_homes/utility/logo_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Splash extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}



class VideoState extends State<Splash> with SingleTickerProviderStateMixin{

  var _visible = true;

   AnimationController? animationController;
   Animation<double>? animation;

  /*startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }*/

  /*void navigationPage() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RipplesAnimation()));
  }
*/
  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
      vsync:this,
        value: 0.1,

        duration: new Duration(seconds: 4));
    animation =
    new CurvedAnimation(parent: animationController!, curve: Curves.easeOut);

    animation!.addListener(() => this.setState(() {}));
    animationController!.forward();

    setState(() {
      _visible = !_visible;
    });
    //startTime();
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController!.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Padding(padding: EdgeInsets.only(bottom: 30.0),child:LogoDesign(),)

            ],),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               SvgPicture.asset('assets/imagesFolder/splash.svg',
                width: animation!.value * 250,
                height: animation!.value * 250,
              ),
            ],
          ),
        ],
      );

  }
}