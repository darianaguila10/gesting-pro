import 'dart:convert';
import 'dart:io';

import 'package:gesting/database/database.dart';
import 'package:gesting/database/models/bd.dart';
import 'package:gesting/database/models/categoria.dart';
import 'package:gesting/database/models/gasto.dart';
import 'package:gesting/database/models/ingreso.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

String path = "";
String salva = "";
List<Ingreso> dataI = [];
List<Gasto> dataG = [];
List<Categoria> dataC = [];

BD bd;
DatabaseHelper _databaseHelper = new DatabaseHelper();

cargarElementos() async {
  dataI = await _databaseHelper.getListAll(Ingreso());
  dataG = await _databaseHelper.getListAll(Gasto());
  dataC = await _databaseHelper.getCategoryListAll();
}

Future<File> get _localFile async {
  try {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    path = storageInfo[0].rootDir + '/gesting/';
    salva = 'db.json';

    new Directory(path).create();
    return File(path + salva);
  } catch (e) {
    print(e);
    return File("");
  }
}

Future<File> get _categoryLocalFile async {
  try {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    path = storageInfo[0].rootDir + '/gesting/';
    salva = 'category_db.json';

    new Directory(path).create();
    return File(path + salva);
  } catch (e) {
    print(e);
    return File("");
  }
}

Future<bool> importDatos() async {
  try {
    final file = await _localFile;
    var stringContent = file.readAsStringSync();
    var res = json.decode(stringContent);

    bd = BD.fromJson(res);

    dataI = bd.getingresos;
    dataG = bd.getgastos;

    if(dataI.length!=0||dataG.length!=0)
    borrarTodo();

    for (var item in dataI) {
      _databaseHelper.insert(item);
    }

    for (var item in dataG) {
      _databaseHelper.insert(item);
    }
    await importarCategoria();
  } catch (e) {
    print('Error: $e');
    return false;
  }

  return true;
}

Future<void> importarCategoria() async {
  try {
    final categoryFile = await _categoryLocalFile;
    var categoryString = categoryFile.readAsStringSync();
    var resp = json.decode(categoryString);
    List<Categoria> c = List<Categoria>.from(
        resp.map((i) => new Categoria.fromJson(i)).toList());

    for (var item in c) {
      _databaseHelper.insert(item);
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<String> exportDatos() async {
  await cargarElementos();
  if (dataI.length == 0 && dataG.length == 0 && dataC.length == 0) return '0';
  File file;
  try {
    if (dataI.length != 0 ||dataG.length != 0) {
      file = await _localFile;

      BD bd = BD(ingresos: dataI, gastos: dataG);

      file.writeAsStringSync(json.encode(bd.toJson()).toString());
    }
    if (dataC.length != 0) exportarCategory();
  } catch (e) {
    print('Error: $e');
    return null;
  }

  return path + salva;
}

Future<void> exportarCategory() async {
  try {
    File file;
    file = await _categoryLocalFile;
    file.writeAsStringSync(
        json.encode(dataC.map((i) => i.toJson()).toList()).toString());
  } catch (e) {
    print('Error: $e');
  }
}

borrarTodo() {
  _databaseHelper.deleteall(Ingreso());
  _databaseHelper.deleteall(Gasto());
  _databaseHelper.deleteall(Categoria());
}
