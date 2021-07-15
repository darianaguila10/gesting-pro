import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gesting/acercade/acercade.dart';
import 'package:gesting/categoria/categoriatab.dart';
import 'package:gesting/categoria/selecgastocategory.dart';
import 'package:gesting/categoria/selecingresocategory.dart';
import 'package:gesting/configuracion/configuracion.dart';
import 'package:gesting/configuracion/datos.dart';
import 'package:gesting/configuracion/moneda.dart';
import 'package:gesting/gasto/gastotab.dart';
import 'package:gesting/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gesting/ingreso/ingresotab.dart';
import 'package:gesting/preferencia/preferencia_moneda.dart';
import 'package:gesting/preferencia/preferenciasInit.dart';
import 'package:gesting/reporte/reportetab.dart';

import 'package:gesting/reporte_categoria/reporte-gasto/reporte_categoria_tab.dart';
import 'package:gesting/reporte_categoria/reporte-ingreso/reporte_categoria_tab.dart';
import 'package:gesting/test-data.dart';
import 'package:gesting/theme/themeService.dart';

import 'package:gesting/widget/initscreen.dart';
import 'package:permission_handler/permission_handler.dart';

final String DB_NAME = "MyBD";
final prefs = PreferenciaInit();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeServise = await ThemeService.instance;
  var initTheme = themeServise.initial;

  await Permission.storage.request();
  await Permission.sms.request();
  await Permission.phone.request();
  await prefs.iniPrefs();
  final prefsM = PreferenciaMoneda();
  await prefsM.iniPrefs();

  runApp(MyApp(theme: initTheme));
}

class MyApp extends StatelessWidget {
  MyApp({this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ThemeProvider(
      initTheme: theme,
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Gesting',
          localizationsDelegates: [
            // ... app-specific localization delegate[s] here
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('es', 'ES'),
          ],
          theme: ThemeProvider.of(context),
          initialRoute: prefs.isFirstTime() ? "/initscreen" : "/home",
          routes: <String, WidgetBuilder>{
            InitScreenState.routeName: (BuildContext context) =>
                new InitScreenW(),
            '/home': (BuildContext context) => MyHomePage(),
            IngresoTabWState.routeName: (BuildContext context) =>
                new IngresoTabW(),
            GastoTabWState.routeName: (BuildContext context) => new GastoTabW(),
            ReporteTabState.routeName: (BuildContext context) =>
                new ReporteTab(),
            Setting.routeName: (BuildContext context) => new Setting(),
            CoinState.routeName: (BuildContext context) => new Coin(),
            Datos.routeName: (BuildContext context) => new Datos(),
           
            AcercaDe.routeName: (BuildContext context) => new AcercaDe(),
            CategoriaTabWState.routeName: (BuildContext context) =>
                new CategoriaTabW(),
            ReporteGastCategoriaTab.routeName: (BuildContext context) =>
                new ReporteGastCategoriaTab(),
            ReporteIngCategoriaTabState.routeName: (BuildContext context) =>
                new ReporteIngCategoriaTab(),
            SelectIngresosCategoryState.routeName: (BuildContext context) =>
                new SelectIngresosCategory(),
            SelectGastosCategoryState.routeName: (BuildContext context) =>
                new SelectGastosCategory(),
            /*   "/testdata": (BuildContext context) => new Testdata(), */
          },
        );
      }),
    );
  }
}

class ReporteGastCategoriaTabState {}
