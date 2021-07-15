import 'package:flutter/material.dart';

import 'package:gesting/reporte/repobyday.dart';
import 'package:gesting/reporte/repobymonth.dart';
import 'package:gesting/reporte/repobyyear.dart';

class ReporteTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReporteTabState();
  }
}

GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();

class ReporteTabState extends State<ReporteTab>
    with SingleTickerProviderStateMixin {
  static const String routeName = "/reportetab";
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
        title: Text("Reportes totales"),
        bottom: TabBar(
          indicatorColor: (darkModeOn) ? Colors.green:Colors.white,
          labelColor: (darkModeOn) ? Colors.green:null,
          unselectedLabelColor: (darkModeOn) ? Colors.white54:null,
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
        children: [Repobyday(), Repobymonth(), Repobyyear()],
        controller: _tabController,
      ),
    );
  }
}
