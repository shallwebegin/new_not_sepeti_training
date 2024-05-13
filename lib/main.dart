import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_not_sepeti/models/kategori.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';
import 'package:new_not_sepeti/widgets/drawer.dart';
import 'package:new_not_sepeti/widgets/not_ekle_detay.dart';

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
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Not Sepeti'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _kategoriEkleDialog(context);
                },
                child: const Text('Kategori Ekle'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotEkleDetay(),
                    ),
                  );
                },
                child: const Text('Not Ekle'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _kategoriEkleDialog(BuildContext context) {
    String? yeniEklenecekKategoriAdi;
    final _formKey = GlobalKey<FormState>();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Kategori Ekle'),
          children: [
            Form(
              key: _formKey,
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
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      databaseHelper
                          .kategoriEkle(Kategori(yeniEklenecekKategoriAdi))
                          .then((value) => Navigator.of(context).pop());
                    }
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
