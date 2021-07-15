import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gesting/database/models/DataLine.dart';
import 'package:gesting/util/converter.dart';
import 'package:intl/intl.dart';
import 'package:gesting/provider/balance_provider.dart';

class MyLineChart extends StatefulWidget {
  final List<DataLine> listI;
  final List<DataLine> listG;

  MyLineChart(this.listI, this.listG, {Key key}) : super(key: key);

  @override
  _MyLineChartState createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  final balanceProvider = new BalanceProvider();
  int year;
  List<charts.TickSpec<DateTime>> staticTicks;
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    var measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.sales;
      });

      double ingresoselect =
          (measures['Ingreso'] != null) ? measures['Ingreso'] : 0;
      double gastoselect = (measures['Gasto'] != null) ? measures['Gasto'] : 0;

      balanceProvider.balanceTotalSink([ingresoselect, gastoselect]);
    }
  }

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = "es";
    year = balanceProvider.year;
    staticTicks = <charts.TickSpec<DateTime>>[
      charts.TickSpec<DateTime>(DateTime(year, 1, 5)),
      charts.TickSpec<DateTime>(DateTime(year, 2, 1)),
      charts.TickSpec<DateTime>(DateTime(year, 3, 1)),
      charts.TickSpec<DateTime>(DateTime(year, 4, 1)),
      charts.TickSpec<DateTime>(DateTime(year, 5, 1)),
      charts.TickSpec<DateTime>(DateTime(year, 6, 1)),
      charts.TickSpec<DateTime>(DateTime(year, 7, 1)),
      charts.TickSpec<DateTime>(DateTime(year, 8, 1)),
      charts.TickSpec<DateTime>(DateTime(year, 9, 1)),
      charts.TickSpec<DateTime>(DateTime(year, 10, 1)),
      charts.TickSpec<DateTime>(DateTime(year, 11, 1)),
      charts.TickSpec<DateTime>(DateTime(year, 12, 1)),
      
    ];
   
   
  }

  @override
  Widget build(BuildContext context) {
    Size s=MediaQuery.of(context).size;
    return myLineChart(this.widget.listI, this.widget.listG,s);
  }

  Material myLineChart(List<DataLine> listI, List<DataLine> listG,Size s) {
   final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;
    final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec(
        (num value) => formatearMoneda(value));

    final seiriesList = _createSampleData(year, listI, listG);
    return Material(
        color:(!darkModeOn) ? Colors.white : Theme.of(context).cardColor,
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20.0),
        shadowColor:(!darkModeOn) ? Color(0x802196F3) : Colors.black,
        child: Stack(
          children: <Widget>[
             Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 15),
                child: charts.TimeSeriesChart(
                  seiriesList,
                  domainAxis: charts.DateTimeAxisSpec(
                    tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
                      staticTicks,
                    ),
                    renderSpec: new charts.SmallTickRendererSpec(

                        // Tick and Label styling here.
                        labelStyle: new charts.TextStyleSpec(
                            fontSize: 11, // size in Pts.
                            color: darkModeOn
                                ? charts.MaterialPalette.white
                                : charts.MaterialPalette.black)),
                    tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                      day: charts.TimeFormatterSpec(
                        format: 'M',
                        transitionFormat: s.height > 600 ? 'MMM' : 'M',
                      ),
                    ),
                  ),
                  primaryMeasureAxis: new charts.NumericAxisSpec(
                      tickFormatterSpec: simpleCurrencyFormatter,
                      renderSpec: new charts.GridlineRendererSpec(
                        // Tick and Label styling here.
                        labelStyle: new charts.TextStyleSpec(
                            fontSize: 11, // size in Pts.
                            color: darkModeOn
                                ? charts.MaterialPalette.white
                                : charts.MaterialPalette.black),
                      )),
                  animate: false,
                  behaviors: [
                    charts.DomainHighlighter(),
                    charts.SlidingViewport(),
                    charts.PanAndZoomBehavior(),
                    charts.SeriesLegend(
                      showMeasures: false,
                      position: charts.BehaviorPosition.top,
                      /*   cellPadding:
                                EdgeInsets.symmetric(horizontal: 15.0, vertical: 10), */
                      outsideJustification:
                          charts.OutsideJustification.middleDrawArea,
                    ),
                    new charts.ChartTitle(balanceProvider.year.toString(),
                        behaviorPosition: charts.BehaviorPosition.bottom,
                        titleStyleSpec: new charts.TextStyleSpec(
                            color: darkModeOn
                                ? charts.MaterialPalette.white
                                : charts.MaterialPalette.black),
                        titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
                  ],
                  selectionModels: [
                    new charts.SelectionModelConfig(
                      type: charts.SelectionModelType.info,
                      changedListener: _onSelectionChanged,
                    )
                  ],
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                  defaultRenderer: charts.LineRendererConfig(
                    includeArea: true,
                    stacked: false,
                    includePoints: true,
                  ),
                )), 
             /*  Positioned(
                child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      balanceProvider.selectYear(-1);
                    }),
                top: 8,
                right: 60),
            Positioned(
                child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {
                      balanceProvider.selectYear(1);
                    }),
                top: 8,
                right: 10)  */
          ],
        ));
  }

  List<charts.Series<DataLine, DateTime>> _createSampleData(
      int year, List<DataLine> listI, List<DataLine> listG) {
    return [
      charts.Series<DataLine, DateTime>(
          id: 'Ingreso',
          domainFn: (DataLine sales, _) => sales.time,
          measureFn: (DataLine sales, _) => sales.sales,
          data: listI,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault),
      charts.Series<DataLine, DateTime>(
          id: 'Gasto',
          domainFn: (DataLine sales, _) => sales.time,
          measureFn: (DataLine sales, _) => sales.sales,
          data: listG,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault),
    ];
  }
}
