class Kategori {
  int? kategoriID;
  String? kategoriBaslik;

  Kategori(this.kategoriBaslik);

  Kategori.withID(this.kategoriID, this.kategoriBaslik);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['kategoriID'] = kategoriID;
    map['kategoriBaslik'] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    this.kategoriID = map['kategoriID'];
    this.kategoriBaslik = map['kategoriBaslik'];
  }
}
