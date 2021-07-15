import 'package:flutter/material.dart';
import 'package:gesting/util/icons.dart';

class SelectCategory extends StatefulWidget {
  final indexpara;
  SelectCategory(this.indexpara);

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  bool selected = false;
  int indexselect = 0;
  @override
  void initState() {
    super.initState();
    indexselect = widget.indexpara;
  }

  List<int> iconskey = icons.keys.toList();
  List<IconData> iconsValue = icons.values.toList();

  @override
  Widget build(BuildContext context) {
    final r = ModalRoute.of(context).settings.arguments;

    if (r != null) indexselect = r;

    final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop((indexselect));
              })
        ],
        title: Text("Seleccione categoría"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.of(context).pop((indexselect));
        },
      ),
      body: Container(padding: EdgeInsets.symmetric(horizontal: 5),
        child: GridView.builder(
            itemCount: icons.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.6),
            ),
            itemBuilder: (BuildContext context, int index) {
              return Card( shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  color: index == indexselect
                      ? Colors.green.withOpacity(0.6)
                      : null,
                  child: InkWell(  borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      setState(() {
                        indexselect = index;
                      });
                    },
                    child: Icon(
                      icons[index],
                      size: 40,
                      color: !darkModeOn
                          ? index == indexselect ? Colors.white : Colors.black54
                          : Colors.white,
                    ),
                  ));
            }),
      ),
    );
  }
}
