import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_not_sepeti/models/kategori.dart';
import 'package:new_not_sepeti/models/not.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';

class NotEkleDetay extends StatefulWidget {
  const NotEkleDetay({super.key});

  @override
  State<NotEkleDetay> createState() => _NotEkleDetayState();
}

class _NotEkleDetayState extends State<NotEkleDetay> {
  final _formKey = GlobalKey<FormState>();
  late DatabaseHelper databaseHelper;
  late List<Kategori> tumKategoriler;
  int secilenKategori = 1;
  int secilenOncelik = 0;
  late String notBaslik, notIcerik;

  var _oncelik = ['Düşük', 'Orta', 'Yüksek'];

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    tumKategoriler = <Kategori>[];
    databaseHelper.kategorileriGetir().then((kategorileriIcerenMap) {
      for (var kategoriMap in kategorileriIcerenMap) {
        tumKategoriler.add(Kategori.fromMap(kategoriMap));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Not Ekle'),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 22),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: _kategoriItemleriOlustur(),
                          value: secilenKategori,
                          onChanged: (value) {
                            setState(() {
                              secilenKategori = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (newValue) {
                      notBaslik = newValue!;
                    },
                    decoration: InputDecoration(
                      hintText: 'Not Başlık Giriniz',
                      labelText: 'Not Başlık',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (newValue) {
                      notIcerik = newValue!;
                    },
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Not İçerik Giriniz',
                      labelText: 'Not İçerik',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Öncelik : ',
                      style: TextStyle(fontSize: 24),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 22),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: _oncelik.map((oncelik) {
                            return DropdownMenuItem<int>(
                              child: Text(
                                oncelik,
                                style: TextStyle(fontSize: 24),
                              ),
                              value: _oncelik.indexOf(oncelik),
                            );
                          }).toList(),
                          value: secilenOncelik,
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
                          databaseHelper.notEkle(Not(
                              secilenKategori,
                              notBaslik,
                              notIcerik,
                              secilenOncelik,
                              DateFormat.yMd().format(DateTime.now())));
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

  List<DropdownMenuItem<int>> _kategoriItemleriOlustur() {
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
