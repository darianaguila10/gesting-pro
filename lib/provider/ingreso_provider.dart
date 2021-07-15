import 'dart:async';

import 'package:gesting/database/models/ingreso.dart';
import 'package:gesting/database/database.dart';
import 'package:gesting/database/models/ingreso_gasto_categ.dart';

class IngresoProvider {
  static final IngresoProvider _singlenton = new IngresoProvider._internal();
  int offset = 0;
  bool cargando = false;
  bool isSearch = false;
  factory IngresoProvider() {
    return _singlenton;
  }
  IngresoProvider._internal() {
    getIngresos();
    getIngbyCat();
  }

  DatabaseHelper _databaseHelper = new DatabaseHelper();
  List<Ingreso> ingresos = new List();
  double ingresoTotal;

  final _ingresosStreamController = StreamController<List<Ingreso>>.broadcast();
  final _ingresoTotalStreamController = StreamController<double>.broadcast();
  final _ingresoCatStreamController =
      StreamController<List<IngGastCategory>>.broadcast();

  Function(List<Ingreso>) get ingresosSink =>
      _ingresosStreamController.sink.add;

  Stream<List<Ingreso>> get ingresosStream => _ingresosStreamController.stream;

  Function(double) get ingresoTotalSink =>
      _ingresoTotalStreamController.sink.add;

  Stream<double> get ingresoTotalStream => _ingresoTotalStreamController.stream;

  Function(List<IngGastCategory>) get ingresoCatSink =>
      _ingresoCatStreamController.sink.add;

  Stream<List<IngGastCategory>> get ingresoCatStream =>
      _ingresoCatStreamController.stream;

  void disposeStreams() {
    _ingresosStreamController?.close();
    _ingresoTotalStreamController?.close();
    _ingresoCatStreamController?.close();
  }

  Future<List<Ingreso>> getIngresos() async {
    isSearch = false;
    offset = 0;
    final List<Ingreso> resp = await _databaseHelper.getList(Ingreso());
    ingresos.clear();
    ingresos.addAll(resp);
    ingresosSink(resp);
    return resp;
  }

  Future<List> getIngbyCat() async {
    List<IngGastCategory> ingresos =
        await _databaseHelper.getAllCat(Ingreso());

    if (ingresos == null) ingresos = [];

    ingresoCatSink(ingresos);

    return ingresos;
  }

  Future<double> getIngresoTotal() async {
    double resp = await _databaseHelper.getTotal(Ingreso());

    ingresoTotal = resp;
    ingresoTotalSink(resp);
    return resp;
  }

  void updateIngreso(Ingreso ingreso) async {
    await _databaseHelper.update(ingreso);
    getIngresos();
  }

  Future<void> addIngreso(Ingreso ingreso) async {
    await _databaseHelper.insert(ingreso);

    getIngresos();
  }

  void deleteIngreso(Ingreso ingreso) async {
    await _databaseHelper.delete(ingreso);
    getIngresos();
  }

  Future<bool> deleteAllIngreso() async {
    int r = await _databaseHelper.deleteall(new Ingreso());
    getIngresos();
    return r != 0 ? true : false;
  }

  void search(String text) {
    List _listForDisplay;

    _listForDisplay = ingresos.where((p) {
      var title = p.title.toLowerCase();
      return title.contains(text);
    }).toList();

    ingresosSink(_listForDisplay);
  }

  searchIngresosbyday(DateTime fecha) async {
    isSearch = true;
    List resp = [];
    resp = await _databaseHelper.searchbyDay(new Ingreso(), fecha);
    ingresosSink(resp);
  }

  searchIngresosbyMonth(DateTime fecha) async {
    isSearch = true;
    List resp = [];
    resp = await _databaseHelper.searchbyMonth(new Ingreso(), fecha);

    ingresosSink(resp);
  }

  searchIngresosbyYear(DateTime fecha) async {
    isSearch = true;
    List resp = [];
    resp = await _databaseHelper.searchbyYear(new Ingreso(), fecha);

    ingresosSink(resp);
  }

  Future<void> cargasMasIngresos() async {
    if (cargando || isSearch) return [];
    cargando = true;
    offset += 60;

    final resp = await _databaseHelper.getMasList(offset, 60, Ingreso());
    ingresos.addAll(resp);
    ingresosSink(ingresos);
    cargando = false;

    return resp;
  }

  getIngCatByDay(DateTime fecha) async {
    List<IngGastCategory> ingresos =
        await _databaseHelper.getCatByDay(fecha, Ingreso());

    if (ingresos == null) ingresos = [];

    ingresoCatSink(ingresos);

    return ingresos;
  }

  getIngCatByMonth(DateTime fecha) async {
    List<IngGastCategory> ingresos =
        await _databaseHelper.getCatByMonth(fecha, Ingreso());

    if (ingresos == null) ingresos = [];

    ingresoCatSink(ingresos);

    return ingresos;
  }

  getIngCatByYear(DateTime fecha) async {
    List<IngGastCategory> ingresos =
        await _databaseHelper.getCatByYear(fecha, Ingreso());

    if (ingresos == null) ingresos = [];

    ingresoCatSink(ingresos);

    return ingresos;
  }
}
