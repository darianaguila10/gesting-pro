import 'package:flutter/material.dart';

import 'package:gesting/reporte_categoria/reporte-ingreso/repobyday.dart';
import 'package:gesting/reporte_categoria/reporte-ingreso/repobymonth.dart';
import 'package:gesting/reporte_categoria/reporte-ingreso/repobyyear.dart';

class ReporteIngCategoriaTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReporteIngCategoriaTabState();
  }
}

class ReporteIngCategoriaTabState extends State<ReporteIngCategoriaTab>
    with SingleTickerProviderStateMixin {
  static const String routeName = "/reporteingcategoriatab";
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
      bottomNavigationBar: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        elevation: 5,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.blue),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.remove,
              ),
              onPressed: () {
                Navigator.of(context)
                    .popAndPushNamed("/reportegastcategoriatab");
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Reportes por Ingresos"),
        bottom: TabBar(
          indicatorColor: (darkModeOn) ? Colors.blue : Colors.white,
          labelColor: (darkModeOn) ? Colors.blue : null,
          unselectedLabelColor: (darkModeOn) ? Colors.white54 : null,
          labelPadding: EdgeInsets.all(0),
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
      ),
      body: TabBarView(
        children: [RepoCategbyday(), RepoCategbyMonth(), RepoCategbyYear()],
        controller: _tabController,
      ),
    );
  }
}
