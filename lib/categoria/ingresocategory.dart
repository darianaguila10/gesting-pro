import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gesting/categoria/categoriacard.dart';
import 'package:gesting/categoria/selecolor.dart';
import 'package:gesting/categoria/selecticon.dart';
import 'package:gesting/database/models/categoria.dart';
import 'package:gesting/provider/categoria_provider.dart';

class IngresosCategory extends StatefulWidget {
  IngresosCategory({Key key}) : super(key: key);

  @override
  _IngresosCategoryState createState() => _IngresosCategoryState();
}

GlobalKey<ScaffoldState> _scalffoldkey = GlobalKey();

class _IngresosCategoryState extends State<IngresosCategory> {
  final categoriaProvider = new CategoriaProvider();
  bool _validateFC = false;
  bool _validateFU = false;
  Categoria newcategoria = Categoria();
  GlobalKey<FormState> _keyCreateForm = new GlobalKey();
  GlobalKey<FormState> _keyUpdateForm = new GlobalKey();
  GlobalKey<FormState> _keyfilterForm = new GlobalKey();

  TextStyle estiloTexto = TextStyle(fontSize: 12, color: Colors.white);

  TextEditingController _inputFieldFilter = new TextEditingController();
  TextEditingController searchcont = new TextEditingController();
  ScrollController itemScroll = ScrollController();
  String title;

  List<Categoria> _list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scalffoldkey,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _filter(),
                  flex: 3,
                ),
                Expanded(
                  child: FlatButton(
                    child: Icon(Icons.close),
                    onPressed: () {
                      searchcont.clear();
                      _inputFieldFilter.clear();
                      FocusScope.of(context).requestFocus(new FocusNode());
                      categoriaProvider.getCategorias("ingreso");
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _getBody())
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              insert(context);
            },
            child: Icon(Icons.add)));
  }

  void insert(BuildContext context) {
    Categoria nNombre = new Categoria();
    nNombre.icon = 0;
    nNombre.color = Color(0xff4caf50);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Nueva Categoría"),
            content: SingleChildScrollView(
                child: Container(
              child: Form(
                  key: _keyCreateForm,
                  autovalidate: _validateFC,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          onSaved: (String value) {
                            nNombre.title = value;
                          },
                          maxLength: 25,
                          validator: validateName,
                          decoration: InputDecoration(
                              labelText: "Categoría:",
                              icon: Icon(Icons.category))),
                      SelectIcon(nNombre),
                      SelectColor(nNombre)
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
                  createCategory(nNombre);
                },
              ),
            ],
          );
        });
  }

  void onDeletedRequest(Categoria categoria) {
    categoriaProvider.deleteCategoria(categoria, "ingreso");
  }

  void onUpdateRequest(Categoria categoria) {
    final tcontroller = TextEditingController(text: categoria.title);
    newcategoria = Categoria(
        id: categoria.id, icon: categoria.icon, color: categoria.color);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Modificar Categoría"),
            content: SingleChildScrollView(
                child: Container(
              child: Form(
                  key: _keyUpdateForm,
                  autovalidate: _validateFU,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          controller: tcontroller,
                          onSaved: (String value) {
                            categoria.title = value;
                          },
                          maxLength: 25,
                          validator: validate,
                          decoration: InputDecoration(
                              labelText: "Categoría:",
                              icon: Icon(Icons.category))),
                      SelectIcon(newcategoria),
                      SelectColor(newcategoria)
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
                                  BorderRadius.all(Radius.circular(20.0))),
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
                                onDeletedRequest(categoria);
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
                  categoria.icon = newcategoria.icon;
                  categoria.color = newcategoria.color;
                  updateCategory(categoria);
                },
              ),
            ],
          );
        });
  }

  Widget _getBody() {
    return StreamBuilder(
        stream: categoriaProvider.categoriasStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Categoria>> snapshot) {
          if (snapshot.hasData) {
            _list = snapshot.data;
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

          return AnimationLimiter(
            child: ListView.builder(
              itemCount: _list.length,
              controller: itemScroll,
              itemBuilder: (BuildContext context, index) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: ScaleAnimation(
                            child: CategoriaWidget(
                                _list[index],
                                onDeletedRequest,
                                onUpdateRequest,
                                _scalffoldkey))));
              },
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    categoriaProvider.getCategorias("ingreso");
  }

  @override
  void dispose() {
    super.dispose();
    searchcont.dispose();
    _inputFieldFilter.dispose();
  }

  String validateName(String value) {
    if (value.length == 0) return "Esta vacío";
    bool b = existC(value);

    if (b) return "Ya existe esta categoría";
    return null;
  }

  bool existC(String value) {
    int l = _list
        .where((p) {
          var title = p.title.toLowerCase();
          return title == value.toLowerCase();
        })
        .toList()
        .length;

    if (l > 0) return true;
    return false;
  }

  void createCategory(Categoria nNombre) {
    if (_keyCreateForm.currentState.validate()) {
      _keyCreateForm.currentState.save();
      Navigator.of(context).pop();
      nNombre.type = "ingreso";
      categoriaProvider.addCategoria(nNombre, "ingreso");
    } else {
      setState(() {
        _validateFC = true;
      });
    }
  }

  void updateCategory(Categoria nNombre) {
    if (_keyUpdateForm.currentState.validate()) {
      _keyUpdateForm.currentState.save();
      Navigator.of(context).pop();
      categoriaProvider.updateCategoria(nNombre, "ingreso");
    } else {
      setState(() {
        _validateFU = true;
      });
    }
  }

  _filter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _keyfilterForm,
        child: TextFormField(
          validator: validateName,
          enableInteractiveSelection: false,
          controller: _inputFieldFilter,
          decoration: InputDecoration(
            hintText: 'Categoría',
          ),
          onTap: () {},
          onChanged: (v) {
            categoriaProvider.search(v);
          },
        ),
      ),
    );
  }

  String validate(String value) {
    if (value.length == 0) return "Esta vacío";

    int l = _list
        .where((p) {
          var title = p.title.toLowerCase();
          return title == value.toLowerCase() && newcategoria.id != p.id;
        })
        .toList()
        .length;

    if (l > 0) return "Ya existe esta categoría";

    return null;
  }
}
