import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/utility/circle_painter.dart';
import 'package:easy_homes/utility/curve_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation({Key? key, this.size = 80.0, this.color = kSeaGreen,
    this.onPressed,  this.child,}) : super(key: key);
  final double size;
  final Color color;
  final Widget? child;
  final VoidCallback? onPressed;
  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync:this,
      value: 0.1,
      duration: const Duration(milliseconds: 500),

    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(

              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .05) as Color
              ],
            ),
          ),
          child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const CurveWave(),
                ),
              ),
              child: SvgPicture.asset('assets/imagesFolder/pick_up.svg'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PlatformScaffold(

        body: WillPopScope(
          onWillPop: () => Future.value(false),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

            Container(
                alignment: Alignment.center,
                child: Icon(Icons.speaker_phone, size: 44,color: kLightBrown,)),

              Center(
                child: CustomPaint(
                  painter: CirclePainter(
                    _controller,
                    color: widget.color,
                  ),
                  child: SizedBox(
                    width: widget.size * 4.125,
                    height: widget.size * 4.125,
                    child: _button(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
