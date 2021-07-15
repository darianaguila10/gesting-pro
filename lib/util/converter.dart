import 'dart:math';

import 'package:gesting/database/models/DataBar.dart';
import 'package:gesting/database/models/DataLine.dart';
import 'package:gesting/database/models/categoria.dart';
import 'package:gesting/database/models/ingreso_gasto_categ.dart';
import 'package:gesting/preferencia/preferencia_moneda.dart';
import 'package:intl/intl.dart';

final prefs = PreferenciaMoneda();

double convertMap(List<Map> maps) {
  double total = 0;

  if (maps.length != 0) {
    for (var item in maps) {
      String codM = item['moneda'];
      double cant = item['total'];
      total += combertirMoneda(cant, codM);
    }
  }
  return total;
}

List<DataLine> convertMaptoChart(List<Map> maps, [year = 0]) {
  int y = (year != 0) ? year : DateTime.now().year;

  List<DataLine> listFinal = List.generate(12, (index) {
    return DataLine(time: DateTime(y, index + 1), sales: 0);
  });

  if (maps.length != 0) {
    for (int i = 0; i < maps.length; i++) {
      String codM = maps[i]['moneda'];
      double cant = maps[i]['cant'];
      double cantC = combertirMoneda(cant, codM);

      int month = DateFormat('MM-yyyy').parse(maps[i]["fecha"]).month;
      cantC += listFinal[month - 1].sales;
      listFinal[month - 1].sales = cantC;
    }
  }

  return listFinal;
}

List<IngGastCategory> convertMaptoIngCat(List<Map> maps, List<Categoria> cat) {
  List<IngGastCategory> ingregast = [];
  Map<String, IngGastCategory> categorias = {};
  if (cat.length != 0) {
    cat.forEach((v) {
      categorias[v.title] = IngGastCategory(
          cant: 0, title: v.title, icon: v.icon, type: v.type, color: v.color);
    });

    if (maps.length != 0) {
      for (int i = 0; i < maps.length; i++) {
        String title = maps[i]['title'];
        String codM = maps[i]['moneda'];
        double cant = maps[i]['cant'];
        double cantC = combertirMoneda(cant, codM);
        if (categorias[title] != null) {
          categorias[title].cant = categorias[title].cant + cantC;
        }
      }

      return categorias.values.where((v) => v.cant != 0).toList();
    }
  }
  return ingregast;
}

List<DataBar> convertMaptoBar(List<Map> maps) {
  List<DataBar> listFinal = [];

  if (maps.length != 0) {
    for (int i = 0; i < maps.length; i++) {
      int y = 0;
      String codM = maps[i]['moneda'];
      double cant = maps[i]['cant'];
      double cantC = combertirMoneda(cant, codM);

      y = DateFormat('yyyy').parse(maps[i]["fecha"]).year;

      int index = listFinal.indexWhere((item) => item.year == y.toString());
      if (index != -1) {
        cantC += listFinal[index].sales;
        listFinal[index].sales = cantC;
      }
      listFinal.add(DataBar(maps[i]["fecha"], cantC));
    }
  }

  return listFinal.sublist(0, (listFinal.length < 5) ? listFinal.length : 6);
}

double combertirMoneda(double cant, String codM) {
  double val = 0.00;
  String monedaActual = prefs.monedaPrincipal;
  double cuc_cup = prefs.cucToCup;
  double cup_cuc = prefs.cupToCuC;
  double usd_cuc = prefs.usdToCuc;
  double eur_cuc = prefs.eurToCuc;
  if (codM == 'CUC') {
    if (monedaActual == 'CUP')
      val = cant * cuc_cup;
    else if (monedaActual == 'USD')
      val = cant / usd_cuc;
    else if (monedaActual == 'EUR')
      val = cant / eur_cuc;
    else
      val = cant;
  } else if (codM == 'CUP') {
    if (monedaActual == 'CUC')
      val = cant / cup_cuc;
    else if (monedaActual == 'USD')
      val = cant / cup_cuc * usd_cuc;
    else if (monedaActual == 'EUR')
      val = cant / cup_cuc * eur_cuc;
    else
      val = cant;
  } else if (codM == 'USD') {
    if (monedaActual == 'CUC')
      val = cant * usd_cuc;
    else if (monedaActual == 'CUP')
      val = cant * usd_cuc * cuc_cup;
    else if (monedaActual == 'EUR')
      val = cant * usd_cuc / eur_cuc;
    else
      val = cant;
  }else{
   if (monedaActual == 'CUC')
      val = cant * eur_cuc;
    else if (monedaActual == 'CUP')
      val = cant * eur_cuc * cuc_cup;
    else if (monedaActual == 'USD')
      val = cant * eur_cuc / usd_cuc;
    else
      val = cant;
    
  }

  return val;
}

String formatearMoneda(double cant) {
  NumberFormat numberFormat = new NumberFormat("#,##0.##", "en");

  if (cant.abs() <= 999999.99) return "\$" + numberFormat.format(cant);

  int cantE = cant ~/ pow(10, 6);

  NumberFormat numberFormatM = new NumberFormat("#,##0", "en");
  return "\$" + numberFormatM.format(cantE) + " M";
}

String formatMonedaForm(double cant) {
  NumberFormat numberFormat = new NumberFormat("0.##", "en");

  return numberFormat.format(cant);
}
