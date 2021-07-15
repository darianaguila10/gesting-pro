// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:gesting/database/models/DataBar.dart';
import 'package:gesting/provider/balance_provider.dart';
import 'package:gesting/util/converter.dart';

class MyBarChart extends StatefulWidget {
  final List<DataBar> listI;
  final List<DataBar> listG;

  MyBarChart(this.listI, this.listG, {Key key}) : super(key: key);

  @override
  _MyBarChartState createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  final balanceProvider = new BalanceProvider();
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var measures = <String, num>{};

    if (selectedDatum.isNotEmpty) {
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
  Widget build(BuildContext context) {
    return myBar(this.widget.listI, this.widget.listG);
  }

  Widget myBar(List<DataBar> listI, List<DataBar> listG) {
      final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;
    final simpleCurrencyFormatter = charts.BasicNumericTickFormatterSpec(
        (num value) => formatearMoneda(value));
  
    return Material(
  color:(!darkModeOn) ? Colors.white : Theme.of(context).cardColor,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
  shadowColor:(!darkModeOn) ? Color(0x802196F3) : Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: charts.BarChart(
          _createSampleData(listI, listG,darkModeOn),
          animate: false,
          domainAxis: new charts.OrdinalAxisSpec(
              renderSpec: new charts.SmallTickRendererSpec(

                  // Tick and Label styling here.
                  labelStyle: new charts.TextStyleSpec(
                      // size in Pts.
                      color: darkModeOn
                          ? charts.MaterialPalette.white
                          : charts.MaterialPalette.black),

                  // Change the line colors to match text color.
                  lineStyle: new charts.LineStyleSpec(
                      color: darkModeOn
                          ? charts.MaterialPalette.white
                          : charts.MaterialPalette.black))),
                          
          primaryMeasureAxis: new charts.NumericAxisSpec(
              tickFormatterSpec: simpleCurrencyFormatter,
              renderSpec: new charts.GridlineRendererSpec(
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 11, // size in Pts.
                    color: darkModeOn
                        ? charts.MaterialPalette.white
                        : charts.MaterialPalette.black),
              )),
          defaultInteractions: true,
          defaultRenderer: new charts.BarRendererConfig(
              cornerStrategy: const charts.ConstCornerStrategy(8)),
          behaviors: [
            charts.SeriesLegend(
              showMeasures: false,
              position: charts.BehaviorPosition.top,
              outsideJustification: charts.OutsideJustification.middleDrawArea,
            ),
          ],
          selectionModels: [
            new charts.SelectionModelConfig(
              type: charts.SelectionModelType.info,
              changedListener: _onSelectionChanged,
            )
          ],
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<DataBar, String>> _createSampleData(
      List<DataBar> listI, List<DataBar> listG,darkModeOn) {


    return [
      new charts.Series<DataBar, String>(
          id: 'Ingreso',
          domainFn: (DataBar sales, _) => sales.year,
          measureFn: (DataBar sales, _) => sales.sales,
          data: listI,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault),
      new charts.Series<DataBar, String>(
          id: 'Gasto',
          domainFn: (DataBar sales, _) => sales.year,
          measureFn: (DataBar sales, _) => sales.sales,
          data: listG,
          colorFn: (_, __) =>!darkModeOn
                          ?  charts.MaterialPalette.red.shadeDefault:charts.ColorUtil.fromDartColor(Color(0xFFC75959)))
    ];
  }


}
