import 'package:flutter/material.dart';
import 'package:gesting/database/models/ingreso_gasto_categ.dart';
import 'package:gesting/reporte_categoria/customindicator.dart';
import 'package:gesting/util/converter.dart';
import 'package:fl_chart/fl_chart.dart';

class MyCatePieChart extends StatefulWidget {
  final List<IngGastCategory> ingresos;
  final double ingresoTotal;
  MyCatePieChart(this.ingresos, this.ingresoTotal, {Key key}) : super(key: key);

  @override
  _MyCatePieChartState createState() => _MyCatePieChartState();
}

class _MyCatePieChartState extends State<MyCatePieChart> {
  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return myPie();
  }

  Widget myPie() {
    List<IngGastCategory> ingresos = widget.ingresos;
    Size s = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;
    return Material(
      color: (!darkModeOn) ? Colors.white : Theme.of(context).cardColor,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      shadowColor: (!darkModeOn) ? Color(0x802196F3) : Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        child: Row(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: <Widget>[
                      PieChart(
                        PieChartData(
                            pieTouchData:
                                PieTouchData(touchCallback: (pieTouchResponse) {
                              setState(() {
                                if (pieTouchResponse.touchInput
                                        is FlLongPressEnd ||
                                    pieTouchResponse.touchInput is FlPanEnd) {
                                  touchedIndex = -1;
                                } else {
                                  touchedIndex =
                                      pieTouchResponse.touchedSectionIndex;
                                }
                              });
                            }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 1,
                            centerSpaceRadius: s.height > 600
                                ? s.height / 17
                                : s.height / 10 - 35,
                            sections: showingSections()),
                      ),
                      Center(
                          child: Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 0, right: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              formatearMoneda(widget.ingresoTotal),
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              prefs.monedaPrincipal,
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ))
                    ],
                  )),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Center(
                  child: ListView.builder(
                    itemCount: ingresos.length,
                    itemBuilder: (BuildContext buildContext, index) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomIndicator(
                                  fontSize: 12.5,
                                  color: ingresos[index]
                                      .color ,
                                      sub: Text(
                                (ingresos[index].cant /
                                            widget.ingresoTotal *
                                            100)
                                        .toStringAsFixed(1) +
                                    '%',
                                style: TextStyle(fontSize: 13.5),
                              ),
                                  text:    ingresos[index].title[0].toUpperCase() +ingresos[index].title.substring(1),
                                  isSquare: false,
                                  textColor: (darkModeOn)
                                      ? Theme.of(context).textTheme.title.color
                                      : Color(0xFF505050),
                                ),
                              ),
                             
                            ]),
                      );
                    },
                    shrinkWrap: true,
                  ),
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
    List<IngGastCategory> ingresos = widget.ingresos;
    double val = 1;
    String title = '';

    if (ingresos.length != 0) {
      return List.generate(ingresos.length, (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? 16 : 13;
        final double radius = isTouched ? 30 : 25;

        return PieChartSectionData(
          color: ingresos[i].color,
          value: ingresos[i].cant,
          title: title,
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
      });
    } else {
      return List.generate(1, (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? 16 : 13;
        final double radius = isTouched ? 30 : 25;

        return PieChartSectionData(
          color: const Color(0xFF7B7B7E),
          value: val,
          title: title,
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );
      });
    }
  }
}
