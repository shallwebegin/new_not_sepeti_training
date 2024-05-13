import 'package:flutter/material.dart';
import 'package:new_not_sepeti/models/kategori.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({super.key});

  @override
  State<Kategoriler> createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  final _databaseHelper = DatabaseHelper();
  List<Kategori> tumKategoriler = <Kategori>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategoriler'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _databaseHelper.kategoriListesiniGetir(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            tumKategoriler = snapshot.data!;
            return ListView.builder(
              itemCount: tumKategoriler.length,
              itemBuilder: (context, index) {
                var ezTumKategoriler = tumKategoriler[index];
                return ListTile(
                  leading: const Icon(Icons.category),
                  title: Text(ezTumKategoriler.kategoriBaslik!),
                  trailing: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: Row(
                      children: [
                        ButtonBar(
                          children: [
                            TextButton(
                              onPressed: () {
                                kategoriSil(tumKategoriler[index].kategoriID!);
                              },
                              child: const Text('Sil'),
                            ),
                            TextButton(
                              onPressed: () {
                                _kategoriyiGuncelle(tumKategoriler[index]);
                              },
                              child: const Text('Güncelle'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  kategoriSil(int kategoriID) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
              'Seçilen Kategoriyi Silmek İstediğinize emin misiniz?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _databaseHelper.kategoriSil(kategoriID).then((value) {
                        if (value != 0) {
                          setState(() {
                            _databaseHelper.kategoriListesiniGetir();
                            Navigator.of(context).pop();
                          });
                        }
                      });
                    },
                    child: const Text('Sil'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Vazgeç'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _kategoriyiGuncelle(Kategori guncellenecekKategori) {
    _kategoriGuncelle(guncellenecekKategori);
  }

  void _kategoriGuncelle(Kategori guncellenecekKategori) {
    final formKey = GlobalKey<FormState>();
    String? guncellenecekKategoriAdi;
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Kategori Güncelle'),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: formKey,
                child: TextFormField(
                  initialValue: guncellenecekKategori.kategoriBaslik,
                  onSaved: (newValue) {
                    guncellenecekKategoriAdi = newValue!;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Kategori Adı Giriniz',
                      labelText: 'Kategori Adı'),
                ),
              ),
            ),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Sil'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      _databaseHelper
                          .kategoriGuncelle(Kategori.withID(
                              guncellenecekKategori.kategoriID,
                              guncellenecekKategoriAdi))
                          .then((value) => setState(() {}));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
