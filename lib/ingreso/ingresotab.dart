import 'package:flutter/material.dart';

import 'package:gesting/ingreso/groupbyday.dart';

import 'package:gesting/ingreso/groupbymonth.dart';
import 'package:gesting/ingreso/groupbyyear.dart';
import 'package:gesting/notification/notification.dart';
import 'package:gesting/provider/ingreso_provider.dart';

class IngresoTabW extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IngresoTabWState();
  }
}

GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();

class IngresoTabWState extends State<IngresoTabW>
    with SingleTickerProviderStateMixin {
  final ingresoProvider = new IngresoProvider();
  static const String routeName = "/ingresotab";
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;
    return Scaffold(
      key: _scalffoldkey,
      appBar: AppBar(
          title: Text("Ingresos"),
          bottom: TabBar(
            labelPadding: EdgeInsets.all(0),
            indicatorColor: (darkModeOn) ? Colors.blue : Colors.white,
            labelColor: (darkModeOn) ? Colors.blue : null,
            unselectedLabelColor: (darkModeOn) ? Colors.white54 : null,
            tabs: [
              new Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.today), Text(" Diario")],
                ),
              ),
              new Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.date_range), Text(" Mensual")],
                ),
              ),
              new Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.event_note), Text(" Anual")],
                ),
              )
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          bottomOpacity: 1,
          actions: <Widget>[   IconButton(
                icon: Icon(Icons.pie_chart),
                onPressed: () {
                  
                       Navigator.of(context).pushNamed("/reporteingcategoriatab");
                 
              
                }),
            IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        title: Text("Eliminar Todos"),
                        content:
                            Text("Esta seguro de eliminar todos los ingresos"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Cancelar"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                              child: Text("Aceptar"),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                bool r =
                                    await ingresoProvider.deleteAllIngreso();
                                if (r) {
                                  showSnackBar("Todos fueron eliminados");
                                } else {
                                  showSnackBar("No hay elementos", Colors.red);
                                }
                              })
                        ],
                      ));
                }),
         
          ]),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [Groupbyday(), Groupbymonth(), Groupbyyear()],
        controller: _tabController,
      ),
    );
  }

  void showSnackBar(String c, [Color color = Colors.green]) {
    _scalffoldkey.currentState.showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
            textColor: color, label: "aceptar", onPressed: () {}),
        duration: Duration(milliseconds: 2000),
        content: Text(c)));
  }
}
