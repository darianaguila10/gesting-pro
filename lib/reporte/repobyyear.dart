import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gesting/database/models/DataBar.dart';
import 'package:intl/intl.dart';
import 'package:gesting/provider/balance_provider.dart';
import 'package:gesting/reporte/mypanelcard.dart';
import 'package:gesting/widget/myBarChart.dart';

class Repobyyear extends StatefulWidget {
  Repobyyear({Key key}) : super(key: key);

  @override
  _RepobyyearState createState() => _RepobyyearState();
}

GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();

class _RepobyyearState extends State<Repobyyear> {
  final balanceProvider = new BalanceProvider();
  double ingresosTotal = 0.0;
  double gastosTotal = 0.0;
  List<DataBar> _listI = [];
  List<DataBar> _listG = [];

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
                  child: _yearfilter(),
                  flex: 3,
                ),
                Expanded(
                  child: FlatButton(
                    child: Icon(Icons.search),
                    onPressed: () {
                      if (_fecha != null) {
                        balanceProvider.getBalancebyyear(_fecha);
                        balanceProvider.getIngGastbyYear(_fecha);
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
                      balanceProvider.getIngGastbyAllYear();
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

  _selectYear(
      BuildContext context, TextEditingController _inputFieldDateC) async {
    DateTime _year = DateTime(DateTime.now().year);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width / 2,
              child: YearPicker(
                selectedDate: _year,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                onChanged: (date) {
                  if (date != null) {
                    setState(() {
                      _fecha = date;
                      _inputFieldDateC.text = DateFormat('yyyy').format(date);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ));
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

                return  Container(
                 height: size.height /4,child: MyPanelCard(ingresosTotal, gastosTotal));
              }),
      
          Container(
            height: size.height>600? size.height /2.25:size.height /2.4,
            child: StreamBuilder(
                stream: balanceProvider.ingresogastoYStream,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    _listI = snapshot.data[0];
                    _listG = snapshot.data[1];
                  } else {
                    _listI = [];
                    _listG = [];
                  }

                   
                  return FlipInX(duration: Duration(seconds: 1),
                      manualTrigger: true,
                      controller: (controller) =>
                          animateController = controller,child: MyBarChart(_listI, _listG));
                }),
          ),
        ],
      ),
    );
  }

  _yearfilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _keyfilterForm,
        child: TextFormField(
          validator: validateName,
          enableInteractiveSelection: false,
          controller: _inputFieldFilter,
          decoration: InputDecoration(
            hintText: 'Año',
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectYear(context, _inputFieldFilter);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    balanceProvider.getBalance();
    balanceProvider.getIngGastbyAllYear();
  }

  @override
  void dispose() {
    super.dispose();
    _inputFieldFilter.dispose();
  }

  String validateName(String value) {
    if (value.length == 0)
      return "Esta vacío";
    else
      return null;
  }
}
