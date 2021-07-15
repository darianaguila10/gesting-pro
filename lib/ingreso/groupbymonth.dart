import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gesting/database/models/categoria.dart';
import 'package:gesting/notification/notification.dart';
import 'package:gesting/provider/categoria_provider.dart';
import 'package:gesting/util/icons.dart';
import 'package:gesting/validacion/validate.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import 'package:gesting/provider/ingreso_provider.dart';
import 'package:gesting/util/converter.dart';
import "package:collection/collection.dart";
import 'package:gesting/database/models/ingreso.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:gesting/ingreso/ingresoCard.dart';

class Groupbymonth extends StatefulWidget {
  Groupbymonth({Key key}) : super(key: key);

  @override
  _GroupbymonthState createState() => _GroupbymonthState();
}

GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();

class _GroupbymonthState extends State<Groupbymonth> {
  final ingresoProvider = new IngresoProvider();
  final categoriaProvider = new CategoriaProvider();
  bool _validateFC = false;
  bool _validateFU = false;
  GlobalKey<FormState> _keyCreateForm = new GlobalKey();
  GlobalKey<FormState> _keyUpdateForm = new GlobalKey();GlobalKey<FormState> _keyCloneForm = new GlobalKey();
  GlobalKey<FormState> _keyfilterForm = new GlobalKey();
  TextStyle estiloTexto = TextStyle(fontSize: 12, color: Colors.white);
  DateTime _fecha;
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldDateEdController =
      new TextEditingController();
  TextEditingController _inputFieldFilter = new TextEditingController();
  String title;
  TextEditingController searchcont = new TextEditingController();
  List<Ingreso> _list;
  List<Categoria> _listCategories;
  Map<DateTime, List> element;
  List<String> matches;
  ScrollController itemScroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;
    itemScroll.addListener(() {
      if (itemScroll.position.pixels >= itemScroll.position.maxScrollExtent) {
        ingresoProvider.cargasMasIngresos();
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
                  child: _monthfilter(),
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
                      ingresoProvider.getIngresos();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _getBody())
        ]),
        floatingActionButton: FloatingActionButton(
            backgroundColor: (darkModeOn) ? Colors.blue : null,
            onPressed: () {
              insert(context);
            },
            child: Icon(Icons.add)));
  }

  _selectMonth(
      BuildContext context, TextEditingController _inputFieldDateC) async {
    DateTime _fechaT = _inputFieldDateC.text != ""
        ? DateFormat('MMMM-yyyy', 'es').parse(_inputFieldDateC.text)
        : DateTime.now();
    showMonthPicker(
      context: context,
       firstDate: new DateTime(1995),
      lastDate:  new DateTime(2100),
      initialDate: _fechaT,
      locale: Locale("es"),
    ).then((date) {
      if (date != null) {
        setState(() {
          _fecha = date;
          _inputFieldDateC.text = DateFormat('MMMM-yyyy', 'es').format(date);
        });
      }
    });
  }

  _selectDate(
      BuildContext context, TextEditingController _inputFieldDateC) async {
    showDatePicker(
            context: context,
            initialDate: _fecha,
              firstDate: new DateTime(1995),
      lastDate:  new DateTime(2100),
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
    Ingreso nNombre = new Ingreso();
    _inputFieldDateController.text =
        DateFormat('d-MMMM-yyyy', 'es').format(DateTime.now());
    _fecha = DateTime.now();      ScrollController sc=ScrollController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Nuevo Ingreso"),
            content: SingleChildScrollView(controller: sc,
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
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Navigator.of(context)
                              .pushNamed("/selectingcategoria")
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
                            labelText: "Categoría",
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
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _selectDate(context, _inputFieldDateController);
                        },
                        onSaved: (value) {
                          nNombre.fecha = _fecha;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            InputDecoration(icon: Icon(Icons.monetization_on)),
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
                          FocusScope.of(context).requestFocus(new FocusNode());
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
                       onTap: (){
                          Timer( Duration(milliseconds: 300), ()=>sc.animateTo(sc.position.maxScrollExtent,duration: Duration(milliseconds: 300) ,curve: Curves.fastOutSlowIn));
                       
                        },
                        decoration: InputDecoration(
                            labelText: "Descripción",
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
                  createIngreso(nNombre);
                },
              ),
            ],
          );
        });
  }

  void onDeletedRequest(Ingreso ingreso) {
    ingresoProvider.deleteIngreso(ingreso);
  }

  void cloneIngreso(Ingreso nNombre) {
    if (_keyCloneForm.currentState.validate()) {
      _keyCloneForm.currentState.save();
      Navigator.of(context).pop();

      createCategoria(nNombre.title);

      ingresoProvider.addIngreso(nNombre);
    } else {
      setState(() {
        _validateFC = true;
      });
    }
  }
  void onUpdateRequest(Ingreso ingreso) {
    List<String> lisM = ["CUP", "CUC", "USD", "EUR"];
    String _value = ingreso.moneda;
    final tcontroller = TextEditingController(text: ingreso.title);
    final ccontroller =
        TextEditingController(text: formatMonedaForm(ingreso.cant));
    _inputFieldDateEdController.text =
        DateFormat('d-MMMM-yyyy', 'es').format(ingreso.fecha);
    _fecha = ingreso.fecha;
    final dcontroller = TextEditingController(text: ingreso.descripcion);
      ScrollController sc=ScrollController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Modificar Ingreso"),
                IconButton(
                    icon: Icon(
                      Icons.content_copy,
                      size: 22,
                    ),
                    onPressed: () {
                     
                        Navigator.of(context).pop();
                        onClone(ingreso);
                 
                    })
              ],
            ),
            content: SingleChildScrollView(controller: sc,
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
                          ingreso.title = value;
                        },
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Navigator.of(context)
                              .pushNamed("/selectingcategoria")
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
                            labelText: "Categoría",
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
                          ingreso.cant = double.parse(value);
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
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _selectDate(context, _inputFieldDateEdController);
                        },
                        onSaved: (value) {
                          ingreso.fecha = _fecha;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            InputDecoration(icon: Icon(Icons.monetization_on)),
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
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        onSaved: (value) {
                          ingreso.moneda = value;
                        },
                      ),
                      TextFormField(
                        controller: dcontroller,
                        maxLines: 4, onTap: (){
                          Timer( Duration(milliseconds: 300), ()=>sc.animateTo(sc.position.maxScrollExtent,duration: Duration(milliseconds: 300) ,curve: Curves.fastOutSlowIn));
                       
                        },
                        maxLength: 100,
                        onSaved: (value) {
                          ingreso.descripcion = value;
                        },
                        decoration: InputDecoration(
                            labelText: "Descripción",
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
                                onDeletedRequest(ingreso);
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
                                            Text("Se eliminó correctamente")));
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
                  updateIngreso(ingreso);
                },
              ),
            ],
          );
        });
  }

  void onClone(Ingreso ingreso) {
    ingreso.id = null;
    ScrollController sc = ScrollController();
    List<String> lisM = ["CUP", "CUC", "USD", "EUR"];
    String _value = ingreso.moneda;
    final tcontroller = TextEditingController(text: ingreso.title);
    final ccontroller =
        TextEditingController(text: formatMonedaForm(ingreso.cant));
    _inputFieldDateEdController.text =
        DateFormat('d-MMMM-yyyy', 'es').format(ingreso.fecha);
    _fecha = ingreso.fecha;
    final dcontroller = TextEditingController(text: ingreso.descripcion);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Copiar Ingreso"),
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
                              ingreso.title = value;
                            },
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              Navigator.of(context)
                                  .pushNamed("/selectingcategoria")
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
                                labelText: "Categoría",
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
                              ingreso.cant = double.parse(value);
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
                              ingreso.fecha = _fecha;
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
                              ingreso.moneda = value;
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
                              ingreso.descripcion = value;
                            },
                            decoration: InputDecoration(
                                labelText: "Descripción",
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
                  cloneIngreso(ingreso);
                },
              ),
            ],
          );
        });
  }

  Widget _getBody() {
    return StreamBuilder(
        stream: ingresoProvider.ingresosStream,
        builder: (BuildContext context, AsyncSnapshot<List<Ingreso>> snapshot) {
          if (snapshot.hasData) {
            _list = snapshot.data;
            element = groupBy(
                _list, (obj) => DateTime(obj.fecha.year, obj.fecha.month));
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
                        '${DateFormat('MMMM', "es").format(d)} ${d.year}',
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
    Ingreso i = element.values.toList()[index.section][index.index];
    Categoria c = buscarCategoria(i.title);
    int icon = c.icon;
    return IngresoWidget(
        i, onDeletedRequest, onUpdateRequest, _scalffoldkey, icon, c.color);
  }

  _monthfilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _keyfilterForm,
        child: TextFormField(
          validator: validateName,
          enableInteractiveSelection: false,
          controller: _inputFieldFilter,
          decoration: InputDecoration(
            hintText: 'Mes',
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectMonth(context, _inputFieldFilter);
          },
          onSaved: (value) {
            if (_inputFieldFilter.text.length != 0) {
              ingresoProvider.searchIngresosbyMonth(_fecha);
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
    categoriaProvider.getCategorias("ingreso").then((v) {
      _listCategories = v;
      ingresoProvider.getIngresos();
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
      return "Esta vacío";
    else
      return null;
  }

  void createIngreso(Ingreso nNombre) {
    if (_keyCreateForm.currentState.validate()) {
      _keyCreateForm.currentState.save();
      Navigator.of(context).pop();
      createCategoria(nNombre.title);
      ingresoProvider.addIngreso(nNombre);
    } else {
      setState(() {
        _validateFC = true;
      });
    }
  }

  void updateIngreso(Ingreso nNombre) {
    if (_keyUpdateForm.currentState.validate()) {
      _keyUpdateForm.currentState.save();
      Navigator.of(context).pop();
      createCategoria(nNombre.title);
      ingresoProvider.updateIngreso(nNombre);
    } else {
      setState(() {
        _validateFU = true;
      });
    }
  }

  String validateCreate(String value) {
    if (value.length == 0) return "Esta vacío";

    return null;
  }

  bool compareMonth(DateTime date1, DateTime date2) {
    if (date1.year == date2.year && date1.month == date2.month)
      return true;
    else {
      return false;
    }
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
    categoriaProvider.getCategorias("ingreso").then((v) {
      _listCategories = v;
    });
  }

  createCategoria(String title) async {
    int indixe = _listCategories
        .indexWhere((s) => s.title.toLowerCase() == title.toLowerCase());
    if (indixe == -1) {
      await categoriaProvider.addCategoria(
          Categoria(
              title: title, type: "ingreso", icon: 0, color: Color(0xff4caf50)),
          "ingreso");

      showCustomSnackBar("Se ha creado una nueva categoría", _scalffoldkey);
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
