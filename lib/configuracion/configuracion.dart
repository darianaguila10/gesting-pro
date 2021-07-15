import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

import 'package:gesting/theme/themeService.dart';

class Setting extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();
  static const String routeName = "/setting";

  Setting({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        key: _scalffoldkey,
        appBar: AppBar(
          title: Text("Configuración"),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed("/moneda");
                },
                leading: Icon(
                  Icons.monetization_on,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text("Moneda"),
                subtitle:
                    Text("Establezca la moneda principal y la tasa de cambio"),
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed("/datos");
                },
                leading: Icon(Icons.import_export),
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text("Respaldo de datos"),
                subtitle: Text("Respalde y restablezca sus datos"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed("/categoriatab");
                },
                leading: Icon(Icons.category),
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text("Categorías"),
                subtitle: Text("Gestione sus categorías"),
              ),
              SizedBox(
                height: 0,
              ),
              ThemeSwitcher(
                  clipper: ThemeSwitcherCircleClipper(),
                  builder: (context) {
                    var themeName =
                        ThemeProvider.of(context).brightness == Brightness.light
                            ? 'dark'
                            : 'light';
                    return ListTile(
                      onTap: () {
                        changeTheme(themeName, context);
                      },
                      leading: Icon(Icons.brightness_4),
                      trailing: Switch(
                          activeColor: Colors.green[400],
                          value: themeName == 'light',
                          onChanged: (value) async {
                            changeTheme(themeName, context);
                          }),
                      title: Text("Tema oscuro"),
                      subtitle: Text("Activar o desactivar tema oscuro"),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void snackBar(String c, [Color color = Colors.green]) {
    _scalffoldkey.currentState.showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
            textColor: color, label: "aceptar", onPressed: () {}),
        duration: Duration(milliseconds: 2000),
        content: Text(c)));
  }

  Future<void> changeTheme(themeName, context) async {
    themeName = ThemeProvider.of(context).brightness == Brightness.light
        ? 'dark'
        : 'light';
    var service = await ThemeService.instance
      ..save(themeName);
    var theme = service.getByName(themeName);
    ThemeSwitcher.of(context).changeTheme(theme: theme);
  }
}
