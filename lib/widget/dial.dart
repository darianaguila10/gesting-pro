import 'package:flutter/material.dart';

class Dial extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DialState();
  }
}

class DialState extends State<Dial> with SingleTickerProviderStateMixin {
  bool igno;
  Color colorOp = Colors.green;
  Color colorCl = Color(0xFFE26868);
  Color color;

  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void initState() {
    color = colorOp;
    igno = true;
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              actualizar();
            });
            animationController.reverse();
          },
          child: IgnorePointer(
            ignoring: igno,
            child: Container(
              color: Colors
                  .transparent, 
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset.fromDirection(getRadiansFromDegree(265),
              degOneTranslationAnimation.value * 100),
          child: Transform(
            transform:
                Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                  ..scale(degOneTranslationAnimation.value),
            alignment: Alignment.center,
            child: CircularButton(
              color: Colors.blue,
              width: 50,
              height: 50,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onClick: () {
                animationController.reverse();
                setState(() {
                  actualizar();
                  Navigator.of(context).pushNamed("/ingresotab");
                });
              },
            ),
          ),
        ),
        Transform.translate(
          offset: Offset.fromDirection(getRadiansFromDegree(220),
              degTwoTranslationAnimation.value * 100),
          child: Transform(
            transform:
                Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                  ..scale(degTwoTranslationAnimation.value),
            alignment: Alignment.center,
            child: CircularButton(
              color: Colors.orange,
              width: 50,
              height: 50,
              icon: Icon(
                Icons.equalizer,
                color: Colors.white,
              ),
              onClick: () {
                actualizar();
                animationController.reverse();
                Navigator.of(context).pushNamed("/reportetab"); 
              },
            ),
          ),
        ),
        Transform.translate(
          offset: Offset.fromDirection(getRadiansFromDegree(175),
              degThreeTranslationAnimation.value * 100),
          child: Transform(
            transform:
                Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                  ..scale(degThreeTranslationAnimation.value),
            alignment: Alignment.center,
            child: CircularButton(
              color: Colors.red,
              width: 50,
              height: 50,
              icon: Icon(
                Icons.remove,
                color: Colors.white,
              ),
              onClick: () {
                actualizar();
                animationController.reverse();
                Navigator.of(context).pushNamed("/gastotab");
              },
            ),
          ),
        ),
        Transform(
            transform: Matrix4.rotationZ(
                getRadiansFromDegree(rotationAnimation.value)),
            alignment: Alignment.center,
            child: RawMaterialButton(splashColor: colorCl,
              padding: EdgeInsets.all(5.0),
              shape: CircleBorder(),
              onPressed: () {},
              elevation: 2.0,
              fillColor: color,
              child: IconButton(
                color: Colors.white,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: animationController,
                ),
                onPressed: () {
                  setState(() {
                    color == colorOp ? color = colorCl : color = colorOp;
                    igno = !igno;
                  });
                  if (animationController.isCompleted) {
                    animationController.reverse();
                  } else {
                    animationController.forward();
                  }
                },
              ),
            ))
      ],
    ));
  }

  void actualizar() {
    color = colorOp;
    igno = !igno;
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton(
      {this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(icon: icon, enableFeedback: true, onPressed: onClick),
    );
  }
}
