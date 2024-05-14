import 'package:flutter/material.dart';
import 'package:new_not_sepeti/models/kategori.dart';
import 'package:new_not_sepeti/models/not.dart';
import 'package:new_not_sepeti/pages/kategori_islemleri.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';
import 'package:new_not_sepeti/widgets/not_detay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NotSepeti(),
    );
  }
}

class NotSepeti extends StatelessWidget {
  NotSepeti({super.key});
  final _databaseHelper = DatabaseHelper();
  List<Kategori> tumKategoriler = <Kategori>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text('Kategoriler'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const KategoriIslemleri(),
                    ),
                  ),
                )
              ];
            },
          ),
        ],
        title: const Text('Not Sepeti'),
        centerTitle: true,
      ),
      floatingActionButton: ButtonBar(
        children: [
          ElevatedButton(
            onPressed: () => _detaySayfasinaGit(context),
            child: const Text('Not Ekle'),
          ),
          ElevatedButton(
            onPressed: () {
              _kategoriEkleDialog(context);
            },
            child: const Text('Kategori Ekle'),
          ),
        ],
      ),
      body: const Notlar(),
    );
  }

  void _kategoriEkleDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? girilenKategoriAdi;
    showDialog(
      barrierDismissible: true,
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
                    girilenKategoriAdi = newValue;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Kategori Adı Giriniz',
                    labelText: 'Kategori Adı',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Vazgeç'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      _databaseHelper.kategoriEkle(
                        Kategori(girilenKategoriAdi),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

void _detaySayfasinaGit(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const NotDetay(baslik: 'Yeni Not'),
    ),
  );
}

class Notlar extends StatefulWidget {
  const Notlar({super.key});

  @override
  State<Notlar> createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  final _databaseHelper = DatabaseHelper();
  List<Not> tumNotlar = <Not>[];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _databaseHelper.notlarinListesiniGetir(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          tumNotlar = snapshot.data!;
          return ListView.builder(
            itemCount: tumNotlar.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                leading: _oncelikIconuAta(index),
                title: Text(
                  tumNotlar[index].notBaslik!,
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kategori = '),
                      Text(tumNotlar[index].kategoriBaslik!),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tarih = '),
                      Text(tumNotlar[index].notTarih!)
                    ],
                  ),
                  const Text('Not içeriği'),
                  Text(tumNotlar[index].notIcerik!),
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _databaseHelper
                              .notSil(tumNotlar[index].notID!)
                              .then((value) => setState(() {}));
                        },
                        child: const Text('Sil'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _detaySayfasinaGit(context, tumNotlar[index]),
                        child: const Text('Güncelle'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotDetay(
          baslik: 'Yeni Not',
          duzenlenecekNot: not,
        ),
      ),
    );
  }

  _oncelikIconuAta(int secilenOncelik) {
    switch (secilenOncelik) {
      case 0:
        return CircleAvatar(
          backgroundColor: Colors.redAccent.shade200,
          child: const Text('Az'),
        );
      case 1:
        return CircleAvatar(
          backgroundColor: Colors.redAccent.shade400,
          child: const Text('Orta'),
        );
      case 2:
        CircleAvatar(
          backgroundColor: Colors.redAccent.shade700,
          child: const Text('Acil'),
        );

        break;
      default:
    }
  }
}
