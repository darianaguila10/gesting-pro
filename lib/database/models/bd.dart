import 'package:gesting/database/models/gasto.dart';
import 'package:gesting/database/models/ingreso.dart';

class BD {
  List<Ingreso> ingresos;
  List<Gasto> gastos;

  BD({this.ingresos, this.gastos});

  factory BD.fromJson(Map<String, dynamic> json) {
    var listi = json['ingresos'] as List;
    List<Ingreso> i = listi.map((i) => Ingreso.fromJson(i)).toList();
    var listg = json['gastos'] as List;
    List<Gasto> g = listg.map((i) => Gasto.fromJson(i)).toList();

    return new BD(
      ingresos: i,
      gastos: g,
    );
  }
  get getingresos {
    return ingresos;
  }

  get getgastos {
    return gastos;
  }

  toJson() => {
        "ingresos": this.ingresos,
        "gastos": this.gastos,
      };
}
