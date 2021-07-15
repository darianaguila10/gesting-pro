import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _DrawerCliper(),
      child: Drawer(
          child: Column(
        children: <Widget>[Text("sd")],
      )),
    );
  }
}

class _DrawerCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
   path.moveTo(50, 0);
   
    path.quadraticBezierTo(0, size.height / 2, 50, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
