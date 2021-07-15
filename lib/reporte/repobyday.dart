import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gesting/provider/balance_provider.dart';

import 'package:gesting/reporte/mypanelcard.dart';
import 'package:gesting/widget/myPieChart.dart';

class Repobyday extends StatefulWidget {
  Repobyday({Key key}) : super(key: key);

  @override
  _RepobydayState createState() => _RepobydayState();
}

GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();

class _RepobydayState extends State<Repobyday> {
  final balanceProvider = new BalanceProvider();

  double ingresosTotal = 0.0;
  double gastosTotal = 0.0;

  GlobalKey<FormState> _keyfilterForm = new GlobalKey();
  TextStyle estiloTexto = TextStyle(fontSize: 12, color: Colors.white);
  DateTime _fecha;

  TextEditingController _inputFieldFilter = new TextEditingController();

  String title;

  AnimationController animateController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scalffoldkey,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: _dayfilter(),
                  flex: 3,
                ),
                Expanded(
                  child: FlatButton(
                    child: Icon(Icons.search),
                    onPressed: () {
                      if (_fecha != null) {
                        balanceProvider.getBalancebyday(_fecha);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    child: Icon(Icons.close),
                    onPressed: () {
                      _inputFieldFilter.clear();
                      _fecha = null;
                      balanceProvider.getBalance();
                    },
                  ),
                ),
              ],
            ),
            Expanded(child: _getBody())
          ]),
        ),);
       
  }

  _selectDate(
      BuildContext context, TextEditingController _inputFieldDateC) async {
   DateTime _fechat = _fecha ?? DateTime.now();
    showDatePicker(
            context: context,
            initialDate: _fechat,
            firstDate: new DateTime(2020),
            lastDate: new DateTime(2100),
            locale: Locale('es', 'ES'))
        .then((date) {
      if (date != null) {
        setState(() {
          _fecha = date;
          _inputFieldDateC.text = DateFormat('d-MMMM-yyyy', 'es').format(date);
        });
      }
    });
  }

  Widget _getBody() {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: balanceProvider.balanceTotalStream,
      builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
        if (snapshot.hasData) {
          ingresosTotal = snapshot.data[0];
          gastosTotal = snapshot.data[1];
        } else {
          ingresosTotal = 0.0;
          gastosTotal = 0.0;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                 height: size.height /4,child: MyPanelCard(ingresosTotal, gastosTotal)),
             
              Container(
                  height: size.height>600? size.height /2.25:size.height /2.4,
                  child: BounceInDown(
                      duration: Duration(milliseconds: 1000),
                      manualTrigger: true,
                      controller: (controller) =>
                          animateController = controller,
                      child: MyPieChart(ingresosTotal, gastosTotal))),
            ],
          ),
        );
      },
    );
  }

  _dayfilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _keyfilterForm,
        child: TextFormField(
          validator: validateName,
          enableInteractiveSelection: false,
          controller: _inputFieldFilter,
          decoration: InputDecoration(
            hintText: 'Fecha',
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectDate(context, _inputFieldFilter);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _inputFieldFilter.dispose();
  }

  @override
  void initState() {
    super.initState();
    balanceProvider.getBalance();
  }

  String validateName(String value) {
    if (value.length == 0)
      return "Esta vacío";
    else
      return null;
  }
}
