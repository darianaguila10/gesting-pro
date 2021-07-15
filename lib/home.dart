import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


import 'package:gesting/widget/dial.dart';
import 'package:gesting/widget/drawer.dart';
import 'package:gesting/provider/balance_provider.dart';
import 'package:gesting/provider/gasto_provider.dart';
import 'package:gesting/provider/ingreso_provider.dart';
import 'package:gesting/widget/myPieChart.dart';
import 'package:gesting/widget/myTextItems.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double ingresosTotal = 0.0;
  double gastosTotal = 0.0;
  int touchedIndex;
  final ingresoProvider = new IngresoProvider();
  final gastoProvider = new GastoProvider();
  final balanceProvider = new BalanceProvider();

  AnimationController animateController;

  AnimationController banimateController;

  AnimationController ianimateController;

  AnimationController ganimateController;

 

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;

    ingresoProvider.getIngresoTotal();
    gastoProvider.getGastoTotal();
    balanceProvider.getBalance();
  
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: (!darkModeOn)? Color(0xffE5E5E5):null,
        drawer:  Mydrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: new AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          title: new Text("Gesting"),
          actions: <Widget>[
            PopupMenuButton<int>(
              onSelected: (i) {
                if (i == 0) Navigator.of(context).pushNamed("/setting");
                if (i == 1) Navigator.of(context).pushNamed("/acercade");
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<int>>[
                  PopupMenuItem(
                    value: 0,
                    child: Text('Configuración'),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text('Acerca de...'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Container(
          color:  (!darkModeOn)? Color(0xffE5E5E5):null,
          child: StaggeredGridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 12.0,
            padding: EdgeInsets.only(top: 10.0),
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                child: StreamBuilder(
                  stream: balanceProvider.balanceTotalStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<double>> snapshot) {
                    double val = 0;
                    if (snapshot.hasData) {
                      val = snapshot.data[0] - snapshot.data[1];
                    }
                    return ElasticIn(
                        duration: Duration(milliseconds: 1000),
                        manualTrigger: true,
                        controller: (controller) =>
                            banimateController = controller,
                        child: MyTextItems("Balance", val, Colors.green, ""));
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 12.0),
                  child: StreamBuilder(
                    stream: ingresoProvider.ingresoTotalStream,
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.hasData) {
                        ingresosTotal = snapshot.data;
                      } else {
                        ingresosTotal = 0.0;
                      }
                      return ElasticInLeft(
                        duration: Duration(milliseconds: 1000),
                        manualTrigger: true,
                        controller: (controller) =>
                            ianimateController = controller,
                        child: MyTextItems("Ingresos", ingresosTotal,
                            Colors.blue, "ingresotab"),
                      );
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, right: 12.0),
                child: StreamBuilder(
                  stream: gastoProvider.gastoTotalStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.hasData) {
                      gastosTotal = snapshot.data;
                    } else {
                      gastosTotal = 0.0;
                    }
                    return ElasticInRight(
                      duration: Duration(milliseconds: 1000),
                      manualTrigger: true,
                      controller: (controller) =>
                          ganimateController = controller,
                      child: MyTextItems(
                          "Gastos", gastosTotal, Colors.red[400], "gastotab"),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: StreamBuilder(
                  stream: balanceProvider.balanceTotalStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<double>> snapshot) {
                    double ing = 0;
                    double gast = 0;

                    if (snapshot.hasData) {
                      ing = snapshot.data[0];
                      gast = snapshot.data[1];
                    }
                    return BounceInDown(
                        duration: Duration(milliseconds: 1000),
                        manualTrigger: true,
                        controller: (controller) =>
                            animateController = controller,
                        child: MyPieChart(ing, gast));
                  },
                ),
              ),
            ],
            staggeredTiles: [
              StaggeredTile.extent(
                  4, size.height > 600 ? size.height / 7.5 : size.height / 7),
              StaggeredTile.extent(
                  2, size.height > 600 ? size.height / 7.5 : size.height / 7),
              StaggeredTile.extent(
                  2, size.height > 600 ? size.height / 7.5 : size.height / 7),
              StaggeredTile.extent(4, size.height / 2.01),
            ],
          ),
        ),
        floatingActionButton:  Dial());
  }

  @override
  void initState() {
    super.initState();
  }
}
