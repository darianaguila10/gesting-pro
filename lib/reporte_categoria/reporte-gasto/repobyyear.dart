import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:gesting/database/models/ingreso_gasto_categ.dart';
import 'package:gesting/provider/gasto_provider.dart';
import 'package:gesting/reporte_categoria/myPieChart.dart';
import 'package:gesting/reporte_categoria/reporte_cat_card.dart';

import 'package:intl/intl.dart';

class RepoCategbyYear extends StatefulWidget {
  RepoCategbyYear({Key key}) : super(key: key);

  @override
  _RepoCategbyYearState createState() => _RepoCategbyYearState();
}

class _RepoCategbyYearState extends State<RepoCategbyYear> {
  final gastoProvider = new GastoProvider();

  List<IngGastCategory> gastos = [];

  GlobalKey<FormState> _keyfilterForm = new GlobalKey();
  TextStyle estiloTexto = TextStyle(fontSize: 12, color: Colors.white);
  DateTime _fecha;

  TextEditingController _inputFieldFilter = new TextEditingController();

  String title;
  double gastoTotal = 0;
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
                child: _yearfilter(),
                flex: 3,
              ),
              Expanded(
                child: FlatButton(
                  child: Icon(Icons.search),
                  onPressed: () {
                    if (_fecha != null) {
                      gastoProvider.getGastCatByYear(_fecha);
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

  _selectYear(
      BuildContext context, TextEditingController _inputFieldDateC) async {
    DateTime _year = DateTime(DateTime.now().year);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width / 2,
              child: YearPicker(
                selectedDate: _year,
                firstDate: new DateTime(1995),
                lastDate: new DateTime(2100),
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
            hintText: 'A??o',
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
