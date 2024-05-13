import 'package:flutter/material.dart';
import 'package:new_not_sepeti/models/kategori.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({super.key});

  @override
  State<Kategoriler> createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Kategori> tumKategoriler = <Kategori>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Kategoriler'),
      ),
      body: FutureBuilder(
        future: _databaseHelper.kategorilerinListesiniGetir(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            tumKategoriler = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: tumKategoriler.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.2),
                            width: 0.8,
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.category),
                          title: Text(tumKategoriler[index].kategoriBaslik!),
                          trailing: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.7,
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _databaseHelper
                                        .kategoriSil(
                                            tumKategoriler[index].kategoriID!)
                                        .then((value) => setState(() {}));
                                  },
                                  child: const Text('Sil'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _kategoriGuncelle(tumKategoriler[index]);
                                  },
                                  child: const Text('Güncelle'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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

  void _kategoriGuncelle(Kategori kategoriGuncelle) {
    _kategoriGuncelleDialog(context, kategoriGuncelle);
  }

  void _kategoriGuncelleDialog(
      BuildContext context, Kategori kategoriGuncelle) {
    String? yeniEklenecekKategoriAdi;
    final formKey = GlobalKey<FormState>();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Kategori Ekle'),
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (newValue) {
                    yeniEklenecekKategoriAdi = newValue;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Kategori Adı',
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
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  child: const Text('Sil'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      _databaseHelper
                          .kategoriGuncelle(Kategori.withID(
                              yeniEklenecekKategoriAdi,
                              kategoriGuncelle.kategoriID))
                          .then((value) => setState(() {}));
                    }
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
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
