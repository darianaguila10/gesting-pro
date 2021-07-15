import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gesting/database/models/DataLine.dart';
import 'package:intl/intl.dart';
import 'package:gesting/provider/balance_provider.dart';

import 'package:gesting/reporte/mypanelcard.dart';
import 'package:gesting/widget/myLineChart.dart';

import 'package:month_picker_dialog/month_picker_dialog.dart';

class Repobymonth extends StatefulWidget {
  Repobymonth({Key key}) : super(key: key);

  @override
  _RepobymonthState createState() => _RepobymonthState();
}

GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();

class _RepobymonthState extends State<Repobymonth> {
  List<DataLine> _listI = [];
  List<DataLine> _listG = [];

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
                child: _monthfilter(),
                flex: 3,
              ),
              Expanded(
                child: FlatButton(
                  child: Icon(Icons.search),
                  onPressed: () {
                    if (_fecha != null) {
                      balanceProvider.getBalancebyMonth(_fecha);
                      balanceProvider.getIngGastbyMonth(_fecha);
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
                    balanceProvider.getIngGastbyAllMonth();
                  },
                ),
              ),
            ],
          ),
          Expanded(child: _getBody())
        ]),
      ),
    );
  }

  _selectMonth(
      BuildContext context, TextEditingController _inputFieldDateC) async {
    DateTime _fechat = _fecha ?? DateTime.now();
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10, 5),
      lastDate: DateTime(DateTime.now().year + 10, 9),
      initialDate: _fechat,
      locale: Locale("es"),
    ).then((date) {
      if (date != null) {
        setState(() {
          _fecha = date;
          _inputFieldDateC.text = DateFormat('MMMM-yyyy', 'es').format(date);
        });
      }
    });
  }

  Widget _getBody() {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          StreamBuilder(
              stream: balanceProvider.balanceTotalStream,
              builder:
                  (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
                if (snapshot.hasData) {
                  ingresosTotal = snapshot.data[0];
                  gastosTotal = snapshot.data[1];
                } else {
                  ingresosTotal = 0.0;
                  gastosTotal = 0.0;
                }

                return Container(
                    height: size.height /4,
                    child: MyPanelCard(ingresosTotal, gastosTotal));
              }),
          Container(
            height: size.height>600? size.height /2.25:size.height /2.4,
            child: StreamBuilder(
                stream: balanceProvider.ingresogastMStream,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    _listI = snapshot.data[0];
                    _listG = snapshot.data[1];
                  } else {
                    _listI = [];
                    _listG = [];
                  }

                  return FlipInY(
                      duration: Duration(seconds: 1),
                      manualTrigger: true,
                      controller: (controller) =>
                          animateController = controller,
                      child: MyLineChart(_listI, _listG));
                }),
          ),
        ],
      ),
    );
  }

  _monthfilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _keyfilterForm,
        child: TextFormField(
          validator: validateName,
          enableInteractiveSelection: false,
          controller: _inputFieldFilter,
          decoration: InputDecoration(
            hintText: 'Mes',
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectMonth(context, _inputFieldFilter);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    balanceProvider.getBalance();
    balanceProvider.getIngGastbyAllMonth();
  }

  @override
  void dispose() {
    _inputFieldFilter.dispose();
    super.dispose();
  }

  String validateName(String value) {
    if (value.length == 0)
      return "Esta vacío";
    else
      return null;
  }
}
