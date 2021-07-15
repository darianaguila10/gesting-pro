import 'dart:async';

import 'package:gesting/database/database.dart';
import 'package:gesting/database/models/DataBar.dart';
import 'package:gesting/database/models/DataLine.dart';
import 'package:gesting/database/models/gasto.dart';
import 'package:gesting/database/models/ingreso.dart';

class BalanceProvider {
  static final BalanceProvider _singlenton = new BalanceProvider._internal();
  final years = [];
  int p;
  factory BalanceProvider() {
    return _singlenton;
  }
  BalanceProvider._internal() {
    getBalance();
  }
  int year;
  DatabaseHelper _databaseHelper = new DatabaseHelper();

  final _balanceTotalStreamController =      StreamController<List<double>>.broadcast();

  final _ingresogastoMonthController = StreamController<List>.broadcast();
  final _ingresogastoYearController = StreamController<List>.broadcast();

  Function(List<double>) get balanceTotalSink =>
      _balanceTotalStreamController.sink.add;

  Stream<List<double>> get balanceTotalStream =>
      _balanceTotalStreamController.stream;

  Function(List) get ingresogastoMSink => _ingresogastoMonthController.sink.add;

  Stream<List> get ingresogastMStream => _ingresogastoMonthController.stream;

  Function(List) get ingresogastoYSink => _ingresogastoYearController.sink.add;

  Stream<List> get ingresogastoYStream => _ingresogastoYearController.stream;

  void dispose() {
    _balanceTotalStreamController?.close();
    _ingresogastoMonthController?.close();
    _ingresogastoYearController?.close();
  }

  Future<List<double>> getBalance() async {
    double ing = await _databaseHelper.getTotal(Ingreso());
    double gast = await _databaseHelper.getTotal(Gasto());

    if (ing == null) ing = 0.0;
    if (gast == null) gast = 0.0;

    balanceTotalSink([ing, gast]);
    return [ing, gast];
  }

  getBalancebyday(fecha) async {
    double ing = await _databaseHelper.getTotalbyDay(fecha, Ingreso());
    double gast = await _databaseHelper.getTotalbyDay(fecha, Gasto());

    if (ing == null) ing = 0.0;
    if (gast == null) gast = 0.0;

    balanceTotalSink([ing, gast]);
  }

  getBalancebyMonth(fecha) async {
    double ing = await _databaseHelper.getTotalbyMonth(fecha, Ingreso());
    double gast = await _databaseHelper.getTotalbyMonth(fecha, Gasto());

    if (ing == null) ing = 0.0;
    if (gast == null) gast = 0.0;

    balanceTotalSink([ing, gast]);
  }

  Future<List> getIngGastbyAllMonth() async {
    year = DateTime.now().year;
    List<DataLine> ingresos = await _databaseHelper.getbyAllMonth(Ingreso());
    List<DataLine> gastos = await _databaseHelper.getbyAllMonth(Gasto());

    if (ingresos == null) ingresos = [];
    if (gastos == null) gastos = [];

    ingresogastoMSink([ingresos, gastos]);

    return [ingresos, gastos];
  }

  Future<List> getIngGastYearbyAllMonth(int yearP) async {
    year = yearP;
    List ingresos = await _databaseHelper.getbyYearAllMonth(Ingreso(), year);
    List gastos = await _databaseHelper.getbyYearAllMonth(Gasto(), year);

    if (ingresos == null) ingresos = [];
    if (gastos == null) gastos = [];

    ingresogastoMSink([ingresos, gastos]);

    return [ingresos, gastos];
  }

  Future<List> getIngGastbyMonth(DateTime fecha) async {
    year = fecha.year;
    List ingresos = await _databaseHelper.getSearchLinebyMonth(fecha,Ingreso());
    List gastos = await _databaseHelper.getSearchLinebyMonth(fecha,Gasto());

    if (ingresos == null) ingresos = [];
    if (gastos == null) gastos = [];

    ingresogastoMSink([ingresos, gastos]);

    return [ingresos, gastos];
  }

  getBalancebyyear(DateTime fecha) async {
    double ing = await _databaseHelper.getTotalbyYear(fecha, Ingreso());
    double gast = await _databaseHelper.getTotalbyYear(fecha, Gasto());

    if (ing == null) ing = 0.0;
    if (gast == null) gast = 0.0;

    balanceTotalSink([ing, gast]);
  }

  Future<List> getIngGastbyAllYear() async {
    List<DataBar> ingresos = await _databaseHelper.getAllYear1(Ingreso());
    List<DataBar> gastos = await _databaseHelper.getAllYear1(Gasto());

    if (ingresos == null) ingresos = [];
    if (gastos == null) gastos = [];

    ingresogastoYSink([ingresos, gastos]);

    return [ingresos, gastos];
  }

  Future<List> getIngGastbyYear(DateTime fecha) async {
    List ingresos = await _databaseHelper.getSearcBarbyYear(fecha,Ingreso());
    List gastos = await _databaseHelper.getSearcBarbyYear(fecha,Gasto());

    if (ingresos == null) ingresos = [];
    if (gastos == null) gastos = [];

    ingresogastoYSink([ingresos, gastos]);

    return [ingresos, gastos];
  }

  getYear() {
    return year;
  }

  getYears() async {
    p = 0;
    List ingresos = await _databaseHelper.getAllYear(Ingreso());
    List gastos = await _databaseHelper.getAllYear(Gasto());
    years.clear();
    var s = <String>{};

    if (ingresos == null) ingresos = [];
    if (gastos == null) gastos = [];

    for (var item in ingresos) {
      s.add(item['fecha']);
    }
    for (var item in gastos) {
      s.add(item['fecha']);
    }

    years.addAll(s);
    years.sort();
  } 

  getListYears() {
    return years;
  }

  selectYear(i) async {
    if ((p + i) >= 0 && (p + i) < years.length) {
      p += i;
    
      year = int.parse(years[p]);

     await getIngGastYearbyAllMonth(year);
    }
  }
}
