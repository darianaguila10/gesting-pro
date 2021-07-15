import 'package:flutter/material.dart';
import 'package:gesting/database/models/categoria.dart';
import 'package:gesting/util/icons.dart';

typedef OnDeleted = void Function(Categoria index);
typedef OnUpdate = void Function(Categoria index);

class CategoriaWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scalffoldkey;
  final Categoria categoria;
  final OnDeleted onDeleted;
  final OnUpdate onUpdate;

  CategoriaWidget(
      this.categoria, this.onDeleted, this.onUpdate, this._scalffoldkey);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: InkWell(
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(left: BorderSide(color:categoria.color?? Colors.green, width: 4))),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                leading: getIcons(categoria.icon,categoria.color?? Colors.green),
                title: Text(
                  categoria.title[0].toUpperCase() +
                      categoria.title.substring(1),
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
          onTap: () {
            this.onUpdate(categoria);
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: Text("Eliminar Categoría"),
                    content: Text("Esta seguro de eliminar la categoría"),
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
                          onDeleted(categoria);
                          _scalffoldkey.currentState.showSnackBar(SnackBar(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                  textColor: Colors.green,
                                  label: "aceptar",
                                  onPressed: () {}),
                              duration: Duration(milliseconds: 2000),
                              content: Text("Se eliminó correctamente")));
                        },
                      )
                    ],
                  );
                });
          },
          borderRadius: BorderRadius.circular(10),
        ));
  }
}
