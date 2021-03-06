import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gesting/database/models/categoria.dart';

import 'package:gesting/notification/notification.dart';
import 'package:gesting/provider/categoria_provider.dart';
import 'package:gesting/validacion/validate.dart';
import 'package:intl/intl.dart';
import 'package:gesting/provider/gasto_provider.dart';
import 'package:gesting/util/converter.dart';
import 'package:gesting/database/models/gasto.dart';
import 'package:group_list_view/group_list_view.dart';
import "package:collection/collection.dart";
import 'package:gesting/gasto/gastoCard.dart';

class Groupbyday extends StatefulWidget {
  Groupbyday({Key key}) : super(key: key);

  @override
  _GroupbydayState createState() => _GroupbydayState();
}

GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();

class _GroupbydayState extends State<Groupbyday> {


  final gastoProvider = new GastoProvider();
  final categoriaProvider = new CategoriaProvider();
  bool _validateFC = false;
  bool _validateFU = false;

  List<String> matches;
  GlobalKey<FormState> _keyCreateForm = new GlobalKey();
  GlobalKey<FormState> _keyUpdateForm = new GlobalKey();
  GlobalKey<FormState> _keyCloneForm = new GlobalKey();
  GlobalKey<FormState> _keyfilterForm = new GlobalKey();
  TextStyle estiloTexto = TextStyle(fontSize: 12, color: Colors.white);
  DateTime _fecha;
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldDateEdController =
      new TextEditingController();
  TextEditingController _inputFieldFilter = new TextEditingController();
  TextEditingController searchcont = new TextEditingController();
  ScrollController itemScroll = ScrollController();
  String title;
  Map<DateTime, List> element;
  List<Gasto> _list;
  List<Categoria> _listCategories;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;
    itemScroll.addListener(() {
      if (itemScroll.position.pixels >= itemScroll.position.maxScrollExtent) {
        gastoProvider.cargasMasGastos();
      }
    });
    return Scaffold(
        key: _scalffoldkey,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _dayfilter(),
                  flex: 3,
                ),
                Expanded(
                  child: FlatButton(
                    child: Icon(Icons.search),
                    onPressed: () {
                      searchcont.clear();
                      if (itemScroll.hasClients) itemScroll.position.jumpTo(0);
                      _keyfilterForm.currentState.save();
                    },
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    child: Icon(Icons.close),
                    onPressed: () {
                      searchcont.clear();
                      _inputFieldFilter.clear();
                      if (itemScroll.hasClients) itemScroll.position.jumpTo(0);
                      _fecha = null;
                      gastoProvider.getGastos();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _getBody())
        ]),
        floatingActionButton: FloatingActionButton(
            backgroundColor: (darkModeOn) ?Colors.red[400] : null,
            onPressed: () {
              insert(context);
            },
            child: Icon(Icons.add)));
  }

  _selectDate(
      BuildContext context, TextEditingController _inputFieldDateC) async {
    DateTime _fechaT = _inputFieldDateC.text != ""
        ? DateFormat('d-MMMM-yyyy', 'es').parse(_inputFieldDateC.text)
        : DateTime.now();
    showDatePicker(
            context: context,
            initialDate: _fechaT,
            firstDate: new DateTime(1995),
            lastDate: new DateTime(2100),
            locale: Locale('es', 'ES'))
        .then((date) {
      if (date != null) {
        setState(() {
          _fecha = date;
          _inputFieldDateC.text = DateFormat('d-MMMM-yyyy', 'es').format(date);
        });
      }
    });
  }

  void insert(BuildContext context) {
    final TextEditingController _inputFieldCategory = TextEditingController();
    List<String> lisM = ["CUP", "CUC", "USD", "EUR"];
    String _value = lisM[0];
    Gasto nNombre = new Gasto();
    _inputFieldDateController.text =
        DateFormat('d-MMMM-yyyy', 'es').format(DateTime.now());
    _fecha = DateTime.now();
    ScrollController sc = ScrollController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Nuevo Gasto"),
            content: SingleChildScrollView(
                controller: sc,
                child: Container(
                  child: Form(
                      key: _keyCreateForm,
                      autovalidate: _validateFC,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _inputFieldCategory,
                            validator: validateCreate,
                            maxLength: 25,
                            onSaved: (value) {
                              nNombre.title = value;
                            },
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              Navigator.of(context)
                                  .pushNamed("/selectgastcategoria")
                                  .then((onValue) {
                                Categoria c = onValue;
                                actualizar();
                                if (c != null) {
                                  _inputFieldCategory.text = c.title;
                                }
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                labelText: "Categor??a",
                                icon: Icon(Icons.category)),
                          ),
                          TextFormField(
                            inputFormatters: validateForm(),
                            validator: validateCreate,
                            maxLength: 10,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onSaved: (value) {
                              nNombre.cant = double.parse(value);
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                labelText: "Cantidad",
                                icon: Icon(Icons.attach_money)),
                          ),
                          TextFormField(
                            validator: validateName,
                            enableInteractiveSelection: false,
                            controller: _inputFieldDateController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                hintText: 'Fecha',
                                labelText: 'Fecha',
                                icon: Icon(Icons.calendar_today)),
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _selectDate(context, _inputFieldDateController);
                            },
                            onSaved: (value) {
                              nNombre.fecha = _fecha;
                            },
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                icon: Icon(Icons.monetization_on)),
                            hint: Text('Moneda'),
                            value: _value,
                            items: lisM.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                              });
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            onSaved: (value) {
                              nNombre.moneda = value;
                            },
                          ),
                          TextFormField(
                            maxLines: 4,
                            maxLength: 100,
                            onSaved: (value) {
                              nNombre.descripcion = value;
                            },
                            autofocus: false,
                            onTap: () {
                              Timer(
                                  Duration(milliseconds: 300),
                                  () => sc.animateTo(
                                      sc.position.maxScrollExtent,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.fastOutSlowIn));
                            },
                            decoration: InputDecoration(
                                labelText: "Descripci??n",
                                icon: Icon(Icons.description)),
                          ),
                        ],
                      )),
                )),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Guardar"),
                onPressed: () {
                  createGasto(nNombre);
                },
              ),
            ],
          );
        });
  }

  void onDeletedRequest(Gasto gasto) {
    gastoProvider.deleteGasto(gasto);
  }

  void onUpdateRequest(Gasto gasto) {
    ScrollController sc = ScrollController();
    List<String> lisM = ["CUP", "CUC", "USD", "EUR"];
    String _value = gasto.moneda;
    final tcontroller = TextEditingController(text: gasto.title);
    final ccontroller =
        TextEditingController(text: formatMonedaForm(gasto.cant));
    _inputFieldDateEdController.text =
        DateFormat('d-MMMM-yyyy', 'es').format(gasto.fecha);
    _fecha = gasto.fecha;
    final dcontroller = TextEditingController(text: gasto.descripcion);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Modificar Gasto"),
                IconButton(
                    icon: Icon(
                      Icons.content_copy,
                      size: 22,
                    ),
                    onPressed: () {
                 
                        Navigator.of(context).pop();
                        onClone(gasto);
                    
                    })
              ],
            ),
            content: SingleChildScrollView(
                controller: sc,
                child: Container(
                  child: Form(
                      key: _keyUpdateForm,
                      autovalidate: _validateFU,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: tcontroller,
                            validator: validateCreate,
                            maxLength: 25,
                            onSaved: (value) {
                              gasto.title = value;
                            },
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              Navigator.of(context)
                                  .pushNamed("/selectgastcategoria")
                                  .then((onValue) {
                                Categoria c = onValue;
                                actualizar();
                                if (c != null) {
                                  tcontroller.text = c.title;
                                }
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                labelText: "Categor??a",
                                icon: Icon(Icons.category)),
                          ),
                          TextFormField(
                            inputFormatters: validateForm(),
                            controller: ccontroller,
                            maxLength: 10,
                            validator: validateCreate,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onSaved: (value) {
                              gasto.cant = double.parse(value);
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                labelText: "Cantidad:",
                                icon: Icon(Icons.attach_money)),
                          ),
                          TextFormField(
                            validator: validateName,
                            enableInteractiveSelection: false,
                            controller: _inputFieldDateEdController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                hintText: 'Fecha',
                                labelText: 'Fecha',
                                icon: Icon(Icons.calendar_today)),
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _selectDate(context, _inputFieldDateEdController);
                            },
                            onSaved: (value) {
                              gasto.fecha = _fecha;
                            },
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                icon: Icon(Icons.monetization_on)),
                            hint: Text('Moneda'),
                            value: _value,
                            items: lisM.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                              });
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            onSaved: (value) {
                              gasto.moneda = value;
                            },
                          ),
                          TextFormField(
                            controller: dcontroller,
                            maxLines: 4,
                            onTap: () {
                              Timer(
                                  Duration(milliseconds: 300),
                                  () => sc.animateTo(
                                      sc.position.maxScrollExtent,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.fastOutSlowIn));
                            },
                            maxLength: 100,
                            onSaved: (value) {
                              gasto.descripcion = value;
                            },
                            decoration: InputDecoration(
                                labelText: "Descripci??n",
                                icon: Icon(Icons.description)),
                          ),
                        ],
                      )),
                )),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
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
                                onDeletedRequest(gasto);
                                _scalffoldkey.currentState.showSnackBar(
                                    SnackBar(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        behavior: SnackBarBehavior.floating,
                                        action: SnackBarAction(
                                            textColor: Colors.green,
                                            label: "aceptar",
                                            onPressed: () {}),
                                        duration: Duration(milliseconds: 2000),
                                        content:
                                            Text("Se elimin?? correctamente")));
                              },
                            )
                          ],
                        );
                      });
                },
              ),
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Actualizar"),
                onPressed: () {
                  updateGasto(gasto);
                },
              ),
            ],
          );
        });
  }

  void onClone(Gasto gasto) {
    gasto.id = null;
    ScrollController sc = ScrollController();
    List<String> lisM = ["CUP", "CUC", "USD", "EUR"];
    String _value = gasto.moneda;
    final tcontroller = TextEditingController(text: gasto.title);
    final ccontroller =
        TextEditingController(text: formatMonedaForm(gasto.cant));
    _inputFieldDateEdController.text =
        DateFormat('d-MMMM-yyyy', 'es').format(gasto.fecha);
    _fecha = gasto.fecha;
    final dcontroller = TextEditingController(text: gasto.descripcion);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Copiar Gasto"),
            content: SingleChildScrollView(
                controller: sc,
                child: Container(
                  child: Form(
                      key: _keyCloneForm,
                      autovalidate: _validateFU,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: tcontroller,
                            validator: validateCreate,
                            maxLength: 25,
                            onSaved: (value) {
                              gasto.title = value;
                            },
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              Navigator.of(context)
                                  .pushNamed("/selectgastcategoria")
                                  .then((onValue) {
                                Categoria c = onValue;
                                actualizar();
                                if (c != null) {
                                  tcontroller.text = c.title;
                                }
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                labelText: "Categor??a",
                                icon: Icon(Icons.category)),
                          ),
                          TextFormField(
                            inputFormatters: validateForm(),
                            controller: ccontroller,
                            maxLength: 10,
                            validator: validateCreate,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onSaved: (value) {
                              gasto.cant = double.parse(value);
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                labelText: "Cantidad:",
                                icon: Icon(Icons.attach_money)),
                          ),
                          TextFormField(
                            validator: validateName,
                            enableInteractiveSelection: false,
                            controller: _inputFieldDateEdController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                hintText: 'Fecha',
                                labelText: 'Fecha',
                                icon: Icon(Icons.calendar_today)),
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _selectDate(context, _inputFieldDateEdController);
                            },
                            onSaved: (value) {
                              gasto.fecha = _fecha;
                            },
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                icon: Icon(Icons.monetization_on)),
                            hint: Text('Moneda'),
                            value: _value,
                            items: lisM.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                              });
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            onSaved: (value) {
                              gasto.moneda = value;
                            },
                          ),
                          TextFormField(
                            controller: dcontroller,
                            maxLines: 4,
                            onTap: () {
                              Timer(
                                  Duration(milliseconds: 300),
                                  () => sc.animateTo(
                                      sc.position.maxScrollExtent,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.fastOutSlowIn));
                            },
                            maxLength: 100,
                            onSaved: (value) {
                              gasto.descripcion = value;
                            },
                            decoration: InputDecoration(
                                labelText: "Descripci??n",
                                icon: Icon(Icons.description)),
                          ),
                        ],
                      )),
                )),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Guardar"),
                onPressed: () {
                  cloneGasto(gasto);
                },
              ),
            ],
          );
        });
  }

  Widget _getBody() {
    return StreamBuilder(
        stream: gastoProvider.gastosStream,
        builder: (BuildContext context, AsyncSnapshot<List<Gasto>> snapshot) {
          if (snapshot.hasData) {
            _list = snapshot.data;
            element = groupBy(_list, (obj) => obj.fecha);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_list.length == 0) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Center(child: Text("No hay elementos")),
            );
          }
          List key = element.keys.toList();
          return GroupListView(
            controller: itemScroll,
            sectionsCount: key.length,
            countOfItemInSection: (int section) {
              return element.values.toList()[section].length;
            },
            itemBuilder: _itemBuilder,
            groupHeaderBuilder: (BuildContext context, int section) {
              DateTime d = key[section];
              return Container(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.6),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        '${d.day} ${DateFormat('MMMM', "es").format(d)} ${d.year}',
                        style: estiloTexto,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 10),
            sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
          );
        });
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {
    Gasto i = element.values.toList()[index.section][index.index];
    Categoria c = buscarCategoria(i.title);
    int icon = c.icon;
    return GastoWidget(
        i, onDeletedRequest, onUpdateRequest, _scalffoldkey, icon, c.color);
  }

  _dayfilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _keyfilterForm,
        child: TextFormField(
          validator: validateName,
          enableInteractiveSelection: false,
          controller: _inputFieldFilter,
          decoration: InputDecoration(
            hintText: 'Fecha',
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectDate(context, _inputFieldFilter);
          },
          onSaved: (value) {
            if (_inputFieldFilter.text.length != 0) {
              gastoProvider.searchGastosbyday(_fecha);
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    categoriaProvider.getCategorias("gasto").then((v) {
      _listCategories = v;
      gastoProvider.getGastos();
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchcont.dispose();
    _inputFieldFilter.dispose();
  }

  String validateName(String value) {
    if (value.length == 0)
      return "Esta vac??o";
    else
      return null;
  }

  void createGasto(Gasto nNombre) {
    if (_keyCreateForm.currentState.validate()) {
      _keyCreateForm.currentState.save();
      Navigator.of(context).pop();

      createCategoria(nNombre.title);

      gastoProvider.addGasto(nNombre);
    } else {
      setState(() {
        _validateFC = true;
      });
    }
  }

  void updateGasto(Gasto nNombre) {
    if (_keyUpdateForm.currentState.validate()) {
      _keyUpdateForm.currentState.save();
      Navigator.of(context).pop();
      createCategoria(nNombre.title);
      gastoProvider.updateGasto(nNombre);
    } else {
      setState(() {
        _validateFU = true;
      });
    }
  }

  void cloneGasto(Gasto nNombre) {
    if (_keyCloneForm.currentState.validate()) {
      _keyCloneForm.currentState.save();
      Navigator.of(context).pop();

      createCategoria(nNombre.title);

      gastoProvider.addGasto(nNombre);
    } else {
      setState(() {
        _validateFC = true;
      });
    }
  }

  String validateCreate(String value) {
    if (value.length == 0) return "Esta vac??o";

    return null;
  }

  List<String> getSuggestions(String query) {
    matches = List();

    matches.addAll(_listCategories.map((v) {
      return v.title;
    }).toList());

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  void actualizar() {
    categoriaProvider.getCategorias("gasto").then((v) {
      _listCategories = v;
    });
  }

  createCategoria(String title) async {
    int indixe = _listCategories
        .indexWhere((s) => s.title.toLowerCase() == title.toLowerCase());
    if (indixe == -1) {
      await categoriaProvider.addCategoria(
          Categoria(
              title: title, type: "gasto", icon: 0, color: Color(0xff4caf50)),
          "gasto");

      showCustomSnackBar("Se ha creado una nueva categor??a", _scalffoldkey);
    }
  }

  Categoria buscarCategoria(String categoria) {
    Map m = {};
    m = categoriaProvider.getCategoriasMap();
    Categoria c;

    List lc = [];
    if (m != null) lc = m[categoria];
    if (lc != null) c = m[categoria][0];
    if (c != null)
      return Categoria(icon: c.icon, color: c.color);
    else
      return Categoria(icon: 0, color: Color(0xff4caf50));
  }
}
