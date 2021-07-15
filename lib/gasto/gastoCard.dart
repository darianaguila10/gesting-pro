import 'package:flutter/material.dart';
import 'package:gesting/database/models/gasto.dart';
import 'package:gesting/util/converter.dart';
import 'package:gesting/util/icons.dart';

typedef OnDeleted = void Function(Gasto index);
typedef OnUpdate = void Function(Gasto index);

class GastoWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scalffoldkey;
  final Gasto gasto;
  final OnDeleted onDeleted;
  final OnUpdate onUpdate;

  final int icon;
  final Color color;


  GastoWidget(
      this.gasto, this.onDeleted, this.onUpdate, this._scalffoldkey, this.icon,this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: InkWell(
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(left: BorderSide(color: color, width: 4))),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                leading:getIcons(icon,color),
                title: Text(
                  gasto.title[0].toUpperCase() + gasto.title.substring(1),
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Text(
                  formatearMoneda(gasto.cant) + " " + gasto.moneda,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          onTap: () {
            this.onUpdate(gasto);
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: Text("Eliminar Producto"),
                    content: Text("Esta seguro de eliminar el producto"),
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
                          onDeleted(gasto);
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
