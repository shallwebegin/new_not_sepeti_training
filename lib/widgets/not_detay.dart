import 'package:flutter/material.dart';
import 'package:new_not_sepeti/models/kategori.dart';
import 'package:new_not_sepeti/models/not.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NotDetay extends StatefulWidget {
  const NotDetay({super.key, required this.baslik, this.duzenlenecekNot});
  final Not? duzenlenecekNot;
  final String baslik;

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  List<Kategori> tumKategoriler = <Kategori>[];
  final _databaseHelper = DatabaseHelper();
  int? kategoriID;
  int? secilenOncelik;
  late String notBaslik, notIcerik;
  final _formKey = GlobalKey<FormState>();
  final List _oncelik = ['Düşük', 'Orta', 'Yüksek'];
  @override
  void initState() {
    super.initState();
    _databaseHelper.kategoriGetir().then((kategorileriIcerenMap) {
      for (Map<String, dynamic> okunanMap in kategorileriIcerenMap) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }
      if (widget.duzenlenecekNot != null) {
        kategoriID = widget.duzenlenecekNot!.kategoriID;
        secilenOncelik = widget.duzenlenecekNot!.notOncelik;
      } else {
        kategoriID = 1;
        secilenOncelik = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Detay Sayfası'),
        centerTitle: true,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Kategori : ',
                      style: TextStyle(fontSize: 24),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.redAccent, width: 1)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: kategoriID,
                          items: _kategoriItemleriGetir(),
                          onChanged: (value) {
                            setState(() {
                              kategoriID = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    onSaved: (newValue) {
                      notBaslik = newValue!;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Not Baslik Giriniz',
                        labelText: 'Not Baslik'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    onSaved: (newValue) {
                      notIcerik = newValue!;
                    },
                    maxLines: 4,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Not İcerik Giriniz',
                        labelText: 'Not İcerik'),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Öncelik : ',
                      style: TextStyle(fontSize: 24),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.redAccent, width: 1)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: secilenOncelik,
                          items: _oncelik.map((oncelik) {
                            return DropdownMenuItem(
                              value: _oncelik.indexOf(oncelik),
                              child: Text(oncelik),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              secilenOncelik = value!;
                            });
                          },
                        ),
                      ),
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
                      child: const Text('Vazgeç'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.of(context).pop();
                          if (widget.duzenlenecekNot == null) {
                            _databaseHelper
                                .notEkle(Not(
                                    kategoriID,
                                    notBaslik,
                                    notIcerik,
                                    DateFormat.yMd().format(DateTime.now()),
                                    secilenOncelik))
                                .then((value) => setState(() {}));
                          } else {
                            _databaseHelper
                                .notGuncelle(
                                  Not.withID(
                                      widget.duzenlenecekNot!.notID,
                                      kategoriID,
                                      notBaslik,
                                      notIcerik,
                                      DateFormat.yMd().format(DateTime.now()),
                                      secilenOncelik),
                                )
                                .then((value) => setState(() {}));
                          }
                        }
                      },
                      child: const Text('Kaydet'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> _kategoriItemleriGetir() {
    return tumKategoriler.map((kategori) {
      return DropdownMenuItem<int>(
        value: kategori.kategoriID,
        child: Text(
          kategori.kategoriBaslik!,
          style: const TextStyle(fontSize: 24),
        ),
      );
    }).toList();
  }
}
