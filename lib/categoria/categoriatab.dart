import 'package:flutter/material.dart';
import 'package:gesting/categoria/gastoscategory.dart';
import 'package:gesting/categoria/ingresocategory.dart';
import 'package:gesting/provider/categoria_provider.dart';

class CategoriaTabW extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoriaTabWState();
  }
}

GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();

class CategoriaTabWState extends State<CategoriaTabW>
    with SingleTickerProviderStateMixin {
  final categoriaProvider = new CategoriaProvider();
  static const String routeName = "/categoriatab";
  TabController _tabController;
bool firstload=true;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  int r = ModalRoute.of(context).settings.arguments;

    if (r != null&&firstload){ _tabController.animateTo(r);
    firstload=false;
    }

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });

    final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;
    return Scaffold(
      key: _scalffoldkey,
      appBar: AppBar(
          title: Text("Categorías"),
          bottom: TabBar(
            labelPadding: EdgeInsets.all(0),
            indicatorColor: (darkModeOn) ? Colors.green : Colors.white,
            labelColor: (darkModeOn) ? Colors.green : null,
            unselectedLabelColor: (darkModeOn) ? Colors.white54 : null,
            tabs: [
              new Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.add), Text(" Ingresos")],
                ),
              ),
              new Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.remove), Text(" Gastos")],
                ),
              ),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          bottomOpacity: 1,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        title: Text("Eliminar Todas"),
                        content: Text(
                            "Esta seguro de eliminar todas las categorías"),
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
                                bool r = await categoriaProvider
                                    .deleteAllCategoria();
                                if (r) {
                                  showSnackBar("Todas fueron eliminados");
                                } else {
                                  showSnackBar("No hay elementos", Colors.red);
                                }
                              })
                        ],
                      ));
                })
          ]),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [IngresosCategory(), GastosCategory()],
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
