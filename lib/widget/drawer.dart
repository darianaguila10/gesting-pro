import 'package:flutter/material.dart';

import 'package:gesting/notification/notification.dart';

class Mydrawer extends StatefulWidget {
  Mydrawer({Key key}) : super(key: key);

  @override
  _MydrawerState createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
 
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;
    return _getDrawer(darkModeOn);
  }

  Drawer _getDrawer(darkModeOn) {
    return new Drawer(
      // Agrega un ListView al drawer. Esto asegura que el usuario pueda desplazarse
      // a través de las opciones en el Drawer si no hay suficiente espacio vertical
      // para adaptarse a todo.
      child: ListView(
        // Importante: elimine cualquier padding del ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  color: (!darkModeOn) ? Color(0xFF66AD69) : Color(0xFF3f3b3b)),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      (!darkModeOn)
                          ? "assets/images/logo.png"
                          : "assets/images/logod.png",
                      height: 90,
                      width: 90,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Gesting Pro',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )
                  ],
                ),
              )),
          ListTile(
            leading: Icon(Icons.home, color: Colors.green),
            title: Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(
            height: 5,
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.add, color: Colors.blue),
            title: Text('Ingresos'),
            onTap: () {
              setState(() {
                Navigator.of(context).popAndPushNamed("/ingresotab");
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.remove, color: Colors.red),
            title: Text('Gastos'),
            onTap: () {
              setState(() {
                Navigator.of(context).popAndPushNamed("/gastotab");
              });
            },
          ),
          Divider(
            height: 5,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Text(
              'Reportes',
              style: TextStyle(color: Color(0xFF7E7878)),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.equalizer,
              color: Colors.orange,
            ),
            title: Text('Reportes totales'),
            onTap: () {
              Navigator.of(context).popAndPushNamed("/reportetab");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.pie_chart,
              color: Colors.deepOrangeAccent,
            ),
            title: Text('Reportes por categorías'),
            onTap: () {
            
                Navigator.of(context)
                    .popAndPushNamed("/reporteingcategoriatab");
           
            },
          ),
          Divider(
            height: 5,
            color: Colors.grey,
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              Navigator.of(context).popAndPushNamed("/setting");
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Acerca de...'),
            onTap: () {
              setState(() {
                Navigator.of(context).popAndPushNamed("/acercade");
              });
            },
          ),
        ],
      ),
    );
  }
}
