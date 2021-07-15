import 'dart:async';

import 'package:gesting/database/models/categoria.dart';
import 'package:gesting/database/database.dart';
import "package:collection/collection.dart";

class CategoriaProvider {
  static final CategoriaProvider _singlenton =
      new CategoriaProvider._internal();

  factory CategoriaProvider() {
    return _singlenton;
  }
  CategoriaProvider._internal() {}

  DatabaseHelper _databaseHelper = new DatabaseHelper();
  List<Categoria> categorias = new List();
  Map categoriasMap;

  final _categoriasStreamController =
      StreamController<List<Categoria>>.broadcast();

  Function(List<Categoria>) get categoriasSink =>
      _categoriasStreamController.sink.add;

  Stream<List<Categoria>> get categoriasStream =>
      _categoriasStreamController.stream;

  void disposeStreams() {
    _categoriasStreamController?.close();
  }

  Future<List<Categoria>> getCategorias(String type) async {
    final List<Categoria> resp = await _databaseHelper.getCategorias(type);
    categoriasMap = groupBy(resp, (obj) => obj.title);

    categorias.clear();
    categorias.addAll(resp);
    categoriasSink(resp);
    return resp;
  }

  getCategoriasMap() {
    return categoriasMap;
  }

  void updateCategoria(Categoria categoria, String type) async {
    await _databaseHelper.update(categoria);
    getCategorias(type);
  }

  Future<void> addCategoria(Categoria categoria, String type) async {
    await _databaseHelper.insert(categoria);

    getCategorias(type);
  }

  void deleteCategoria(Categoria categoria, String type) async {
    await _databaseHelper.delete(categoria);
    getCategorias(type);
  }

  Future<bool> deleteAllCategoria() async {
    int r = await _databaseHelper.deleteall(new Categoria());
    getCategorias("ingreso");
    return r != 0 ? true : false;
  }

  void search(String text) {
    List _listForDisplay;

    _listForDisplay = categorias.where((p) {
      var title = p.title.toLowerCase();
      return title.contains(text);
    }).toList();

    categoriasSink(_listForDisplay);
  }
}
