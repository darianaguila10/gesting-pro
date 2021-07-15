import 'dart:async';

import 'package:gesting/database/models/gasto.dart';
import 'package:gesting/database/database.dart';
import 'package:gesting/database/models/ingreso_gasto_categ.dart';

class GastoProvider {
  static final GastoProvider _singlenton = new GastoProvider._internal();
  int offset = 0;
  bool cargando = false;
  bool isSearch = false;
  factory GastoProvider() {
    return _singlenton;
  }
  GastoProvider._internal() {
    getGastos();
  }

  DatabaseHelper _databaseHelper = new DatabaseHelper();
  List<Gasto> gastos = new List();
  double gastoTotal;

  final _gastosStreamController = StreamController<List<Gasto>>.broadcast();
  final _gastoTotalStreamController = StreamController<double>.broadcast();
  final _gastoCatStreamController =
      StreamController<List<IngGastCategory>>.broadcast();
  Function(List<Gasto>) get gastosSink => _gastosStreamController.sink.add;

  Stream<List<Gasto>> get gastosStream => _gastosStreamController.stream;

  Function(double) get gastoTotalSink => _gastoTotalStreamController.sink.add;

  Stream<double> get gastoTotalStream => _gastoTotalStreamController.stream;
  Function(List<IngGastCategory>) get gastoCatSink =>
      _gastoCatStreamController.sink.add;

  Stream<List<IngGastCategory>> get gastoCatStream =>
      _gastoCatStreamController.stream;
  void disposeStreams() {
    _gastosStreamController?.close();
    _gastoTotalStreamController?.close();
  }

  Future<List<Gasto>> getGastos() async {
    isSearch = false;
    offset = 0;
    final List<Gasto> resp = await _databaseHelper.getList(Gasto());
    gastos.clear();
    gastos.addAll(resp);
    gastosSink(resp);
    return resp;
  }

  Future<List> getGastbyCat() async {
    List<IngGastCategory> gastos = await _databaseHelper.getAllCat(Gasto());

    if (gastos == null) gastos = [];

    gastoCatSink(gastos);

    return gastos;
  }

  Future<double> getGastoTotal() async {
    double resp = await _databaseHelper.getTotal(Gasto());

    gastoTotal = resp;
    gastoTotalSink(resp);
    return resp;
  }

  void updateGasto(Gasto gasto) async {
    await _databaseHelper.update(gasto);
    getGastos();
  }

  Future<void> addGasto(Gasto gasto) async {
    await _databaseHelper.insert(gasto);

    getGastos();
  }

  void deleteGasto(Gasto gasto) async {
    await _databaseHelper.delete(gasto);
    getGastos();
  }

  Future<bool> deleteAllGasto() async {
    int r = await _databaseHelper.deleteall(new Gasto());
    getGastos();
    return r != 0 ? true : false;
  }

  void search(String text) {
    List _listForDisplay;

    _listForDisplay = gastos.where((p) {
      var title = p.title.toLowerCase();
      return title.contains(text);
    }).toList();

    gastosSink(_listForDisplay);
  }

  searchGastosbyday(DateTime fecha) async {
    isSearch = true;
    List resp = [];
    resp = await _databaseHelper.searchbyDay(new Gasto(), fecha);
    gastosSink(resp);
  }

  searchGastosbyMonth(DateTime fecha) async {
    isSearch = true;
    List resp = [];
    resp = await _databaseHelper.searchbyMonth(new Gasto(), fecha);

    gastosSink(resp);
  }

  searchGastosbyYear(DateTime fecha) async {
    isSearch = true;
    List resp = [];
    resp = await _databaseHelper.searchbyYear(new Gasto(), fecha);

    gastosSink(resp);
  }

  Future<void> cargasMasGastos() async {
    if (cargando || isSearch) return [];
    cargando = true;
    offset += 60;

    final resp = await _databaseHelper.getMasList(offset, 60, Gasto());
    gastos.addAll(resp);
    gastosSink(gastos);
    cargando = false;

    return resp;
  }

  getGastCatByDay(DateTime fecha) async {
    List<IngGastCategory> gastos =
        await _databaseHelper.getCatByDay(fecha, Gasto());

    if (gastos == null) gastos = [];

    gastoCatSink(gastos);

    return gastos;
  }

  getGastCatByMonth(DateTime fecha) async {
    List<IngGastCategory> gastos =
        await _databaseHelper.getCatByMonth(fecha, Gasto());

    if (gastos == null) gastos = [];

    gastoCatSink(gastos);

    return gastos;
  }

  getGastCatByYear(DateTime fecha) async {
    List<IngGastCategory> gastos =
        await _databaseHelper.getCatByYear(fecha, Gasto());

    if (gastos == null) gastos = [];

    gastoCatSink(gastos);

    return gastos;
  }
}
