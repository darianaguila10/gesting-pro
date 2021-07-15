import 'package:flutter/material.dart';
import 'package:gesting/util/converter.dart';

class MyPanelCard extends StatelessWidget {
  final double ingresosTotal;
  final double gastosTotal;
  bool darkModeOn;
  MyPanelCard(this.ingresosTotal, this.gastosTotal);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
     darkModeOn = theme.brightness == Brightness.dark;
    Size s = MediaQuery.of(context).size;
    return Container(
      child: Column(children: <Widget>[
        Container(
            width: double.infinity,
            height: s.height * 0.11,
            child: elementCard("Balance",
                formatearMoneda(ingresosTotal - gastosTotal), Colors.green, s,context)),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: s.width / 2.25,
                height: s.height * 0.11,
                child: elementCard("Ingresos", formatearMoneda(ingresosTotal),
                    Colors.blue, s,context)),
            Container(
                width: s.width / 2.25,
                height: s.height * 0.11,
                child: elementCard(
                    "Gastos", formatearMoneda(gastosTotal), Colors.red[400], s,context)),
          ],
        ),
      ]),
    );
  }

  elementCard(title, subtitle, color, Size s,BuildContext context ) {
    return Material(
      color: (!darkModeOn) ? Colors.white : Theme.of(context).cardColor,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      shadowColor: (!darkModeOn) ? Color(0x802196F3) : Colors.black,
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
                        fontSize: 16.0,
                        color: color,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      subtitle + " " + prefs.monedaPrincipal,
                      style: TextStyle(
                        fontSize: s.height > 600 ? 15.0 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
          )),
    );
  }
}
