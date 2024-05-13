import 'package:flutter/material.dart';
import 'package:new_not_sepeti/models/kategori.dart';
import 'package:new_not_sepeti/models/notlar.dart';
import 'package:new_not_sepeti/pages/not.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';

class NotGuncelle extends StatefulWidget {
  const NotGuncelle({super.key, required this.duzenlenecekNot});

  final Notlar duzenlenecekNot;

  @override
  State<NotGuncelle> createState() => _NotGuncelleState();
}

class _NotGuncelleState extends State<NotGuncelle> {
  final _databaseHelper = DatabaseHelper();
  List<Kategori> tumKategoriler = <Kategori>[];
  int secilenKategori = 1;
  int secilenOncelik = 0;
  String? notBaslik, notIcerik;
  final List _oncelik = ['Düşük', 'Orta', 'Yüksek'];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _databaseHelper.kategorileriGetir().then((kategorileriIcerenMap) {
      for (Map<String, dynamic> okunanMap in kategorileriIcerenMap) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Not Guncelle'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Kategori : ',
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                      items: _kategoriItemleriniGetir(),
                      value: secilenKategori,
                      onChanged: (value) {
                        setState(() {
                          secilenKategori = value!;
                        });
                      },
                    )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  onSaved: (newValue) {
                    notBaslik = newValue;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Not Baslik ',
                      labelText: 'Not Baslik Giriniz'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  onSaved: (newValue) {
                    notIcerik = newValue;
                  },
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Not Icerik Giriniz',
                      labelText: 'Not Icerik'),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Öncelik : ',
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                      items: _oncelik.map((oncelik) {
                        return DropdownMenuItem(
                          child: Text(oncelik, style: TextStyle(fontSize: 24)),
                          value: _oncelik.indexOf(oncelik),
                        );
                      }).toList(),
                      value: secilenOncelik,
                      onChanged: (value) {
                        setState(() {
                          secilenOncelik = value!;
                        });
                      },
                    )),
                  ),
                ],
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Vazgeç'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _databaseHelper
                            .notGuncelle(
                          Notlar.withID(
                              secilenKategori,
                              notBaslik,
                              widget.duzenlenecekNot.notID,
                              notIcerik,
                              secilenOncelik,
                              DateTime.now().toString()),
                        )
                            .then((value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NotListesiDetay(),
                            ),
                          );
                        });

                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Kaydet'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> _kategoriItemleriniGetir() {
    return tumKategoriler.map((kategori) {
      return DropdownMenuItem<int>(
        value: kategori.kategoriID,
        child: Text(
          kategori.kategoriBaslik!,
          style: TextStyle(fontSize: 24),
        ),
      );
    }).toList();
  }
}
