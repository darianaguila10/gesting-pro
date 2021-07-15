import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:gesting/database/models/ingreso.dart';
import 'package:gesting/database/models/gasto.dart';

import 'package:gesting/database/database.dart';
import 'package:gesting/validacion/validate.dart';

class Testdata extends StatefulWidget {
  @override
  TestdataState createState() => TestdataState();
}

class TestdataState extends State<Testdata> {
  static const String routeName = "/testdata";
  static List<String> lisM = ["CUP", "CUC", "USD"];
  List<Ingreso> _listI;
  List<Gasto> _listG;
  DatabaseHelper _databaseHelper;
  int cantelement = 0;
  double cant = 0;
  String moneda = lisM[0];
  int id = 0;
  int last = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TestData"),
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Cantidad de elementos...'),
              onChanged: (value) {
                cantelement = int.parse(value);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              inputFormatters: validateForm(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Dinero'),
              onChanged: (value) {
                cant = double.parse(value);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: DropdownButtonFormField<String>(
              hint: Text('Moneda'),
              value: moneda,
              items: lisM.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  moneda = value;
                });
                FocusScope.of(context).requestFocus(new FocusNode());
              },
            ),
          ),
          FlatButton.icon(
              onPressed: () {
                addIngreso();
              },
              icon: Icon(Icons.add_circle_outline),
              label: Text("Llenar Ingreso")),
          FlatButton.icon(
              onPressed: () {
                addGasto();
              },
              icon: Icon(Icons.remove_circle),
              label: Text("Llenar Gasto")),
          FlatButton.icon(
              onPressed: () {
                borrarTodo();
              },
              icon: Icon(Icons.delete_forever),
              label: Text("Borrar Todo")), FlatButton.icon(
              onPressed: () {
                addIngresoOfSms();
              },
              icon: Icon(Icons.sms),
              label: Text("Licencias Gesting"))
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    _databaseHelper = new DatabaseHelper();
  }

  void addIngreso() {
    _listI = List<Ingreso>.generate(cantelement, (index) {
      return new Ingreso(
          cant: cant,
          title: "test-$index",
          fecha: DateTime(2020, 1, 1).add(Duration(days: index + 20)),
          moneda: moneda);
    });
    for (var item in _listI) {
      _databaseHelper.insert(item);
    }
  }
addIngresoOfSms() async {
    List<Ingreso> _listI = [];
    SmsQuery query = new SmsQuery();
    List<SmsMessage> messages;
    messages =
        await query.querySms(kinds: [SmsQueryKind.Inbox], address: "Cubacel");
    for (var item in messages) {
      if (item.body.contains("Usted ha recibido")&&item.date.isAfter(DateTime(2020,10,6))) {
        _listI.add(Ingreso(
            cant: 0.50, moneda: 'CUC', title: "licencia-"+item.address, fecha: item.date));
      }
    }

   for (var item in _listI) {
      _databaseHelper.insert(item);
    }
  }

 

  void addGasto() {
    _listG = List<Gasto>.generate(cantelement, (index) {
      return new Gasto(
          cant: cant,
          title: "test-$index",
          fecha: DateTime(2020, 1, 1).add(Duration(days: index + 20)),
          moneda: moneda);
    });
    for (var item in _listG) {
      _databaseHelper.insert(item);
    }
  }

  void borrarTodo() {
    _databaseHelper.deleteall(Ingreso());
    _databaseHelper.deleteall(Gasto());
  }
}
