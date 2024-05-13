// ignore_for_file: public_member_api_docs, sort_constructors_first
class Kategori {
  int? kategoriID;
  String? kategoriBaslik;

  Kategori(this.kategoriBaslik); // Databeden verileri eklerken kullan

  Kategori.withID(this.kategoriBaslik,
      this.kategoriID); // Databaseden verileri okurken kullan,

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['kategoriID'] = kategoriID;
    map['kategoriBaslik'] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    this.kategoriBaslik = map['kategoriBaslik'];
    this.kategoriID = map['kategoriID'];
  }

  @override
  String toString() =>
      'Kategori(kategoriID: $kategoriID, kategoriBaslik: $kategoriBaslik)';
}
