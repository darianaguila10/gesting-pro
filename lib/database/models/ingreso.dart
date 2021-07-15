import 'package:sqflite/sqflite.dart';
import 'package:gesting/database/TableElement.dart';
import 'package:intl/intl.dart';

class Ingreso extends TableElement {
  static final String TABLE_NAME = "ingreso";
  String title;
  double cant;
  DateTime fecha;
  String moneda;
  String descripcion;

  Ingreso(
      {this.title,
      this.cant = 0,
      this.fecha,
      this.moneda,
      this.descripcion,
      id})
      : super(id, TABLE_NAME);
  factory Ingreso.fromMap(Map<String, dynamic> map) {
    return Ingreso(
        title: map["title"],
        cant: map["cant"],
        fecha: DateFormat('yyyy-MM-dd').parse(map["fecha"]),
        moneda: map["moneda"],
        descripcion: map["descripcion"] ?? "",
        id: map["_id"]);
  }

  @override
  void createTable(Database db) {
    db.rawUpdate(
        "CREATE TABLE ${TABLE_NAME}(_id integer primary key autoincrement, title varchar(30),cant real, fecha varchar(30),moneda varchar(5),descripcion varchar(150) null )");
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "title": this.title,
      "cant": this.cant,
      "fecha": DateFormat('yyyy-MM-dd').format(this.fecha),
      "moneda": this.moneda,
      "descripcion": this.descripcion,
    };
    if (this.id != null) {
      map["_id"] = id;
    }
    return map;
  }

  toJson() => {
        "title": this.title,
        "cant": this.cant,
        "fecha": DateFormat('yyyy-MM-dd').format(this.fecha),
        "moneda": this.moneda,
        "descripcion": this.descripcion,
      };

  factory Ingreso.fromJson(Map<String, dynamic> json) {
    return new Ingreso(
      title: json["title"],
      cant: json["cant"],
      fecha: DateFormat('yyyy-MM-dd').parse(json["fecha"]),
      moneda: json["moneda"],
      descripcion:  json["descripcion"] ?? "",
    );
  }
}