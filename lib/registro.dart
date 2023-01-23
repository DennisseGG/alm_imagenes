import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'convert_utility.dart';
import 'dbManager.dart';
import 'book.dart';
import 'dart:io';
import 'dart:async';
import 'busqueda.dart';
import 'main.dart';

class registro extends StatefulWidget {
  const registro({Key? key}) : super(key: key);

  @override
  State<registro> createState() => _registroState();
}

class _registroState extends State<registro> {
  late List<Book> books;
  late dbManager dbmanager;
  late Future<File> imageFile;
  late Image image;

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
    dbmanager.getBooks().then((images) {
      setState(() {
        books.clear();
        books.addAll(images);
      });
    });
  }

  pickImageFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.gallery).then((imgFile) async {
      Uint8List? imageBytes = await imgFile?.readAsBytes();
      String imgString = Utility.base64String(imageBytes!);
      Book book = Book(
          null,
          _textEditingControllerUno.text,
          imgString,
          _textEditingControllerDos.text,
          _textEditingControllerTres.text,
          _textEditingControllerCuatro.text);
      dbmanager.save(book);
      refreshImages();
      _textEditingControllerUno.text = "";
      _textEditingControllerDos.text = "";
      _textEditingControllerTres.text = "";
      _textEditingControllerCuatro.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registro"),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text("EQUIPO 1"), accountEmail: Text("")),
              Card(
                child: ListTile(
                  title: Text("Libreria"),
                  trailing: Icon(Icons.home),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Nuevo Registro"),
                  trailing: Icon(Icons.add_box),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Busqueda"),
                  trailing: Icon(Icons.arrow_circle_right),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => busqueda()));
                  },
                ),
              ),
            ],
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(35.0),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              TextField(
                decoration: InputDecoration(hintText: "Nombre del Libro"),
                controller: _textEditingControllerUno,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Nombre del Autor"),
                controller: _textEditingControllerDos,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Nombre de la editorial"),
                controller: _textEditingControllerTres,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Fecha de Publicación"),
                controller: _textEditingControllerCuatro,
              ),
              MaterialButton(
                onPressed: () {
                  pickImageFromGallery();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: Colors.pinkAccent,
                    )),
                child: Icon(Icons.photo_library_outlined),
              ),
              MaterialButton(
                onPressed: () {
                  clearData();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.pinkAccent,
                    )),
                child: Icon(Icons.clear),
              ),
            ])));
  }
}
