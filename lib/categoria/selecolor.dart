import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class SelectColor extends StatefulWidget {
  final categoria;

  SelectColor(this.categoria);

  @override
  _SelectColorState createState() => _SelectColorState();
}

class _SelectColorState extends State<SelectColor> {
  Color currentColor;

  @override
  void initState() {
    currentColor = (widget.categoria.color == null)
        ?Color(0xff4caf50)
        : widget.categoria.color;
    super.initState();
  }

  void changeColor(Color color) => setState(() => currentColor = color);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Row(children: <Widget>[
          Text("Color: "),
          Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 45,
                  child: RaisedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(2.0),
                                  topRight: const Radius.circular(2.0),
                                ),
                              ),
                            ),
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
                                  setState(() {
                                    widget.categoria.color = currentColor;
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );

                    },
                    color: widget.categoria.color,
                  ),
                ),
              )),
        ]));
  }
}
