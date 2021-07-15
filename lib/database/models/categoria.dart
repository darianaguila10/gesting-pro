import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gesting/database/TableElement.dart';

class Categoria extends TableElement {
  static final String TABLE_NAME = "categoria";
  String title;
  String type;
  Color color;

  int icon;

  Categoria({this.title, this.type, this.icon, this.color, id})
      : super(id, TABLE_NAME);
  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
        title: map["title"],
        type: map["type"],
        icon: map["icon"],
        color: Color(map["color"] ?? 0xff4caf50),
        id: map["_id"]);
  }

  @override
  void createTable(Database db) {
    db.rawUpdate(
        "CREATE TABLE ${TABLE_NAME}(_id integer primary key autoincrement, title varchar(30),type varchar(30),icon integer,color integer)");
    db.rawInsert(
        'INSERT INTO ${TABLE_NAME}(title, type,icon,color) VALUES("salario", "ingreso",18,4288448511)');
    db.rawInsert(
        'INSERT INTO ${TABLE_NAME}(title, type,icon,color) VALUES("negocio", "ingreso",2,4291916345)');
    db.rawInsert(
        'INSERT INTO ${TABLE_NAME}(title, type,icon,color) VALUES("venta", "ingreso",4,4284992382)');
    db.rawInsert(
        'INSERT INTO ${TABLE_NAME}(title, type,icon,color) VALUES("comida", "gasto",1,4289307204)');
    db.rawInsert(
        'INSERT INTO ${TABLE_NAME}(title, type,icon,color) VALUES("transporte", "gasto",8,4293610315)');
    db.rawInsert(
        'INSERT INTO ${TABLE_NAME}(title, type,icon,color) VALUES("casa", "gasto",21,4293221492)');
    db.rawInsert(
        'INSERT INTO ${TABLE_NAME}(title, type,icon,color) VALUES("pago de electricidad", "gasto",5,4285652200)');
    db.rawInsert(
        'INSERT INTO ${TABLE_NAME}(title, type,icon,color) VALUES("recarga de móvil", "gasto",52,4283821397)');
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "title": this.title,
      "type": this.type,
      "icon": this.icon,
      "color": int.parse(this
          .color
          .toString()
          .replaceAll("Color", '')
          .replaceAll('(', '')
          .replaceAll(')', '')),
    };
    if (this.id != null) {
      map["_id"] = id;
    }
    return map;
  }

  toJson() => {
        "title": this.title,
        "type": this.type,
        "icon": this.icon,
        "color": int.parse(this
            .color
            .toString()
            .replaceAll("Color", '')
            .replaceAll('(', '')
            .replaceAll(')', '')),
      };

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return new Categoria(
        title: json["title"],
        type: json["type"],
        icon: json["icon"],
        color: Color(json["color"] ?? 0xff4caf50));
  }
}
