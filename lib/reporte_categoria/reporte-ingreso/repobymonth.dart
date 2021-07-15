import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:gesting/database/models/ingreso_gasto_categ.dart';
import 'package:gesting/provider/ingreso_provider.dart';
import 'package:gesting/reporte_categoria/myPieChart.dart';
import 'package:gesting/reporte_categoria/reporte_cat_card.dart';

import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class RepoCategbyMonth extends StatefulWidget {
  RepoCategbyMonth({Key key}) : super(key: key);

  @override
  _RepoCategbyMonthState createState() => _RepoCategbyMonthState();
}

class _RepoCategbyMonthState extends State<RepoCategbyMonth> {
  final ingresoProvider = new IngresoProvider();

  List<IngGastCategory> ingresos = [];

  GlobalKey<FormState> _keyfilterForm = new GlobalKey();
  TextStyle estiloTexto = TextStyle(fontSize: 12, color: Colors.white);
  DateTime _fecha;

  TextEditingController _inputFieldFilter = new TextEditingController();

  String title;
  double ingresoTotal = 0;
  AnimationController animateController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      ingresoProvider.getIngCatByMonth(_fecha);
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
                    ingresoProvider.getIngbyCat();
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
       firstDate: new DateTime(1995),
      lastDate:  new DateTime(2100),
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
    return StreamBuilder(
      stream: ingresoProvider.ingresoCatStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<IngGastCategory>> snapshot) {
        if (snapshot.hasData) {
          ingresos = snapshot.data;
      calcularIngresoTotal(ingresos);
        } else {
          ingresos = [];
        }
        if (ingresos.length == 0)
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
                      child: MyCatePieChart(ingresos, ingresoTotal))),
              SizedBox(height: 10),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: ingresos.length,
                    itemBuilder: (BuildContext buildContext, index) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: ScaleAnimation(
                                  child: CatCardWidget(
                                      IngGastCategory(
                                          title: ingresos[index].title,
                                          cant: ingresos[index].cant,
                                          icon: ingresos[index].icon,
                                          color: ingresos[index].color),
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
  void dispose() {
    super.dispose();
    _inputFieldFilter.dispose();
  }

  @override
  void initState() {
    super.initState();
    ingresoProvider.getIngresos();
    ingresoProvider.getIngbyCat();
  }

  String validateName(String value) {
    if (value.length == 0)
      return "Esta vacío";
    else
      return null;
  }

  void calcularIngresoTotal(List<IngGastCategory> ingresos) {
    ingresoTotal = 0;
    for (var item in ingresos) {
      ingresoTotal += item.cant;
    }
    print(ingresoTotal);
  }
}
