import 'package:gesting/database/models/categoria.dart';

import 'package:gesting/util/converter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gesting/database/TableElement.dart';
import 'package:gesting/database/models/ingreso.dart';
import 'package:gesting/database/models/gasto.dart';
import 'package:intl/intl.dart';

final String DB_FILE_NAME = "gesting.db";

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database _database;
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }

    _database = await open();

    return _database;
  }

  Future<Database> open() async {
    try {
      String databasesPath = await getDatabasesPath();
      String path = "$databasesPath/$DB_FILE_NAME";
      var db = await openDatabase(path, version: 4, onConfigure: _onConfigure,
          onCreate: (Database database, int version) {
        new Ingreso().createTable(database);
        new Gasto().createTable(database);
      
        new Categoria().createTable(database);
      }, onUpgrade: (Database database, int oldversion, int newversion) {
        if (oldversion <= 1) new Categoria().createTable(database);
        if (oldversion <= 2) {
          database.rawQuery("ALTER TABLE categoria ADD color integer");
        } if (oldversion <= 3) {
          database.rawQuery("ALTER TABLE ingreso ADD descripcion varchar(150) null");
          database.rawQuery("ALTER TABLE gasto ADD descripcion varchar(150) null");
        }   
      });
      return db;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<List> getList(TableElement e) async {
    Database dbClient = await db;

    List<Map> maps = await dbClient.query(e.tableName,
        columns: ["_id", "title", "cant", "fecha", "moneda","descripcion"],
        orderBy: "fecha desc",
        limit: 60);

    if (e is Ingreso)
      return maps.map((i) => Ingreso.fromMap(i)).toList();
    else
      return maps.map((i) => Gasto.fromMap(i)).toList();
  }

 

  Future<List<Categoria>> getCategorias(String type) async {
    Database dbClient = await db;

    List<Map> maps = await dbClient.query("categoria",
        columns: ["_id", "title", "type", "icon", "color"],
        where: "type = ?",
        whereArgs: [type],
        orderBy: "_id desc");

    return maps.map((i) => Categoria.fromMap(i)).toList();
  }

 

  Future<List> getListAll(TableElement e) async {
    Database dbClient = await db;

    List<Map> maps = await dbClient.query(e.tableName,
        columns: ["_id", "title", "cant", "fecha", "moneda","descripcion"],
        orderBy: "fecha desc");

    if (e is Ingreso)
      return maps.map((i) => Ingreso.fromMap(i)).toList();
    else
      return maps.map((i) => Gasto.fromMap(i)).toList();
  }

  Future<List> getCategoryListAll() async {
    Database dbClient = await db;

    List<Map> maps = await dbClient.query("categoria",
        columns: ["_id", "title", "type", "icon", "color"],
        orderBy: "_id desc");

    return maps.map((i) => Categoria.fromMap(i)).toList();
  }

  getMasList(int offset, int limit, TableElement e) async {
    Database dbClient = await db;

    List<Map> maps = await dbClient.query(e.tableName,
        columns: ["_id", "title", "cant", "fecha", "moneda"],
        orderBy: "fecha desc",
        limit: limit,
        offset: offset);

    if (e is Ingreso)
      return maps.map((i) => Ingreso.fromMap(i)).toList();
    else
      return maps.map((i) => Gasto.fromMap(i)).toList();
  }

  Future<TableElement> insert(TableElement element) async {
    var dbClient = await db;

    element.id = await dbClient.insert(element.tableName, element.toMap());

    return element;
  }

  Future<int> delete(TableElement element) async {
    var dbClient = await db;
    return await dbClient
        .delete(element.tableName, where: '_id = ?', whereArgs: [element.id]);
  }

  Future<int> deleteall(TableElement element) async {
    var dbClient = await db;
    return await dbClient.delete(element.tableName);
  }

  Future<int> update(TableElement element) async {
    var dbClient = await db;

    return await dbClient.update(element.tableName, element.toMap(),
        where: '_id = ?', whereArgs: [element.id]);
  }

  Future<double> getTotal(TableElement e) async {
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT SUM(cant) as total,moneda FROM  ${e.tableName} group by moneda");

    return convertMap(maps);
  }

  Future<double> getTotalbyDay(DateTime fecha, TableElement e) async {
    String fechaF = DateFormat('yyyy-MM-dd').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select SUM(cant) as total,moneda FROM ${e.tableName} WHERE fecha ='$fechaF' group by moneda;");

    return convertMap(maps);
  }

  getTotalbyMonth(fecha, TableElement e) async {
    String fechaF = DateFormat('MM-yyyy').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select SUM(cant) as total,moneda FROM ${e.tableName} WHERE strftime('%m-%Y', fecha) ='$fechaF' group by moneda;");

    return convertMap(maps);
  }

  getTotalbyYear(DateTime fecha, TableElement e) async {
    String fechaf = DateFormat('yyyy').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select SUM(cant) as total,moneda FROM ${e.tableName} WHERE strftime('%Y', fecha) ='$fechaf' group by moneda;");

    return convertMap(maps);
  }

  getbyAllMonth(TableElement e) async {
    int year = DateTime.now().year;
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select SUM(cant) as cant, strftime('%m-%Y', fecha) as 'fecha',moneda from ${e.tableName} WHERE strftime('%Y', fecha)='$year' group by moneda,strftime('%m-%Y', fecha);");

    return convertMaptoChart(maps);
  }

  getAllCat(TableElement e) async {
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select title, SUM(cant) as cant,fecha, moneda from ${e.tableName} group by title,moneda;");

    return convertMaptoIngCat(maps, await getCategorias(e.tableName));
  }

  getbyYearAllMonth(TableElement e, year) async {
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select SUM(cant) as cant, strftime('%m-%Y', fecha) as 'fecha' ,moneda from ${e.tableName} WHERE strftime('%Y', fecha)='$year' group by moneda,strftime('%m-%Y', fecha);");

    return convertMaptoChart(maps, year);
  }

  getSearchLinebyMonth(fecha, TableElement e) async {
    String fechaf = DateFormat('MM-yyyy').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select SUM(cant) as cant, strftime('%m-%Y', fecha) as 'fecha' ,moneda  from ${e.tableName} WHERE strftime('%m-%Y', fecha)='$fechaf' group by moneda,strftime('%m-%Y', fecha);");

    return convertMaptoChart(maps);
  }

  getAllYear(TableElement e) async {
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select SUM(cant) as cant, strftime('%Y', fecha) as 'fecha'  from ${e.tableName}  group by strftime('%Y', fecha);");

    return maps;
  }

  getAllYear1(TableElement e) async {
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select SUM(cant) as cant, strftime('%Y', fecha) as 'fecha' ,moneda from ${e.tableName}  group by moneda,strftime('%Y', fecha);");

    return convertMaptoBar(maps);
  }

  getSearcBarbyYear(DateTime fecha, TableElement e) async {
    String fechaf = DateFormat('yyyy').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select SUM(cant) as cant, strftime('%Y', fecha) as 'fecha',moneda  from ${e.tableName}  WHERE strftime('%Y', fecha)='$fechaf' group by moneda,strftime('%Y', fecha);");

    return convertMaptoBar(maps);
  }

  searchbyMonth(TableElement e, DateTime fecha) async {
    String fechaF = DateFormat('MM-yyyy').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select *  from ${e.tableName} WHERE strftime('%m-%Y', fecha)='$fechaF' order by fecha desc;");

    if (e is Ingreso)
      return maps.map((i) => Ingreso.fromMap(i)).toList();
    else
      return maps.map((i) => Gasto.fromMap(i)).toList();
  }

  searchbyDay(TableElement e, DateTime fecha) async {
    String fechaF = DateFormat('yyyy-MM-dd').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select * from ${e.tableName} WHERE  fecha='$fechaF' order by fecha desc;");
    if (e is Ingreso)
      return maps.map((i) => Ingreso.fromMap(i)).toList();
    else
      return maps.map((i) => Gasto.fromMap(i)).toList();
  }

  searchbyYear(TableElement e, DateTime fecha) async {
    String fechaF = DateFormat('yyyy').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select *  from ${e.tableName} WHERE strftime('%Y', fecha)='$fechaF' order by fecha desc;");
    if (e is Ingreso)
      return maps.map((i) => Ingreso.fromMap(i)).toList();
    else
      return maps.map((i) => Gasto.fromMap(i)).toList();
  }

  getCatByDay(DateTime fecha, TableElement e) async {
    String fechaF = DateFormat('yyyy-MM-dd').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select title, SUM(cant) as cant,fecha, moneda from ${e.tableName} WHERE fecha ='$fechaF' group by title,moneda;");

    return convertMaptoIngCat(maps, await getCategorias(e.tableName));
  }

  getCatByMonth(fecha, TableElement e) async {
    String fechaF = DateFormat('MM-yyyy').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select title, SUM(cant) as cant,fecha, moneda from ${e.tableName} WHERE strftime('%m-%Y', fecha) ='$fechaF' group by title,moneda;");

    return convertMaptoIngCat(maps, await getCategorias(e.tableName));
  }

  getCatByYear(DateTime fecha, TableElement e) async {
    String fechaf = DateFormat('yyyy').format(fecha);
    Database dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "select title, SUM(cant) as cant,fecha, moneda from ${e.tableName} WHERE strftime('%Y', fecha) ='$fechaf' group by title,moneda;");

    return convertMaptoIngCat(maps, await getCategorias(e.tableName));
  }
}
