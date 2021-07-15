import 'package:flutter/material.dart';
import 'package:gesting/configuracion/dropdown.dart';
import 'package:gesting/preferencia/preferencia_moneda.dart';
import 'package:gesting/validacion/validate.dart';

class Coin extends StatefulWidget {
  Coin();

  @override
  CoinState createState() => CoinState();
}

class CoinState extends State<Coin> {
  static const String routeName = "/moneda";
  final prefs = PreferenciaMoneda();
  final TextEditingController _inputCuptoCucController =
      new TextEditingController();

  final TextEditingController _inputCuctoCupController =
      new TextEditingController();

  final TextEditingController _inputUsdtoCucController =
      new TextEditingController();

        final TextEditingController _inputEurtoCucController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputCuptoCucController.text = prefs.cupToCuC.toString();
    _inputCuctoCupController.text = prefs.cucToCup.toString();
    _inputUsdtoCucController.text = prefs.usdToCuc.toString();
    _inputEurtoCucController.text=prefs.eurToCuc.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Moneda"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Moneda principal"),
                Container(
                    width: 100,
                    padding: EdgeInsets.only(left: 10),
                    child: DropdownCoin()),
                SizedBox(
                  height: 30,
                ),
                Text("Tasa de cambio"),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  inputFormatters:validateForm(),
                  onChanged: (v) {
                    double val = double.parse(v);
                    prefs.cupToCuC = (val > 0) ? val : 25.0;
                  },
                  controller: _inputCuptoCucController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true,),
                  decoration: InputDecoration(
                      hintText: "CUP --> CUC",
                      labelText: "CUP --> CUC",
                      border: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(16))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(  inputFormatters:validateForm(),
                  onChanged: (v) {
                    double val = double.parse(v);
                    prefs.cucToCup = (val > 0) ? val : 24.0;
                  },
                  controller: _inputCuctoCupController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true,),
                  decoration: InputDecoration(
                      hintText: "CUC --> CUP",
                      labelText: "CUC --> CUP",
                      border: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(16))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(  inputFormatters: validateForm(),
                  onChanged: (v) {
                    double val = double.parse(v);
                    prefs.usdToCuc = (val > 0) ? val : 0.95;
                  },
                  controller: _inputUsdtoCucController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true,),
                  decoration: InputDecoration(
                      hintText: "USD --> CUC",
                      labelText: "USD --> CUC",
                      border: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(16))),
                ),   SizedBox(
                  height: 20,
                ), TextFormField(  inputFormatters: validateForm(),
                  onChanged: (v) {
                    double val = double.parse(v);
                    prefs.eurToCuc = (val > 0) ? val : 0.95;
                  },
                  controller: _inputEurtoCucController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true,),
                  decoration: InputDecoration(
                      hintText: "EUR --> CUC",
                      labelText: "EUR --> CUC",
                      border: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(16))),
                ),
              ],
            )),
      ),
    );
  }
}
