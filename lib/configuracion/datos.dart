import 'package:flutter/material.dart';
import 'package:gesting/datos/dao.dart';
import 'package:permission_handler/permission_handler.dart';

class Datos extends StatefulWidget {
  static const String routeName = "/datos";

  Datos({Key key}) : super(key: key);

  @override
  _DatosState createState() => _DatosState();
}

class _DatosState extends State<Datos> {
  PermissionStatus status;
  GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scalffoldkey,
      appBar: AppBar(
        title: Text("Respaldo de datos"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      title: Text("Ayuda"),
                      content: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "En esta pantalla usted podrá getionar sus datos:",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(Icons.file_upload),
                                      onPressed: () {},
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "En esta opción usted podrá importar sus datos desde los archivo 'db.json y category_db.json' ubicado en el directorio raiz del dispositivo ('/0/gesting/').",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(Icons.file_download),
                                      onPressed: () {},
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "En esta opción usted podrá exportar sus datos a los archivos 'db.json y category_db.json' ubicado en el directorio raiz del dispositivo ('/0/gesting/').",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(Icons.delete_forever),
                                      onPressed: () {},
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "En esta opción usted podrá eliminar todos sus datos de la base de datos (Ingresos, Gastos, Categorías).",
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Aceptar"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ));
              })
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            ListTile(
              onTap: () {
                if (status.isGranted) {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          title: Text("Importar datos"),
                          content:
                              Text("Esta seguro de importar todos los datos. Asegúrese de haber exportado los datos anteriormente."),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Aceptar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                importar();
                              },
                            )
                          ],
                        ));
                 
                } else {
                  snackBar("No tiene permiso", Colors.red);
                }
              },
              leading: Icon(Icons.file_upload),
              title: Text("Importar datos"),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              onTap: () {
                if (status.isGranted) {
                  exportar();
                } else {
                  snackBar("No tiene permiso", Colors.red);
                }
              },
              leading: Icon(Icons.file_download),
              title: Text("Exportar datos"),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      title: Text("Eliminar Todos"),
                      content: Text("Esta seguro de eliminar todos los datos"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Cancelar"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("Aceptar"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            borrar();
                          },
                        )
                      ],
                    ));
              },
              leading: Icon(Icons.delete_forever),
              title: Text("Borrar datos"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> exportar() async {
    String s = await exportDatos();

    if (s == '0') {
      snackBar("No hay elementos", Colors.red);
    } else if (s != null) {
      snackBar("Sus Datos fueron exportados correctamente en " + s);
    } else {
      snackBar("Hubo un error al exportar sus datos", Colors.red);
    }
  }

  Future<void> borrar() async {
    borrarTodo();

    snackBar("Sus Datos fueron borrados correctamente");
  }

  Future<void> importar() async {
    bool e = await importDatos();

    if (e) {
      snackBar("Sus Datos fueron importado correctamente");
    } else {
      snackBar("Hubo un error al importar sus datos", Colors.red);
    }
  }

  @override
  void initState() {
    iniciarP();
    super.initState();
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

  Future<void> iniciarP() async {
    await Permission.storage.request();
    status = await Permission.storage.status;
  }
}
