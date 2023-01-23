class Book {
  int? id;
  String? name;
  String? book_name;
  String? autor_name;
  String? editorial_name;
  String? date;

  Book(this.id, this.name, this.book_name, this.autor_name, this.editorial_name,
      this.date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "name": name,
      "book_name": book_name,
      "autor_name": autor_name,
      "editorial_name": editorial_name,
      "date": date,
    };
    return map;
  }

  Book.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    book_name = map["book_name"];
    autor_name = map["autor_name"];
    editorial_name = map["editorial_name"];
    date = map["date"];
  }
}
