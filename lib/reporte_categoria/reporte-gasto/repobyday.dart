import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gesting/database/models/ingreso_gasto_categ.dart';
import 'package:gesting/provider/gasto_provider.dart';
import 'package:gesting/reporte_categoria/myPieChart.dart';
import 'package:gesting/reporte_categoria/reporte_cat_card.dart';

import 'package:intl/intl.dart';

class RepoCategbyday extends StatefulWidget {
  RepoCategbyday({Key key}) : super(key: key);

  @override
  _RepoCategbydayState createState() => _RepoCategbydayState();
}

class _RepoCategbydayState extends State<RepoCategbyday> {
  final gastoProvider = new GastoProvider();

  List<IngGastCategory> gastos = [];

  GlobalKey<FormState> _keyfilterForm = new GlobalKey();
  TextStyle estiloTexto = TextStyle(fontSize: 12, color: Colors.white);
  DateTime _fecha;

  TextEditingController _inputFieldFilter = new TextEditingController();
  double gastoTotal = 0;
  String title;

  AnimationController animateController;

  @override
  Widget build(BuildContext context) {
    gastoProvider.getGastoTotal();
    return Scaffold(
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
                     
                      gastoProvider.getGastCatByDay(_fecha);
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
                    gastoProvider.getGastbyCat();
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

  _selectDate(
      BuildContext context, TextEditingController _inputFieldDateC) async {
    DateTime _fechat = _fecha ?? DateTime.now();
    showDatePicker(
            context: context,
            initialDate: _fechat,
            firstDate: new DateTime(1995),
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
      stream: gastoProvider.gastoCatStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<IngGastCategory>> snapshot) {
        if (snapshot.hasData) {
          gastos = snapshot.data;
             calcularGastoTotal(gastos);
        } else {
          gastos = [];
        }
        if (gastos.length == 0)
          return Center(
            child: Text(
              "No hay elementos",
            ),
          );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                  height: size.height / 3.8,
                  child: FadeInUp(
                      duration: Duration(milliseconds: 500),
                      manualTrigger: true,
                      controller: (controller) =>
                          animateController = controller,
                      child: MyCatePieChart(gastos, gastoTotal))),
              SizedBox(height: 10),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: gastos.length,
                    itemBuilder: (BuildContext buildContext, index) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: ScaleAnimation(
                                  child: CatCardWidget(
                                      IngGastCategory(
                                          title: gastos[index].title,
                                          cant: gastos[index].cant,
                                          icon: gastos[index].icon,
                                          color: gastos[index].color),
                                      1))));
                    },
                  ),
                ),
              )
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
    gastoProvider.getGastos();
    gastoProvider.getGastbyCat();
  }

  String validateName(String value) {
    if (value.length == 0)
      return "Esta vac??o";
    else
      return null;
  }

  void calcularGastoTotal(List<IngGastCategory> gastos) {
    gastoTotal = 0;
    for (var item in gastos) {
      gastoTotal += item.cant;
    }
  }
}
