import 'package:flutter/material.dart';
import 'package:gesting/preferencia/preferencia_moneda.dart';
import 'package:gesting/util/converter.dart';


class MyTextItems extends StatefulWidget {
  final String title;
  final double subtitle;
  final Color color;
  final String path;
  MyTextItems(this.title, this.subtitle, this.color, this.path);

  @override
  _MyTextItemsState createState() => _MyTextItemsState();
}

class _MyTextItemsState extends State<MyTextItems> {
  final prefs = PreferenciaMoneda();

  bool darkModeOn;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
     darkModeOn = theme.brightness == Brightness.dark;

    Size s = MediaQuery.of(context).size;
    return myTextItems(this.widget.title, this.widget.subtitle,
        this.widget.color, this.widget.path, s);
  }

  Widget myTextItems(
      String title, double subtitle, Color color, String path, Size s) {
    return Material(
      color: (!darkModeOn) ? Colors.white : Theme.of(context).cardColor,
      elevation: 10.0,
      borderRadius: BorderRadius.circular(20.0),
      shadowColor: (!darkModeOn) ? Color(0x802196F3): Colors.black,
      child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18))),
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: color, width: 4))),
              padding: EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: s.height > 600 ? 19.0 : 16,
                        color: color,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      formatearMoneda(subtitle) + " " + prefs.monedaPrincipal,
                      style: TextStyle(
                        fontSize: s.height > 600 ? 17.0 : 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              if (path.length > 0) {
                setState(() {
                  Navigator.of(context).pushNamed("/" + path);
                });
              }
            },
            borderRadius: BorderRadius.circular(20),
          )),
    );
  }
}
