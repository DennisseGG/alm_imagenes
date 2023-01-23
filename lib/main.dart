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
import 'registro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SaveImage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

class SaveImage extends StatefulWidget {
  const SaveImage({Key? key}) : super(key: key);

  @override
  State<SaveImage> createState() => _SaveImageState();
}

class _SaveImageState extends State<SaveImage> {
  late List<Book> books;
  late dbManager dbmanager;
  late Future<File> imageFile;
  late Image image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbmanager = dbManager();
    books = [];
    refreshImages();
  }

  refreshImages() {
    dbmanager.getBooks().then((images) {
      setState(() {
        books.clear();
        books.addAll(images);
      });
    });
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
                          IconButton(
                            onPressed: () {
                              dbmanager.delete(book.id!);
                              refreshImages();
                            },
                            icon: const Icon(Icons.delete, size: 20,),
                          )
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
        title: Text("Libreria"),
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
                  Navigator.pop(context);
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Nuevo Registro"),
                trailing: Icon(Icons.add_box),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => registro()));
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: gridView(),
            )
          ],
        ),
      ),
    );
  }
}
