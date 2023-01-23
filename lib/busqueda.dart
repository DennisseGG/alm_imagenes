import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'convert_utility.dart';
import 'dbManager.dart';
import 'book.dart';
import 'dart:io';
import 'dart:async';
import 'main.dart';
import 'registro.dart';

class busqueda extends StatefulWidget {
  const busqueda({Key? key}) : super(key: key);

  @override
  State<busqueda> createState() => _busquedaState();
}

class _busquedaState extends State<busqueda> {
  late List<Book> books;
  Future<List<Book>>? books1;
  late dbManager dbmanager;
  late Future<File> imageFile;
  late Image image;
  final formKey = GlobalKey<FormState>();

  TextEditingController _textEditingControllerUno =
      TextEditingController(text: "");
  TextEditingController _textEditingControllerDos =
      TextEditingController(text: "");
  TextEditingController _textEditingControllerTres =
      TextEditingController(text: "");
  TextEditingController _textEditingControllerCuatro =
      TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbmanager = dbManager();
    books = [];
    refreshImages();
  }

  clearData() {
    _textEditingControllerUno.text = "";
    _textEditingControllerDos.text = "";
    _textEditingControllerTres.text = "";
    _textEditingControllerCuatro.text = "";
  }

  refreshImages() {
    dbmanager
        .getBooksSpecified("name", _textEditingControllerUno.text)
        .then((images) {
      setState(() {
        books.addAll(images);
      });
    });
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _textEditingControllerUno,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Nombre del Libro',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    refreshImages();
                    clearData();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.pinkAccent,
                      )),
                  child: Icon(Icons.search_off_outlined),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: List.generate(books.length, (index) {
          int adjustedIndex = index + 1;
          return Card(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: dbmanager.getBooksForID(adjustedIndex),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Book>> snapshot) {
                      Book book = snapshot.data!
                          .firstWhere((book) => book.id == adjustedIndex);
                      return Column(
                        children: <Widget>[
                          Text(book.name!),
                          Text(book.autor_name!),
                          Text(book.editorial_name!),
                          Text(book.date!),
                          Container(
                              width: 50,
                              height: 50,
                              child: Utility.ImageFromBase64String(
                                  book.book_name!)
                          ),
                        ],
                      );
                    },
                  ),
                ]),
          );
        }),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Búsqueda"),
          centerTitle: true,
        ),
        body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            form(),
            Flexible(
              child: gridView(),
            )
          ],
        ),
    ),
    );
  }
}
