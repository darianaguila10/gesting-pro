import 'package:flutter/material.dart';

import 'package:gesting/widget/indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class MyPieChart extends StatefulWidget {
  final double ingresosTotal;
  final double gastosTotal;
  MyPieChart(this.ingresosTotal, this.gastosTotal, {Key key}) : super(key: key);

  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return myPie();
  }

  Widget myPie() {
    Size s = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;
    return Material(
      color: (!darkModeOn) ? Colors.white : Theme.of(context).cardColor,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      shadowColor: (!darkModeOn) ? Color(0x802196F3) : Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                    color: Color(0xff0293ee),
                    text: 'Ingreso',
                    isSquare: false,
                     textColor: (darkModeOn)
                      ? Theme.of(context).textTheme.title.color
                      : Color(0xFF505050),),
                SizedBox(
                  width: 15,
                ),
                Indicator(
                  color: Color(0xFFC75959),
                  text: 'Gasto',
                  isSquare: false,
                  textColor: (darkModeOn)
                      ? Theme.of(context).textTheme.title.color
                      : Color(0xFF505050),
                )
              ],
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 1,
                      centerSpaceRadius: s.height > 600
                          ? s.height / 10 - 25
                          : s.height / 10 - 35,
                      sections: showingSections()),
                ),
              ),
            ),
            SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double total = this.widget.ingresosTotal + this.widget.gastosTotal;
    double ingreso = this.widget.ingresosTotal;
    double gasto = this.widget.gastosTotal;
    String title;
    String title1;

    if (total != 0.0) {
      if (gasto == 0.0) {
        title1 = '';
        title = (ingreso / total * 100).toStringAsFixed(0) + '%';
      } else if (ingreso == 0.0) {
        title = '';
        title1 = (gasto / total * 100).toStringAsFixed(0) + '%';
      } else {
        int ingEntero = (ingreso / total * 100).truncate();
        if (ingEntero == 0) ingEntero = 1;
        title = ingEntero.toString() + '%';
        title1 = (100 - ingEntero).toString() + '%';
      }
    } else {
      title = '0%';
      title1 = '0%';
      ingreso = 1;
      gasto = 1;
    }

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 30 : 16;
      final double radius = isTouched ? 70 : 60;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xFFC75959),
            value: gasto,
            title: title1,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: ingreso,
            title: title,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          return null;
      }
    });
  }
}
