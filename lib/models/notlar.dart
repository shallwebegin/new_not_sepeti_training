class Notlar {
  int? notID;
  int? kategoriID;
  String? notBaslik;
  String? notIcerik;
  String? notTarih;
  int? notOncelik;

  Notlar(this.kategoriID, this.notBaslik, this.notIcerik, this.notOncelik,
      this.notTarih);

  Notlar.withID(this.kategoriID, this.notBaslik, this.notID, this.notIcerik,
      this.notOncelik, this.notTarih);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['notID'] = notID;
    map['kategoriID'] = kategoriID;
    map['notBaslik'] = notBaslik;
    map['notIcerik'] = notIcerik;
    map['notTarih'] = notTarih;
    map['notOncelik'] = notOncelik;

    return map;
  }

  Notlar.fromMap(Map<String, dynamic> map) {
    this.notID = map['notID'];
    this.kategoriID = map['kategoriID'];
    this.notBaslik = map['notBaslik'];
    this.notIcerik = map['notIcerik'];
    this.notTarih = map['notTarih'];
    this.notOncelik = map['notOncelik'];
  }
}
