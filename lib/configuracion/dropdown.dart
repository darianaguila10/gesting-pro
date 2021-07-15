import 'package:flutter/material.dart';
import 'package:gesting/preferencia/preferencia_moneda.dart';


class DropdownCoin extends StatefulWidget {
  DropdownCoin();

  @override
  _DropdownCoinState createState() => _DropdownCoinState();
}

class _DropdownCoinState extends State<DropdownCoin> {
  final prefs = PreferenciaMoneda();
  List<String> _listM = ["CUP", "CUC", "USD","EUR"];
  String _value;
  @override
  void initState() {
    super.initState();
    setState(() {
      _value = prefs.monedaPrincipal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
        hint: Text('Moneda'),
        value: _value,
        items: _listM.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged:
            _setSelected 

        );
  }

  _setSelected(String val) async {
    prefs.monedaPrincipal = val;

    setState(() {
      _value = val;
    });
  }
}
